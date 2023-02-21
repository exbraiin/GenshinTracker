import 'package:tracker/common/lang/lang.dart';

enum GsSetCategory {
  indoor(Labels.indoor),
  outdoor(Labels.outdoor);

  final String label;
  const GsSetCategory(this.label);
}
