import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';

final _themeColors = ThemeColors.rgby();
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
    ),
    textStyle: TextStyle(
      fontSize: 12,
      color: _themeColors.mainColor3,
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
  final Color mainColor0;
  final Color mainColor1;
  final Color mainColor2;
  final Color mainColor3;

  final Color badValue;
  final Color goodValue;
  final Color setIndoor;
  final Color setOutdoor;

  ThemeColors({
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
      : mainColor0 = const Color(0xFF0C122E),
        mainColor1 = const Color(0xFF1E2240),
        mainColor2 = const Color(0xFF2B2F4E),
        mainColor3 = const Color(0xFF8181A6),
        badValue = Colors.orange,
        goodValue = Colors.lightGreen,
        setIndoor = const Color(0xFFA01F2E),
        setOutdoor = const Color(0xFF303671);

  ThemeColors.rgby()
      : mainColor0 = Colors.red,
        mainColor1 = Colors.green,
        mainColor2 = Colors.blue,
        mainColor3 = Colors.yellow,
        badValue = Colors.orange,
        goodValue = Colors.lightGreen,
        setIndoor = const Color(0xFFA01F2E),
        setOutdoor = const Color(0xFF303671);

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
