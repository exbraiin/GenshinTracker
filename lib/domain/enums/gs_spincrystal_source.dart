import 'package:dartx/dartx.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsSpincrystalSource implements GsEnum {
  other('World', Labels.world),
  chubby('Chubby', Labels.chubby);

  @override
  final String id;
  final String label;
  const GsSpincrystalSource(this.id, this.label);

  static GsSpincrystalSource fromId(String id) =>
      GsSpincrystalSource.values.firstOrNullWhere((e) => e.id == id) ??
      GsSpincrystalSource.other;
}
