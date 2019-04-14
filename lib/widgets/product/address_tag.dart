import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
  final String address;

  AddressTag(this.address);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey, width: 1.0, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(address),
    );
  }
}
