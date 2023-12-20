import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/domain/gs_domain.dart';

extension on String? {
  DateTime get asDateTime => DateTime.tryParse(this ?? '') ?? DateTime(0);
}

extension GsBannerExt on GsBanner {
  DateTime get dateEndTime => dateEnd.asDateTime;
  DateTime get dateStartTime => dateStart.asDateTime;
}

extension GsCharacterExt on GsCharacter {
  DateTime get birthdayTime => birthday.asDateTime;
  DateTime get releaseDateTime => releaseDate.asDateTime;
}

extension GsEnemyExt on GsEnemy {
  int get rarityByType => switch (type) {
        GeEnemyType.none => 1,
        GeEnemyType.common => 2,
        GeEnemyType.elite => 3,
        GeEnemyType.normalBoss => 4,
        GeEnemyType.weeklyBoss => 5,
      };
}

abstract class GsMaterialComp {
  static final comparator = _comparator<GsMaterial>([
    (a, b) => a.group.index.compareTo(b.group.index),
    (a, b) => a.subgroup.compareTo(b.subgroup),
    (a, b) => a.region.index.compareTo(b.region.index),
    (a, b) => a.rarity.compareTo(b.rarity),
    (a, b) => a.name.compareTo(b.name),
    (a, b) => a.id.compareTo(b.id),
  ]);
}

abstract class GsBannerComp {
  static final comparator = _comparator<GsBanner>([
    (a, b) => a.dateStartTime.compareTo(b.dateStartTime),
  ]);
}

abstract class GsVersionComp {
  static final comparator = _comparator<GsVersion>([
    (a, b) => a.releaseDate.compareTo(b.releaseDate),
  ]);
}

abstract class SaveWishComp {
  static final comparator = _comparator<SaveWish>([
    (a, b) => a.date.compareTo(b.date),
    (a, b) => a.number.compareTo(b.number),
    (a, b) => a.bannerId.compareTo(b.bannerId),
    (a, b) => a.bannerDate.compareTo(b.bannerDate),
  ]);
}

Comparator<T> _comparator<T>(List<Comparator<T>> comparators) {
  return (a, b) {
    for (final comparator in comparators) {
      final result = comparator(a, b);
      if (result != 0) return result;
    }
    return 0;
  };
}
