import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/enums/gs_element.dart';

extension GsElementExt on GsElement {
  Color get color => const [
        Color(0xFF33CCB3),
        Color(0xFFCFA726),
        Color(0xFFD376F0),
        Color(0xFF77AD2D),
        Color(0xFF1C72FD),
        Color(0xFFE2311D),
        Color(0xFF98C8E8),
      ][index];

  String get label => const [
        Labels.elAnemo,
        Labels.elGeo,
        Labels.elElectro,
        Labels.elDendro,
        Labels.elHydro,
        Labels.elPyro,
        Labels.elCryo,
      ][index];
}
