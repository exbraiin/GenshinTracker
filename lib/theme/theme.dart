import 'package:flutter/material.dart';

const defaultFontFamily = 'Comfortaa';
final _themeColors = ThemeColors.defaultTheme();
final _textStyle = ThemeStyles.defaultTheme(_themeColors);
final theme = ThemeData(
  extensions: [_themeColors, _textStyle],
  scrollbarTheme: ScrollbarThemeData(
    thickness: MaterialStateProperty.all(0),
  ),
  fontFamily: defaultFontFamily,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: _themeColors.mainColor1,
  splashColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    backgroundColor: _themeColors.mainColor1,
  ),
  colorScheme: ColorScheme.dark(
    background: _themeColors.mainColor1,
  ),
  tooltipTheme: TooltipThemeData(
    preferBelow: false,
    enableFeedback: false,
    excludeFromSemantics: true,
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: _themeColors.almostWhite,
      borderRadius: BorderRadius.circular(1000),
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    ),
    textStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  sliderTheme: SliderThemeData(
    activeTickMarkColor: Colors.grey,
    valueIndicatorColor: Colors.white,
    valueIndicatorTextStyle: _textStyle.label14n.copyWith(color: Colors.black),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.white.withOpacity(0.2),
    selectionHandleColor: Colors.white,
  ),
  canvasColor: _themeColors.mainColor1,
);

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color primary;
  final Color dimWhite;
  final Color almostWhite;
  final Color mainColor0;
  final Color mainColor1;

  final Color divider;
  final Color badValue;
  final Color goodValue;
  final Color setIndoor;
  final Color setOutdoor;

  Color get primary60 => Color.lerp(Colors.black, primary, 0.6)!;
  Color get primary80 => Color.lerp(Colors.black, primary, 0.8)!;

  ThemeColors({
    required this.primary,
    required this.dimWhite,
    required this.almostWhite,
    required this.mainColor0,
    required this.mainColor1,
    required this.divider,
    required this.badValue,
    required this.goodValue,
    required this.setIndoor,
    required this.setOutdoor,
  });

  ThemeColors.defaultTheme()
      : primary = Colors.teal,
        dimWhite = const Color(0xFFCCCCCC),
        almostWhite = const Color(0xFFEEEEEE),
        mainColor0 = const Color(0xFF0C122E),
        mainColor1 = const Color(0xFF1E2240),
        divider = Colors.grey.withOpacity(0.2),
        badValue = Colors.orange,
        goodValue = Colors.lightGreen,
        setIndoor = const Color(0xFFA01F2E),
        setOutdoor = const Color(0xFF303671);

  ThemeColors.darkTheme()
      : primary = Color.lerp(Colors.black, Colors.cyan, 0.6)!,
        dimWhite = const Color(0x80FFFFFF),
        almostWhite = const Color(0xFFEEEEEE),
        mainColor0 = const Color(0xFF1E1F22),
        mainColor1 = const Color(0xFF2B2D31),
        divider = Colors.grey.withOpacity(0.2),
        badValue = Colors.orange,
        goodValue = Colors.lightGreen,
        setIndoor = const Color(0xFFA01F2E),
        setOutdoor = const Color(0xFF303671);

  Color getPityColor(int pity, [int max = 90]) {
    final h = (1 - (pity / max)) * 120;
    return HSLColor.fromAHSL(1, h, 1, 0.6).toColor();
  }

  Color getRarityColor(int rarity) {
    return switch (rarity) {
      1 => const Color(0xFF828E98),
      2 => const Color(0xFF5C956B),
      3 => const Color(0xFF51A2B4),
      4 => const Color(0xFFB783C8),
      5 => const Color(0xFFE2AA52),
      _ => Colors.transparent,
    };
  }

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? primary,
    Color? dimWhite,
    Color? almostWhite,
    Color? mainColor0,
    Color? mainColor1,
    Color? mainColor2,
    Color? divider,
    Color? badValue,
    Color? goodValue,
    Color? setIndoor,
    Color? setOutdoor,
  }) {
    return ThemeColors(
      primary: primary ?? this.primary,
      dimWhite: dimWhite ?? this.dimWhite,
      almostWhite: almostWhite ?? this.almostWhite,
      mainColor0: mainColor0 ?? this.mainColor0,
      mainColor1: mainColor1 ?? this.mainColor1,
      divider: divider ?? this.divider,
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
        Color.lerp(selector(this), selector(other), t)!;

    return ThemeColors(
      primary: clerp((c) => c.primary),
      dimWhite: clerp((c) => c.dimWhite),
      almostWhite: clerp((c) => c.almostWhite),
      mainColor0: clerp((c) => c.mainColor0),
      mainColor1: clerp((c) => c.mainColor1),
      divider: clerp((c) => c.divider),
      badValue: clerp((c) => c.badValue),
      goodValue: clerp((c) => c.goodValue),
      setIndoor: clerp((c) => c.setIndoor),
      setOutdoor: clerp((c) => c.setOutdoor),
    );
  }
}

