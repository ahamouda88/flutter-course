import 'package:flutter/material.dart';

import './product_card.dart';
import '../../models/product_model.dart';

class Products extends StatelessWidget {
  final List<ProductModel> products;

  Products(this.products);

  Widget _buildProductList() {
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
    return _buildProductList();
  }
}
