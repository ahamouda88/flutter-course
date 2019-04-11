import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductPage(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Image.asset(imageUrl),
          Container(
            child: Text(title),
            padding: EdgeInsets.all(10.0),
          ),
          Container(
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text('Delete'),
              onPressed: () => Navigator.pop(context, true),
            ),
            padding: EdgeInsets.all(5.0),
          )
        ],
      ),
    );
  }
}