class ThemeStyles extends ThemeExtension<ThemeStyles> {
  /// 14 | normal | dimWhite
  final TextStyle emptyState;

  /// 24 | normal | white
  final TextStyle title24n;

  /// 20 | normal | white
  final TextStyle title20n;

  /// 18 | notmal | white
  final TextStyle title18n;

  /// 16 | normal | white
  final TextStyle label16n;

  /// 14 | normal | white
  final TextStyle label14n;

  /// 12 | normal | white
  final TextStyle label12n;

  /// 12 | italic | white
  final TextStyle label12i;

  /// 12 | bold | white
  final TextStyle label12b;

  /// 12 | bold | black
  final TextStyle fgLabel12b;

  ThemeStyles({
    required this.emptyState,
    required this.title24n,
    required this.title20n,
    required this.title18n,
    required this.label16n,
    required this.label14n,
    required this.label12n,
    required this.label12i,
    required this.label12b,
    required this.fgLabel12b,
  });

  ThemeStyles.defaultTheme(ThemeColors colors)
      : emptyState = _style(14, colors.dimWhite),
        title24n = _style(24, Colors.white),
        title20n = _style(20, Colors.white),
        title18n = _style(18, Colors.white),
        label16n = _style(16, Colors.white),
        label14n = _style(14, Colors.white),
        label12n = _style(12, Colors.white),
        label12i = _style(12, colors.dimWhite, s: FontStyle.italic),
        label12b = _style(12, Colors.white, w: FontWeight.bold),
        fgLabel12b = _style(12, Colors.black87, w: FontWeight.bold);

  static TextStyle _style(
    double fontSize,
    Color color, {
    FontStyle s = FontStyle.normal,
    FontWeight w = FontWeight.normal,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontStyle: s,
      fontWeight: w,
      fontFamily: defaultFontFamily,
    );
  }

  @override
  ThemeExtension<ThemeStyles> copyWith() {
    return this;
  }

  @override
  ThemeExtension<ThemeStyles> lerp(
    covariant ThemeExtension<ThemeStyles>? other,
    double t,
  ) {
    if (other is! ThemeStyles) return this;

    TextStyle tlerp(TextStyle Function(ThemeStyles c) selector) =>
        TextStyle.lerp(selector(this), selector(other), t)!;

    return ThemeStyles(
      emptyState: tlerp((c) => c.emptyState),
      title24n: tlerp((c) => c.title24n),
      title20n: tlerp((c) => c.title20n),
      title18n: tlerp((c) => c.title18n),
      label16n: tlerp((c) => c.label16n),
      label14n: tlerp((c) => c.label14n),
      label12n: tlerp((c) => c.label12n),
      label12i: tlerp((c) => c.label12i),
      label12b: tlerp((c) => c.label12b),
      fgLabel12b: tlerp((c) => c.fgLabel12b),
    );
  }
}

extension ThemeExt on BuildContext {
  ThemeColors get themeColors => Theme.of(this).extension<ThemeColors>()!;
  ThemeStyles get themeStyles => Theme.of(this).extension<ThemeStyles>()!;
}

extension TextStyleExt on TextStyle {
  StrutStyle toStrut() => StrutStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
}
