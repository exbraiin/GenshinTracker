import 'package:gsdatabase/gsdatabase.dart';

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
    (a, b) => a.dateStart.compareTo(b.dateStart),
  ]);
}

abstract class GsVersionComp {
  static final comparator = _comparator<GsVersion>([
    (a, b) => a.releaseDate.compareTo(b.releaseDate),
  ]);
}

abstract class GiWishComp {
  static final comparator = _comparator<GiWish>([
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
