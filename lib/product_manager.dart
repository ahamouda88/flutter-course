import 'package:flutter/material.dart';

import './product_control.dart';
import './products.dart';

class ProductManager extends StatefulWidget {
  final String initProduct;

  ProductManager({this.initProduct = 'Sweet Tester'});

  @override
  State<StatefulWidget> createState() {
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<String> _products = [];

  void _addProduct(String newProduct) {
    setState(() {
      _products.add(newProduct);
    });
  }

  @override
  void initState() {
    _products.add(widget.initProduct);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.all(10.0),
        child: ProductControl(_addProduct),
      ),
      Products(_products),
    ]);
  }
}
