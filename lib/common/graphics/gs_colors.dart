import 'package:flutter/material.dart';

class GsColors {
  GsColors._();

  // 0xff0a0a10 0xff131320 0xff1d1d30 0xff262640
  // 0xFF1a1d23 0xFF20242c 0xFF272935 0xFF353847
  // 0xFF0C122E 0xFF1E2240 0xFF2B2F4E 0xFF8181A6
  // 0xFF051015 0xFF0a1f29 0xFF0f2d3d 0xFF143d52

  static const mainColor0 = const Color(0xFF0C122E);
  static const mainColor1 = const Color(0xFF1E2240);
  static const mainColor2 = const Color(0xFF2B2F4E);
  static const mainColor3 = const Color(0xFF8181A6);

  static void generate() {
    const h = 240.0, s = 0.2;
    print(HSLColor.fromAHSL(1, h, s, 0.05));
    print(HSLColor.fromAHSL(1, h, s, 0.10));
    print(HSLColor.fromAHSL(1, h, s, 0.15));
    print(HSLColor.fromAHSL(1, h, s, 0.20));
  }

  static const dimWhite = const Color(0x80FFFFFF);
  static const almostWhite = const Color(0xFFEEEEEE);

  static Color getRarityColor(int rarity) {
    return const {
          1: Color(0xFF828E98),
          2: Color(0xFF5C956B),
          3: Color(0xFF51A2B4),
          4: Color(0xFFB783C8), // 4: Color(0xFFD28FD6),
          5: Color(0xFFE2AA52), // 5: Color(0xFFFFB13F),
        }[rarity] ??
        Colors.transparent;
  }

  static Color getPityColor(int pity, [int max = 90]) {
    final h = (1 - (pity / max)) * 120;
    return HSLColor.fromAHSL(1, h, 1, 0.6).toColor();
  }
}
