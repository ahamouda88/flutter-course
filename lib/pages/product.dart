import 'package:flutter/material.dart';

import '../model/product_model.dart';

class ProductPage extends StatelessWidget {
  final ProductModel product;

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
            Image.asset(product.image),
            Container(
              child: Text(
                product.title,
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald',
                ),
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Row(
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
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
