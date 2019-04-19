import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selectedProductId;
  bool _isLoading = false;

  String getProductsEndpoint([String id]) {
    final String mainUrl =
        'https://flutter-course-cd5a9.firebaseio.com/products';

    return id == null ? mainUrl + '.json' : mainUrl + "/" + id + '.json';
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) {
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

    return http
        .post(getProductsEndpoint(), body: json.encode(productData))
        .then<bool>((http.Response response) {
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
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
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

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http.get(getProductsEndpoint()).then<Null>((
      http.Response response,
    ) {
      final List<Product> fetchedProductList = [];
      Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData != null) {
        productListData.forEach((String key, dynamic productData) {
          final Product product = Product(
              id: key,
              title: productData['title'],
              description: productData['description'],
              image: productData['image'],
              price: productData['price'],
              userId: productData['userId'],
              userEmail: productData['userEmail']);
          fetchedProductList.add(product);
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

  void toggleProductFavoriteStatus() {
    if (_selectedProductId == null) return;

    bool currentFavoriteStatus = selectedProduct.isFavourite;
    Product newProduct = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      image: selectedProduct.image,
      price: selectedProduct.price,
      isFavourite: !currentFavoriteStatus,
      userEmail: _authenticatedUser.email,
      userId: _authenticatedUser.id,
    );
    _products[selectedProductIndex] = newProduct;
    notifyListeners();
    _selectedProductId = null;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UsersModel on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: '123124', email: email, password: password);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
