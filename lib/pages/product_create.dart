import 'package:flutter/material.dart';

class ProductCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
          child: Text('Save'),
          onPressed: () {
            return showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: Text('This is the model'),
                  );
                });
          }),
    );
  }
}
