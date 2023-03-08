import 'package:flutter/material.dart';

extension TextThemeExt on TextTheme {
  /// TS | 24 | white | 400 | none | 0
  TextStyle get bigTitle2 => headlineSmall!.copyWith(
        color: Colors.white,
      );

  /// TS | 20 | white | 500 | none | 0
  TextStyle get bigTitle3 => titleLarge!.copyWith(
        color: Colors.white,
      );

  /// TS | 16 | white | 400 | none | 0
  TextStyle get infoLabel => titleMedium!.copyWith(
        color: Colors.white,
      );

  /// TS | 12 | white 0.4 | 500 | none | 0.1
  TextStyle get description => titleSmall!.copyWith(
        color: Colors.white.withOpacity(0.4),
        fontSize: 12,
      );

  /// TS | 12 | white 0.6 | 500 | none | 0.1
  TextStyle get description2 => titleSmall!.copyWith(
        color: Colors.white.withOpacity(0.6),
        fontSize: 12,
      );

  /// TS | 14 | white | 500 | none | 0.1
  TextStyle get headerButtonLabel => titleSmall!.copyWith(
        color: Colors.white,
      );

  /// TS | 20 | white | 500 | none | 0
  TextStyle get cardDialogTitle => titleLarge!.copyWith(
        color: Colors.white,
      );

  /// TS | 14 | black | 700 | none | 0.1
  TextStyle get cardLabel => titleSmall!.copyWith(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );

  TextStyle get filterLabel => titleSmall!.copyWith(
        color: Colors.white,
        fontSize: 12,
      );
}
