import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selectedProductIndex;
  bool _isLoading = false;

  String getProductsEndpoint([String id]) {
    final String mainUrl =
        'https://flutter-course-cd5a9.firebaseio.com/products';

    return id == null ? mainUrl + '.json' : mainUrl + "/" + id + '.json';
  }

  Future<Null> addProduct(
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
        .then((http.Response response) {
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

  int get getSelectedProductIndex {
    return _selectedProductIndex;
  }

  Product get selectedProduct {
    return _selectedProductIndex == null
        ? null
        : _products[_selectedProductIndex];
  }

  bool get showFavoritesOnly {
    return _showFavorites;
  }

  void fetchProducts() {
    _isLoading = true;
    notifyListeners();
    http.get(getProductsEndpoint()).then((
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
    });
  }

  Future<Null> updateProduct(
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
        .then((http.Response response) {
      Product product = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
      );
      _products[_selectedProductIndex] = product;
      _isLoading = false;
      notifyListeners();
    });
  }

  void deleteProduct() {
    _isLoading = true;
    final String deletedProduct = selectedProduct.id;
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
    http
        .delete(getProductsEndpoint(deletedProduct))
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void setSelectedProduct(int index) {
    _selectedProductIndex = index;
    if (index != null) {
      notifyListeners();
    }
  }

  void toggleProductFavoriteStatus() {
    if (_selectedProductIndex == null) return;

    Product currentProduct = _products[_selectedProductIndex];
    bool currentFavoriteStatus = currentProduct.isFavourite;
    Product newProduct = Product(
      title: currentProduct.title,
      description: currentProduct.description,
      image: currentProduct.image,
      price: currentProduct.price,
      isFavourite: !currentFavoriteStatus,
      userEmail: _authenticatedUser.email,
      userId: _authenticatedUser.id,
    );
    _products[_selectedProductIndex] = newProduct;
    notifyListeners();
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
