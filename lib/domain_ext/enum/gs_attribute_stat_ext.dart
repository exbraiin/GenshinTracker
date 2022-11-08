import 'package:tracker/common/utils.dart';
import 'package:tracker/domain/gs_domain.dart';

extension GsAttributeStatExt on GsAttributeStat {
  String toAscensionStat(InfoAscension info) {
    final after = info.valuesAfter[this];
    final before = info.valuesBefore[this];
    if (after == null && before == null) return toIntOrPercentage(0);
    if (after == null && before != null) return toIntOrPercentage(before);
    if (after != null && before == null) return toIntOrPercentage(after);
    if (after == before) return toIntOrPercentage(after!);
    return '${toIntOrPercentage(before!)} → ${toIntOrPercentage(after!)}';
  }
}
