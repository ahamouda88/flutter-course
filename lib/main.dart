import 'package:flutter/material.dart';

import './pages/auth.dart';
import './pages/products.dart';
import './pages/products_admin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
        '/products': (context) => ProductsPage(),
      },
    );
  }
}
