import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/enums/gs_region.dart';

extension GsRegionExt on GsRegion {
  String get label => const [
        Labels.regionNone,
        Labels.regionMondstadt,
        Labels.regionLiyue,
        Labels.regionInazuma,
        Labels.regionSumeru,
        Labels.regionFontaine,
        Labels.regionNatlan,
        Labels.regionSnezhnaya,
        Labels.regionKhaenriah,
      ][index];
}
