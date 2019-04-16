import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit.dart';
import '../scoped_models/products_model.dart';

class ProductListPage extends StatelessWidget {
  Widget _buildEditButton(
      BuildContext context, int index, ProductsModel model) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          model.setSelectedProduct(index);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductEditPage()),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(index.toString()),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.setSelectedProduct(index);
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
                      backgroundImage: AssetImage(model.products[index].image),
                    ),
                    title: Text(model.products[index].title),
                    subtitle:
                        Text('\$${model.products[index].price.toString()}'),
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
