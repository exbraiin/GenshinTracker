import 'package:flutter/material.dart';

const kMainShadow = [
  BoxShadow(
    color: Color(0x88111111),
    blurRadius: 2,
    offset: Offset(0, 1),
  )
];

const kMainShadowWhite = [
  BoxShadow(
    color: Colors.white54,
    offset: Offset(2, 2),
    blurRadius: 2,
  ),
];

const kMainShadowBlack = [
  BoxShadow(
    color: Colors.black54,
    offset: Offset(2, 2),
    blurRadius: 2,
  ),
];

const BorderRadius kMainRadius = BorderRadius.all(Radius.circular(4));

const double kSeparator2 = 2;
const double kSeparator4 = 4;
const double kSeparator8 = 8;
const double kDisableOpacity = 0.4;
