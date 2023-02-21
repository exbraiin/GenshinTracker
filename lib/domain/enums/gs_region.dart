import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsRegion implements GsEnum {
  none(Labels.regionNone),
  mondstadt(Labels.regionMondstadt),
  liyue(Labels.regionLiyue),
  inazuma(Labels.regionInazuma),
  sumeru(Labels.regionSumeru),
  fontaine(Labels.regionFontaine),
  natlan(Labels.regionNatlan),
  snezhnaya(Labels.regionSnezhnaya),
  khaenriah(Labels.regionKhaenriah);

  @override
  String get id => name;

  final String label;
  const GsRegion(this.label);
}
