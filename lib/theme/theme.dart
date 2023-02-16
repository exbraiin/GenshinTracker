import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';

final _themeColors = ThemeColors.gs();
final theme = ThemeData(
  extensions: [_themeColors],
  scrollbarTheme: ScrollbarThemeData(
    thickness: MaterialStateProperty.all(0),
  ),
  fontFamily: 'Bahnschrift',
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: _themeColors.mainColor1,
  splashColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    backgroundColor: _themeColors.mainColor1,
  ),
  colorScheme: ColorScheme.light(
    background: _themeColors.mainColor1,
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: _themeColors.mainColor1,
      borderRadius: kMainRadius,
      border: Border.all(color: _themeColors.mainColor3),
    ),
    textStyle: TextStyle(
      fontSize: 12,
      color: _themeColors.almostWhite,
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.white.withOpacity(0.2),
    selectionHandleColor: Colors.white,
  ),
  canvasColor: _themeColors.mainColor1,
);

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color dimWhite;
  final Color almostWhite;
  final Color mainColor0;
  final Color mainColor1;
  final Color mainColor2;
  final Color mainColor3;

  final Color badValue;
  final Color goodValue;
  final Color setIndoor;
  final Color setOutdoor;

  ThemeColors({
    required this.dimWhite,
    required this.almostWhite,
    required this.mainColor0,
    required this.mainColor1,
    required this.mainColor2,
    required this.mainColor3,
    required this.badValue,
    required this.goodValue,
    required this.setIndoor,
    required this.setOutdoor,
  });

  ThemeColors.gs()
      : dimWhite = const Color(0x80FFFFFF),
        almostWhite = const Color(0xFFEEEEEE),
        mainColor0 = const Color(0xFF0C122E),
        mainColor1 = const Color(0xFF1E2240),
        mainColor2 = const Color(0xFF2B2F4E),
        mainColor3 = const Color(0xFF8181A6),
        badValue = Colors.orange,
        goodValue = Colors.lightGreen,
        setIndoor = const Color(0xFFA01F2E),
        setOutdoor = const Color(0xFF303671);

  ThemeColors.black()
      : dimWhite = const Color(0x80FFFFFF),
        almostWhite = const Color(0xFFEEEEEE),
        mainColor0 = const Color(0xFF000000),
        mainColor1 = const Color(0xFF111111),
        mainColor2 = const Color(0xFF222222),
        mainColor3 = const Color(0xFF333333),
        badValue = Colors.orange,
        goodValue = Colors.lightGreen,
        setIndoor = const Color(0xFFA01F2E),
        setOutdoor = const Color(0xFF303671);

  Color getPityColor(int pity, [int max = 90]) {
    final h = (1 - (pity / max)) * 120;
    return HSLColor.fromAHSL(1, h, 1, 0.6).toColor();
  }

  Color getRarityColor(int rarity) {
    return const {
          1: Color(0xFF828E98),
          2: Color(0xFF5C956B),
          3: Color(0xFF51A2B4),
          4: Color(0xFFB783C8),
          5: Color(0xFFE2AA52),
        }[rarity] ??
        Colors.transparent;
  }

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? dimWhite,
    Color? almostWhite,
    Color? mainColor0,
    Color? mainColor1,
    Color? mainColor2,
    Color? mainColor3,
    Color? badValue,
    Color? goodValue,
    Color? setIndoor,
    Color? setOutdoor,
  }) {
    return ThemeColors(
      dimWhite: dimWhite ?? this.dimWhite,
      almostWhite: almostWhite ?? this.almostWhite,
      mainColor0: mainColor0 ?? this.mainColor0,
      mainColor1: mainColor1 ?? this.mainColor1,
      mainColor2: mainColor2 ?? this.mainColor2,
      mainColor3: mainColor3 ?? this.mainColor3,
      badValue: badValue ?? this.badValue,
      goodValue: goodValue ?? this.goodValue,
      setIndoor: setIndoor ?? this.setIndoor,
      setOutdoor: setOutdoor ?? this.setOutdoor,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(
    covariant ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    if (other is! ThemeColors) return this;

    Color clerp(Color Function(ThemeColors c) selector) =>
        Color.lerp(selector(other), selector(this), t)!;

    return ThemeColors(
      dimWhite: clerp((c) => c.dimWhite),
      almostWhite: clerp((c) => c.almostWhite),
      mainColor0: clerp((c) => c.mainColor0),
      mainColor1: clerp((c) => c.mainColor1),
      mainColor2: clerp((c) => c.mainColor2),
      mainColor3: clerp((c) => c.mainColor3),
      badValue: clerp((c) => c.badValue),
      goodValue: clerp((c) => c.goodValue),
      setIndoor: clerp((c) => c.setIndoor),
      setOutdoor: clerp((c) => c.setOutdoor),
    );
  }
}

extension ThemeExt on BuildContext {
  ThemeColors get themeColors => Theme.of(this).extension<ThemeColors>()!;
}
