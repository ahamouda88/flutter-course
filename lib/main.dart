import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

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
  @override
  Widget build(BuildContext context) {
    MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.purpleAccent,
          buttonColor: Colors.purple,
        ),
        routes: {
          '/': (context) => AuthPage(),
          '/admin': (context) => ProductsAdminPage(model),
          '/products': (context) => ProductsPage(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          // Example: /product/1 => '', 'product', '1'
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') return null;

          if (pathElements[1] == 'product') {
            final int index = int.parse(pathElements[2]);

            return MaterialPageRoute<bool>(
              builder: (context) {
                return ProductPage(index);
              },
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) => ProductsPage(model),
          );
        },
      ),
    );
  }
}
