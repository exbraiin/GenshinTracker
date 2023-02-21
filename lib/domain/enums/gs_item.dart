import 'package:tracker/common/lang/lang.dart';

enum GsItem {
  weapon(Labels.weapon),
  character(Labels.character);

  final String label;
  const GsItem(this.label);
}
