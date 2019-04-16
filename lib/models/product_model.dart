import 'package:flutter/material.dart';

class ProductModel {
  final String title;
  final String description;
  final String image;
  final double price;

  ProductModel({
    @required this.title,
    @required this.description,
    @required this.image,
    @required this.price,
  });
}
