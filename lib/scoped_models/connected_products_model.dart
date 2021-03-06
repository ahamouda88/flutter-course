import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth.dart';
import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selectedProductId;
  bool _isLoading = false;
  String _apiKey = 'AIzaSyAZAVBSRwapvQbMuq-TZoUtzHTD7lqcH1s';

  String getProductsEndpoint([String id, String extraPath = '']) {
    final String mainUrl =
        'https://flutter-course-cd5a9.firebaseio.com/products';

    return id == null
        ? mainUrl + '.json?auth=${_authenticatedUser.token}'
        : mainUrl +
            "/" +
            id +
            extraPath +
            '.json?auth=${_authenticatedUser.token}';
  }
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get products {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product p) => p.isFavourite).toList();
    }
    return List.from(_products);
  }

  String get selectedProductId {
    return _selectedProductId;
  }

  Product get selectedProduct {
    return _selectedProductId == null ? null : _products[selectedProductIndex];
  }

  int get selectedProductIndex {
    return _products.indexWhere((product) => product.id == _selectedProductId);
  }

  bool get showFavoritesOnly {
    return _showFavorites;
  }

  Future<Null> fetchProducts({bool onlyForUser = false}) {
    _isLoading = true;
    notifyListeners();
    return http.get(getProductsEndpoint()).then<Null>((
      http.Response response,
    ) {
      final List<Product> fetchedProductList = [];
      Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData != null) {
        productListData.forEach((String key, dynamic productData) {
          if (!onlyForUser || _authenticatedUser.id == productData['userId']) {
            final bool isFavourite = productData['whitelistUser'] != null &&
                (productData['whitelistUser'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id);
            final Product product = Product(
                id: key,
                title: productData['title'],
                description: productData['description'],
                image: productData['image'],
                price: productData['price'],
                userId: productData['userId'],
                userEmail: productData['userEmail'],
                isFavourite: isFavourite);
            fetchedProductList.add(product);
          }
        });
        _products = fetchedProductList;
      }
      _isLoading = false;
      notifyListeners();
      _selectedProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://5.imimg.com/data5/JW/VI/MY-48809272/snickers-50g-chocolate-bar-500x500.jpg',
      'price': price,
      'userEmail': _authenticatedUser == null ? '' : _authenticatedUser.email,
      'userId': _authenticatedUser == null ? '' : _authenticatedUser.id
    };

    try {
      http.Response response = await http.post(getProductsEndpoint(),
          body: json.encode(productData));
      if (response.statusCode > 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      Product product = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser == null ? '' : _authenticatedUser.email,
          userId: _authenticatedUser == null ? '' : _authenticatedUser.id);
      _products.add(product);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://5.imimg.com/data5/JW/VI/MY-48809272/snickers-50g-chocolate-bar-500x500.jpg',
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(getProductsEndpoint(selectedProduct.id),
            body: json.encode(productData))
        .then<bool>((http.Response response) {
      Product product = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
      );
      _products[selectedProductIndex] = product;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final String deletedProduct = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selectedProductId = null;
    notifyListeners();
    return http
        .delete(getProductsEndpoint(deletedProduct))
        .then<bool>((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void setSelectedProduct(String productId) {
    _selectedProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleProductFavoriteStatus() async {
    if (_selectedProductId == null) return;

    bool currentFavoriteStatus = selectedProduct.isFavourite;
    Product newProduct = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      image: selectedProduct.image,
      price: selectedProduct.price,
      isFavourite: !currentFavoriteStatus,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
    );
    _products[selectedProductIndex] = newProduct;
    notifyListeners();
    http.Response response;
    final String whitelistUserPath = '/whitelistUser/${_authenticatedUser.id}';
    if (!currentFavoriteStatus) {
      response = await http.put(
          getProductsEndpoint(_selectedProductId, whitelistUserPath),
          body: json.encode(true));
    } else {
      response = await http
          .delete(getProductsEndpoint(_selectedProductId, whitelistUserPath));
    }
    // Rollback the local change
    if (response.statusCode != 200) {
      Product newProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        isFavourite: !currentFavoriteStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
      );
      _products[selectedProductIndex] = newProduct;
      notifyListeners();
    }
    _selectedProductId = null;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UsersModel on ConnectedProductsModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user => _authenticatedUser;
  PublishSubject<bool> get userSubject => _userSubject;

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode authMode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    String url;
    if (authMode == AuthMode.Login) {
      url =
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$_apiKey';
    } else {
      url =
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$_apiKey';
    }
    http.Response response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> responseDate = json.decode(response.body);
    bool isSuccess = true;
    String message = 'Authentication Succeeded';
    if (!responseDate.containsKey('idToken')) {
      isSuccess = false;
      if (responseDate['error']['message'] == 'EMAIL_EXISTS') {
        message = 'Authentication Failed: Email already exists!';
      } else if (responseDate['error']['message'] == 'EMAIL_NOT_FOUND') {
        message = 'Authentication Failed: Email was not found!';
      } else if (responseDate['error']['message'] == 'INVALID_PASSWORD') {
        message = 'Authentication Failed: Invalid password!';
      } else {
        message = 'Something went wrong: ${responseDate['error']['message']}';
      }
    } else {
      final String localId = responseDate['localId'];
      final String token = responseDate['idToken'];
      final String email = responseDate['email'];
      final int expiryTime = int.parse(responseDate['expiresIn']);
      _setAutoTimeout(expiryTime);
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryDate = now.add(Duration(seconds: expiryTime));
      _authenticatedUser = User(id: localId, email: email, token: token);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setString('userEmail', email);
      prefs.setString('userId', localId);
      prefs.setString('expiryTime', expiryDate.toIso8601String());
    }
    _isLoading = false;
    notifyListeners();
    return {'success': isSuccess, 'message': message};
  }

  void logout() async {
    _authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
    _authTimer.cancel();
    _userSubject.add(false);
    notifyListeners();
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.get('token');

    if (token != null) {
      final String expiryDateString = prefs.get('expiryTime');
      final DateTime now = DateTime.now();
      final DateTime expiryDate = DateTime.parse(expiryDateString);
      if (expiryDate.isAfter(now)) {
        logout();
        return;
      }
      final String email = prefs.get('userEmail');
      final String localId = prefs.get('userId');
      final int tokenLifespan = expiryDate.difference(now).inSeconds;
      _setAutoTimeout(tokenLifespan);
      _userSubject.add(true);
      _authenticatedUser = User(id: localId, email: email, token: token);
      notifyListeners();
    }
  }

  void _setAutoTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
