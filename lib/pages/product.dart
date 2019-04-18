import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);
//  _showWarningDialog(BuildContext context) {
//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: Text('Are you sure?'),
//            content: Text('You will not be able to undone this action!'),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('DISCARD'),
//                onPressed: () => Navigator.pop(context),
//              ),
//              FlatButton(
//                child: Text('CONTINUE'),
//                onPressed: () {
//                  Navigator.pop(context);
//                  Navigator.pop(context, true);
//                },
//              ),
//            ],
//          );
//        });
//  }

  Widget _buildAddressPriceRow(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Union Square, New York City',
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey)),
        Container(
          child: Text('|', style: TextStyle(color: Colors.grey)),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
        ),
        Text('\$' + product.price.toString(),
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: Column(
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(product.image),
                placeholder: AssetImage('assets/food.jpg'),
                height: 300.0,
                fit: BoxFit.cover,
              ),
              Container(
                child: TitleDefault(product.title),
                padding: EdgeInsets.all(10.0),
              ),
              _buildAddressPriceRow(product),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
  }
}
