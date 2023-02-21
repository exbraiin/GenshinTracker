import 'package:tracker/common/lang/lang.dart';

enum GsRegion {
  none(Labels.regionNone),
  mondstadt(Labels.regionMondstadt),
  liyue(Labels.regionLiyue),
  inazuma(Labels.regionInazuma),
  sumeru(Labels.regionSumeru),
  fontaine(Labels.regionFontaine),
  natlan(Labels.regionNatlan),
  snezhnaya(Labels.regionSnezhnaya),
  khaenriah(Labels.regionKhaenriah);

  final String label;
  const GsRegion(this.label);
}
