import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsItem implements GsEnum {
  weapon(Labels.weapon),
  character(Labels.character);

  @override
  String get id => name;

  final String label;
  const GsItem(this.label);
}
