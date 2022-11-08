import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/enums/gs_set_category.dart';

extension GsSetCategoryExt on GsSetCategory {
  String get label => const [
        Labels.indoor,
        Labels.outdoor,
      ][index];
}
