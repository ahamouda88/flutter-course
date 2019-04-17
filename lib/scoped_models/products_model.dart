import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';

class ProductsModel extends Model {
  final List<Product> _products = [];
  int _selectedProductIndex;
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

  int get selectedProductIndex {
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

  void addProduct(Product product) {
    _products.add(product);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void setSelectedProduct(int index) {
    _selectedProductIndex = index;
    notifyListeners();
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
    );
    _products[_selectedProductIndex] = newProduct;
    notifyListeners();
    _selectedProductIndex = null;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
