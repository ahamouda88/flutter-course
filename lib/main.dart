import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './models/product.dart';
import './pages/auth.dart';
import './pages/product.dart';
import './pages/products.dart';
import './pages/products_admin.dart';
import './scoped_models/main_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        this._isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.purpleAccent,
          buttonColor: Colors.purple,
        ),
        routes: {
          '/': (BuildContext context) =>
              _isAuthenticated ? ProductsPage(_model) : AuthPage(),
          '/admin': (BuildContext context) =>
              _isAuthenticated ? ProductsAdminPage(_model) : AuthPage(),
          '/products': (BuildContext context) =>
              _isAuthenticated ? ProductsPage(_model) : AuthPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          // Example: /product/1 => '', 'product', '1'
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') return null;

          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];

            Product product = _model.products
                .firstWhere((product) => product.id == productId);

            return MaterialPageRoute<bool>(
              builder: (context) {
                return _isAuthenticated ? ProductPage(product) : AuthPage();
              },
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) =>
                _isAuthenticated ? ProductsPage(_model) : AuthPage(),
          );
        },
      ),
    );
  }
}
