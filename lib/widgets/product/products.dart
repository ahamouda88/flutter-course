import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.dart';
import '../../scoped_models/products_model.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    return products.isEmpty
        ? Center(
            child: Text('Please add products!'),
          )
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ProductCard(products[index], index),
            itemCount: products.length,
          );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return _buildProductList(model.displayedProducts);
      },
    );
  }
}
