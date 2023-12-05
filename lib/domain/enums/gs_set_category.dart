import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsSetCategory implements GsEnum {
  indoor(Labels.indoor, Color(0xFFA01F2E), imageIndoorSet),
  outdoor(Labels.outdoor, Color(0xFF303671), imageOutdoorSet);

  @override
  String get id => name;

  final Color color;
  final String label;
  final String asset;
  const GsSetCategory(this.label, this.color, this.asset);
}
