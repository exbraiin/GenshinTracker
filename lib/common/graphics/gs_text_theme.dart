import 'package:flutter/material.dart';

extension TextThemeExt on TextTheme {
  /// TS | 45 | white | 400 | none | 0
  TextStyle get bigTitle1 => headline3!.copyWith(
        color: Colors.white,
      );

  /// TS | 24 | white | 400 | none | 0
  TextStyle get bigTitle2 => headline5!.copyWith(
        color: Colors.white,
      );

  /// TS | 20 | white | 500 | none | 0
  TextStyle get bigTitle3 => headline6!.copyWith(
        color: Colors.white,
      );

  /// TS | 16 | white | 400 | none | 0
  TextStyle get infoLabel => subtitle1!.copyWith(
        color: Colors.white,
      );

  /// TS | 12 | white 0.4 | 500 | none | 0.1
  TextStyle get description => subtitle2!.copyWith(
        color: Colors.white.withOpacity(0.4),
        fontSize: 12,
      );

  /// TS | 12 | white 0.6 | 500 | none | 0.1
  TextStyle get description2 => subtitle2!.copyWith(
        color: Colors.white.withOpacity(0.6),
        fontSize: 12,
      );

  /// TS | 14 | white | 500 | none | 0.1
  TextStyle get headerButtonLabel => subtitle2!.copyWith(
        color: Colors.white,
      );

  /// TS | 11 | white 0.7 | 500 | none | 0.1
  TextStyle get headerButtonSublabel => subtitle2!.copyWith(
        fontSize: 11,
        color: const Color(0xB3FFFFFF),
      );

  /// TS | 20 | white | 500 | none | 0
  TextStyle get cardDialogTitle => headline6!.copyWith(
        color: Colors.white,
      );

  /// TS | 12 | white | 500 | none | 0.1
  TextStyle get cardLabel => subtitle2!.copyWith(
        color: Colors.white,
        fontSize: 12,
      );

  /// TS | 34 | yellow | 400 | none | -6
  TextStyle get rarityStars => headline4!.copyWith(
        color: Colors.yellow,
        letterSpacing: -6,
      );
}
