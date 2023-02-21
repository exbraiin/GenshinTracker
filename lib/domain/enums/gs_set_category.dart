import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsSetCategory implements GsEnum {
  indoor(Labels.indoor),
  outdoor(Labels.outdoor);

  @override
  String get id => name;

  final String label;
  const GsSetCategory(this.label);
}
