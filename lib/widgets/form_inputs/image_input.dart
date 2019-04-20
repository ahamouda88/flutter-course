import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(ImageSource source) {
    ImagePicker.pickImage(maxWidth: 400.0, source: source).then((File image) {
      setState(() {
        _imageFile = image;
      });
      Navigator.pop(context);
    });
  }

  void _openImagePicker() {
    final Color mainColor = Theme.of(context).primaryColor;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text('Pick an Image',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5.0),
                FlatButton(
                  onPressed: () {
                    _getImage(ImageSource.camera);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.camera_rear, color: mainColor),
                      SizedBox(width: 5.0),
                      Text('Use Camera', style: TextStyle(color: mainColor))
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.image, color: mainColor),
                      SizedBox(width: 5.0),
                      Text('Use Gallery', style: TextStyle(color: mainColor))
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = Theme.of(context).primaryColor;
    return Column(
      children: <Widget>[
        OutlineButton(
          onPressed: _openImagePicker,
          borderSide: BorderSide(color: mainColor, width: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt, color: mainColor),
              SizedBox(width: 5.0),
              Text('Add Image', style: TextStyle(color: mainColor)),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        _imageFile == null
            ? Text('Please pick an image')
            : Image.file(
                _imageFile,
                fit: BoxFit.cover,
                height: 300.0,
                /* The device width */
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
              )
      ],
    );
  }
}
