import 'package:flutter/material.dart';

import './products.dart';

class ProductsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Choose'),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              title: Text('All Products'),
              onTap: () => {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ProductsPage()))
                  },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Manage Products'),
      ),
      body: Center(
        child: Text('My new page'),
      ),
    );
  }
}
