import 'package:flutter/material.dart';

extension TextThemeExt on TextTheme {
  TextStyle get bigTitle1 => this.headline3!.copyWith(
        color: Colors.white,
      );

  TextStyle get bigTitle2 => this.headline5!.copyWith(
        color: Colors.white,
      );

  TextStyle get bigTitle3 => this.headline6!.copyWith(
        color: Colors.white,
      );

  TextStyle get infoLabel => this.subtitle1!.copyWith(
        color: Colors.white,
      );

  /// 12 | white 0.4
  TextStyle get description => this.subtitle2!.copyWith(
        color: Colors.white.withOpacity(0.4), // Color(0xFFAAAAAA),
        fontSize: 12,
      );

  /// 12 | white 0.6
  TextStyle get description2 => this.subtitle2!.copyWith(
        color: Colors.white.withOpacity(0.6),
        fontSize: 12,
      );

  TextStyle get headerButtonLabel => this.subtitle2!.copyWith(
        color: Colors.white,
      );

  /// 11 | white70
  TextStyle get headerButtonSublabel => this.subtitle2!.copyWith(
        fontSize: 11,
        color: Colors.white70,
      );

  TextStyle get cardDialogTitle => this.headline6!.copyWith(
        color: Colors.white,
      );

  /// 12 | white
  TextStyle get cardLabel => this.subtitle2!.copyWith(
        color: Colors.white,
        fontSize: 12,
      );

  /// ?? | yellow | -6
  TextStyle get rarityStars => this.headline4!.copyWith(
        color: Colors.yellow,
        letterSpacing: -6,
      );
}
