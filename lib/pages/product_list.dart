import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit.dart';
import '../models/product.dart';
import '../scoped_models/main_model.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          model.setSelectedProduct(model.products[index].id);
          Navigator.of(context)
              .push(
                MaterialPageRoute(builder: (context) => ProductEditPage()),
              )
              .then(
                (_) => model.setSelectedProduct(null),
              );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            Product currentProduct = model.products[index];
            return Dismissible(
              key: Key(index.toString()),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.setSelectedProduct(currentProduct.id);
                  model.deleteProduct();
                }
              },
              background: Container(
                color: Colors.grey,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(currentProduct.image),
                    ),
                    title: Text(currentProduct.title),
                    subtitle: Text('\$${currentProduct.price.toString()}'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.products.length,
        );
      },
    );
  }
}
