import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  final List<Product> _products = [];
  User _authenticatedUser;
  int _selectedProductIndex;

  void addProduct(
      String title, String description, String image, double price) {
    Product product = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);
    _products.add(product);
    notifyListeners();
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

  void updateProduct(
      String title, String description, String image, double price) {
    Product product = Product(
      title: title,
      description: description,
      image: image,
      price: price,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
    );
    _products[_selectedProductIndex] = product;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    notifyListeners();
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
