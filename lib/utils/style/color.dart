import 'dart:ui';

import 'package:flutter/cupertino.dart';

class HexColor extends Color {
  HexColor(String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.trim().toUpperCase().replaceAll('#', '');

    if (hexColor.isEmpty) {
      throw ArgumentError('Hex color string cannot be empty');
    }

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    } else if (hexColor.length != 8) {
      throw ArgumentError('Hex color string must be 6 or 8 characters long');
    }

    return int.parse(hexColor, radix: 16);
  }
}
