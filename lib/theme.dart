import "package:flutter/material.dart";

class AppTheme {
  static final colorED8514 = Color(0xffED8514);
  static final color0F1015 = Color(0xff0F1015);
  static final color979AA9 = Color(0xff979AA9);
  static final colorEDEEF0 = Color(0xffEDEEF0);
  static final colorC4C5CD = Color(0xffC4C5CD);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
