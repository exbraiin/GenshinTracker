import 'package:tracker/common/lang/labels.dart';
import 'package:tracker/domain/gs_domain.dart';

enum GsBanner implements GsEnum {
  standard,
  character,
  weapon,
  beginner;

  @override
  String get id => name;

  String getWonLabel(int rarity) {
    return this == GsBanner.weapon && rarity == 5
        ? Labels.won7525
        : Labels.won5050;
  }

  String getLostLabel(int rarity) {
    return this == GsBanner.weapon && rarity == 5
        ? Labels.lost7525
        : Labels.lost5050;
  }
}
