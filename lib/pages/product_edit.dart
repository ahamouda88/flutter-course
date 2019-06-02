import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped_models/main_model.dart';
import '../widgets/form_inputs/image_input.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _titleTextController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'imageUrl': 'assets/food.jpg'
  };

  Widget _buildTitleTextField(Product product) {
    if (product != null) {
      if (_titleTextController.text.trim() == '') {
        _titleTextController.text = product.title;
      }
    } else {
      _titleTextController.text = '';
    }
    return TextFormField(
        decoration: InputDecoration(labelText: 'Product Title'),
        controller: _titleTextController,
        validator: (String value) {
          if (value.trim().length < 5) {
            return 'Title is Required and should be 5+ chars!';
          }
        });
  }

  Widget _buildDescriptionTextField(Product product) {
    if (product != null) {
      if (_descriptionTextController.text.trim() == '') {
        _descriptionTextController.text = product.description;
      }
    } else {
      _descriptionTextController.text = '';
    }
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Description'),
      maxLines: 4,
      controller: _descriptionTextController,
      validator: (String value) {
        if (value.trim().length < 5) {
          return 'Description is Required and should be 10+ chars!';
        }
      },
    );
  }

  Widget _buildPriceTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Price'),
      keyboardType: TextInputType.number,
      initialValue: product == null ? '' : product.price.toString(),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is Required and should be a number!';
        }
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function selectProduct,
      [int selectedProductIndex]) {
    if (!_globalKey.currentState.validate()) return;
    _globalKey.currentState.save();

    if (selectedProductIndex == -1) {
      addProduct(
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['imageUrl'],
        _formData['price'],
      ).then((bool success) {
        _navigateToProducts(success, selectProduct);
      });
    } else {
      updateProduct(
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['imageUrl'],
        _formData['price'],
      ).then((bool success) {
        _navigateToProducts(success, selectProduct);
      });
    }
  }

  void _navigateToProducts(bool success, Function selectProduct) {
    if (success) {
      Navigator.pushReplacementNamed(context, '/products')
          .then((_) => selectProduct(null));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Something went wrong!'),
            content: Text('Please try again.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  Widget _buildSubmitButton(MainModel model) {
    return model.isLoading
        ? Center(child: CircularProgressIndicator())
        : RaisedButton(
            textColor: Colors.white,
            child: Text('Save'),
            onPressed: () => _submitForm(
                  model.addProduct,
                  model.updateProduct,
                  model.setSelectedProduct,
                  model.selectedProductIndex,
                ),
          );
  }

  Widget _buildPageContent(BuildContext context, MainModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Product product = model.selectedProduct;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _globalKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(height: 10.0),
              ImageInput(),
              SizedBox(height: 10.0),
              _buildSubmitButton(model),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent = _buildPageContent(context, model);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(title: Text('Edit Product')), body: pageContent);
      },
    );
  }
}
