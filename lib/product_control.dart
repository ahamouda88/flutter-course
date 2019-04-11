import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget {
  final Function addProduct;

  ProductControl(this.addProduct);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      child: Text('Press This'),
      onPressed: () {
        addProduct({'title': 'New Food', 'imageUrl': 'assets/food.jpg'});
      },
    );
  }
}
