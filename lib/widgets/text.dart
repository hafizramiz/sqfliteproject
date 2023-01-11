import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  TextWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );;
  }
}
