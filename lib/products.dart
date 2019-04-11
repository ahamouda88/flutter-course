import 'package:flutter/material.dart';

import './pages/product.dart';

class Products extends StatelessWidget {
  final List<String> products;

  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset('assets/food.jpg'),
          Text(products[index]),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return products.isEmpty
        ? Center(
            child: Text('Please add products!'),
          )
        : ListView.builder(
            itemBuilder: _buildProductItem,
            itemCount: products.length,
          );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }
}
