import 'package:flutter/material.dart';

const String primaryFontName = 'Manrope';

class TextStyleClass {
  static const double textHeight = 1.4;

 
  static TextStyle manrope400TextStyle(double fontSize, Color color) {
    return TextStyle(
        fontFamily: primaryFontName,
        color: color,
        fontWeight: FontWeight.w400,
        height: textHeight,
        fontSize: fontSize);
  }

  static TextStyle manrope500TextStyle(double fontSize, Color color) {
    return TextStyle(
        fontFamily: primaryFontName,
        color: color,
        fontWeight: FontWeight.w500,
        height: textHeight,
        fontSize: fontSize);
  }

  static TextStyle manrope600TextUnderline(double fontSize, Color color) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      decoration: TextDecoration.underline,
      decorationThickness: 0.7,
    );
  }

  static TextStyle manrope600TextStyle(double fontSize, Color color) {
    return TextStyle(
        fontFamily: primaryFontName,
        color: color,
        fontWeight: FontWeight.w600,
        height: textHeight,
        fontSize: fontSize);
  }

  static TextStyle manrope700TextStyle(double fontSize, Color color) {
    return TextStyle(
        fontFamily: primaryFontName,
        color: color,
        fontWeight: FontWeight.w700,
        height: textHeight,
        fontSize: fontSize);
  }
}
