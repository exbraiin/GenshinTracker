import 'package:flutter/material.dart';

class GsColors {
  GsColors._();

  static const dimWhite = Color(0x80FFFFFF);
  static const almostWhite = Color(0xFFEEEEEE);

  static Color getPityColor(int pity, [int max = 90]) {
    final h = (1 - (pity / max)) * 120;
    return HSLColor.fromAHSL(1, h, 1, 0.6).toColor();
  }
}
