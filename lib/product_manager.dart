import 'package:flutter/material.dart';

import './product_control.dart';
import './products.dart';

class ProductManager extends StatefulWidget {
  final Map<String, String> initProduct;

  ProductManager({this.initProduct});

  @override
  State<StatefulWidget> createState() {
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<Map<String, String>> _products = [];

  void _addProduct(Map<String, String> newProduct) {
    setState(() {
      _products.add(newProduct);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  void initState() {
    if (widget.initProduct != null) {
      _products.add(widget.initProduct);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.all(10.0),
        child: ProductControl(_addProduct),
      ),
      Expanded(
        child: Products(_products, deleteProduct: _deleteProduct),
      )
    ]);
  }
}
