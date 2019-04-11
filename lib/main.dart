import 'package:flutter/material.dart';

import './pages/auth.dart';
import './pages/product.dart';
import './pages/products.dart';
import './pages/products_admin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, String>> _products = [];

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
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.purpleAccent,
      ),
      routes: {
        '/': (context) => AuthPage(),
        '/admin': (context) => ProductsAdminPage(),
        '/products': (context) =>
            ProductsPage(_products, _addProduct, _deleteProduct),
      },
      onGenerateRoute: (RouteSettings settings) {
        // Example: /product/1 => '', 'product', '1'
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') return null;

        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);

          return MaterialPageRoute<bool>(
            builder: (context) => ProductPage(
                _products[index]['title'], _products[index]['imageUrl']),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (context) =>
                ProductsPage(_products, _addProduct, _deleteProduct));
      },
    );
  }
}
