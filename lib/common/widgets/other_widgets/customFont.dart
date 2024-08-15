// custom_font.dart
import 'package:flutter/material.dart';

class CustomFont {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  // final TextDirection? textDirection;
  final TextAlign? textAlign;

  CustomFont({
    required this.text,
    this.color,
    this.fontWeight,
    // this.textDirection,
    this.textAlign,
  });

  TextStyle _textStyle(double size) {
    return TextStyle(
      fontSize: size,
      color: color ?? Colors.black,
      fontWeight:fontWeight,
      // height: 2
    );
  }


  Widget extraSmall() {
    return Text(
      text,
      style: _textStyle(10.0),
      textAlign: textAlign,
    );
  }

  Widget small() {
    return Text(
      text,
      style: _textStyle(12.0),
      textAlign: textAlign,
    );
  }

  Widget medium() {
    return Text(
      text,
      style: _textStyle(14.0),
      textAlign: textAlign,
    );
  }
  Widget mediumHigh() {
    return Text(
      text,
      style: _textStyle(14.0),
      textAlign: textAlign,
    );
  }

  Widget large() {
    return Text(
      text,
      style: _textStyle(17.0),
      textAlign: textAlign,
    );
  }

  Widget extraLarge() {
    return Text(
      text,
      style: _textStyle(22.0),
      textAlign: textAlign,
    );
  }
}
