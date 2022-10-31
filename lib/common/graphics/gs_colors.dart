import 'package:flutter/material.dart';

class GsColors {
  GsColors._();

  static const mainColor0 = const Color(0xFF0C122E);
  static const mainColor1 = const Color(0xFF1E2240);
  static const mainColor2 = const Color(0xFF2B2F4E);
  static const mainColor3 = const Color(0xFF8181A6);

  static const setIndoor = const Color(0xFFA01F2E);
  static const setOutdoor = const Color(0xFF303671);

  static const dimWhite = const Color(0x80FFFFFF);
  static const almostWhite = const Color(0xFFEEEEEE);

  static Color getRarityColor(int rarity) {
    return const {
          1: Color(0xFF828E98),
          2: Color(0xFF5C956B),
          3: Color(0xFF51A2B4),
          4: Color(0xFFB783C8),
          5: Color(0xFFE2AA52),
        }[rarity] ??
        Colors.transparent;
  }

  static Color getPityColor(int pity, [int max = 90]) {
    final h = (1 - (pity / max)) * 120;
    return HSLColor.fromAHSL(1, h, 1, 0.6).toColor();
  }
}
