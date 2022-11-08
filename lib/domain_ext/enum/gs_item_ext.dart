import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/enums/gs_item.dart';

extension GsItemExt on GsItem {
  String get label => const [
        Labels.weapon,
        Labels.character,
      ][index];
}
