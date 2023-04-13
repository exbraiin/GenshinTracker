import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsElement implements GsEnum {
  anemo(Labels.elAnemo, Color(0xFF33CCB3)),
  geo(Labels.elGeo, Color(0xFFCFA726)),
  electro(Labels.elElectro, Color(0xFFD376F0)),
  dendro(Labels.elDendro, Color(0xFF77AD2D)),
  hydro(Labels.elHydro, Color(0xFF1C72FD)),
  pyro(Labels.elPyro, Color(0xFFE2311D)),
  cryo(Labels.elCryo, Color(0xFF98C8E8));

  @override
  String get id => name;
  String get assetPath => 'assets/image/element/$name.png';
  String get assetBgPath => 'assets/image/backgrounds/$name.gif';

  final Color color;
  final String label;
  const GsElement(this.label, this.color);
}
