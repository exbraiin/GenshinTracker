import 'package:dartx/dartx.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_database.json.dart';
import 'package:tracker/domain/gs_domain.dart';

class CharacterAsc {
  final int level;
  final int gemAmount;
  final int bossAmount;
  final int commonAmount;
  final int regionAmount;
  final int moraAmount;

  final int gemIndex;
  final int commonIndex;

  const CharacterAsc(
    this.level,
    this.gemAmount,
    this.bossAmount,
    this.commonAmount,
    this.regionAmount,
    this.moraAmount,
    this.gemIndex,
    this.commonIndex,
  );
}

class CharacterTal {
  final int level;
  final int commonAmount;
  final int talentAmount;
  final int weeklyAmount;
  final int crownAmount;
  final int moraAmount;

  final int commonIndex;
  final int talentIndex;

  const CharacterTal(
    this.level,
    this.commonAmount,
    this.talentAmount,
    this.weeklyAmount,
    this.crownAmount,
    this.moraAmount,
    this.commonIndex,
    this.talentIndex,
  );
}

class WeaponAsc {
  final int level;
  final int moraAmount;
  final int commonAmount;
  final int eliteAmount;
  final int weaponAmount;

  final int commonIndex;
  final int eliteIndex;
  final int weaponIndex;

  const WeaponAsc(
    this.level,
    this.moraAmount,
    this.commonAmount,
    this.eliteAmount,
    this.weaponAmount,
    this.eliteIndex,
    this.commonIndex,
    this.weaponIndex,
  );
}

const _characterAscension = [
  CharacterAsc(1, 0, 0, 0, 0, 0, 0, 0),
  CharacterAsc(20, 1, 0, 3, 3, 20000, 0, 0),
  CharacterAsc(40, 3, 2, 15, 10, 40000, 1, 0),
  CharacterAsc(50, 6, 4, 12, 20, 60000, 1, 1),
  CharacterAsc(60, 3, 8, 18, 30, 80000, 2, 1),
  CharacterAsc(70, 6, 12, 12, 45, 100000, 2, 2),
  CharacterAsc(80, 6, 20, 24, 60, 120000, 3, 2),
  CharacterAsc(90, 0, 0, 0, 0, 0, 0, 0),
];
const _characterTalents = [
  CharacterTal(0, 6, 3, 0, 0, 12500, 0, 0),
  CharacterTal(0, 3, 2, 0, 0, 17500, 1, 1),
  CharacterTal(0, 4, 4, 0, 0, 25000, 1, 1),
  CharacterTal(0, 6, 6, 0, 0, 30000, 1, 1),
  CharacterTal(0, 9, 9, 0, 0, 37500, 1, 1),
  CharacterTal(0, 4, 4, 1, 0, 120000, 2, 2),
  CharacterTal(0, 6, 6, 1, 0, 260000, 2, 2),
  CharacterTal(0, 9, 12, 2, 0, 450000, 2, 2),
  CharacterTal(0, 12, 16, 2, 1, 700000, 2, 2),
];
const _weaponAscension = [
  [
    WeaponAsc(1, 0, 0, 0, 0, 0, 0, 0),
    WeaponAsc(20, 0, 1, 1, 1, 0, 0, 0),
    WeaponAsc(40, 5000, 2, 4, 1, 0, 0, 1),
    WeaponAsc(50, 5000, 2, 2, 2, 1, 1, 1),
    WeaponAsc(60, 10000, 3, 4, 1, 1, 1, 2),
    WeaponAsc(70, 0, 0, 0, 0, 0, 0, 0),
  ],
  [
    WeaponAsc(1, 0, 0, 0, 0, 0, 0, 0),
    WeaponAsc(20, 5000, 1, 1, 1, 0, 0, 0),
    WeaponAsc(40, 5000, 4, 5, 1, 0, 0, 1),
    WeaponAsc(50, 10000, 3, 3, 3, 1, 1, 1),
    WeaponAsc(60, 15000, 4, 5, 1, 1, 1, 2),
    WeaponAsc(70, 0, 0, 0, 0, 0, 0, 0),
  ],
  [
    WeaponAsc(1, 0, 0, 0, 0, 0, 0, 0),
    WeaponAsc(20, 5000, 1, 2, 2, 0, 0, 0),
    WeaponAsc(40, 10000, 5, 8, 2, 0, 0, 1),
    WeaponAsc(50, 15000, 4, 4, 4, 1, 1, 1),
    WeaponAsc(60, 20000, 6, 8, 2, 1, 1, 2),
    WeaponAsc(70, 25000, 4, 6, 4, 2, 2, 2),
    WeaponAsc(80, 30000, 8, 12, 3, 2, 2, 3),
    WeaponAsc(90, 0, 0, 0, 0, 0, 0, 0),
  ],
  [
    WeaponAsc(1, 0, 0, 0, 0, 0, 0, 0),
    WeaponAsc(20, 5000, 2, 3, 3, 0, 0, 0),
    WeaponAsc(40, 15000, 8, 12, 3, 0, 0, 1),
    WeaponAsc(50, 20000, 6, 6, 6, 1, 1, 1),
    WeaponAsc(60, 30000, 9, 12, 3, 1, 1, 2),
    WeaponAsc(70, 35000, 6, 9, 6, 2, 2, 2),
    WeaponAsc(80, 45000, 12, 18, 4, 2, 2, 3),
    WeaponAsc(90, 0, 0, 0, 0, 0, 0, 0),
  ],
  [
    WeaponAsc(1, 0, 0, 0, 0, 0, 0, 0),
    WeaponAsc(20, 10000, 3, 5, 5, 0, 0, 0),
    WeaponAsc(40, 20000, 12, 18, 5, 0, 0, 1),
    WeaponAsc(50, 30000, 9, 9, 9, 1, 1, 1),
    WeaponAsc(60, 45000, 14, 18, 5, 1, 1, 2),
    WeaponAsc(70, 55000, 9, 14, 9, 2, 2, 2),
    WeaponAsc(80, 65000, 18, 27, 6, 2, 2, 3),
    WeaponAsc(90, 0, 0, 0, 0, 0, 0, 0),
  ]
];

Map<String, int> _getMaterials<T>(
  List<T> items,
  Map<String, int Function(T i)> amounts,
  Map<String, int Function(T i)> indexes, [
  int? level,
]) {
  if (level != null) {
    final temp = items.elementAtOrNull(level);
    items = temp != null ? [temp] : [];
  }

  final db = GsDatabase.instance;
  Iterable<InfoMaterial> getGroup(String id) {
    final mat = db.infoMaterials.getItemOrNull(id);
    return mat != null ? db.infoMaterials.getSubGroup(mat) : const [];
  }

  final materials = amounts.map((k, v) => MapEntry(k, getGroup(k)));

  final total = <String, int>{};
  for (var item in items) {
    for (var entry in materials.entries) {
      final index = indexes[entry.key]?.call(item) ?? 0;
      final material = index == 0
          ? entry.value.firstOrNullWhere((e) => e.id == entry.key)
          : entry.value.elementAtOrNull(index);
      if (material == null) continue;
      final amount = amounts[entry.key]?.call(item) ?? 0;
      total[material.id] = (total[material.id] ?? 0) + amount;
    }
  }
  return total..removeWhere((key, value) => value == 0);
}

extension InfoWeaponInfoExt on JsonInfoDetails<InfoWeaponInfo> {
  List<WeaponAsc> weaponAscension(int r) => _weaponAscension[r - 1];

  /// Gets all weapon ascension materials at level.
  Map<String, int> getAscensionMaterials(String id, [int? level]) {
    final item = GsDatabase.instance.infoWeapons.getItemOrNull(id);
    final info = getItemOrNull(id);
    if (item == null || info == null) return const {};

    return _getMaterials<WeaponAsc>(
      _weaponAscension[item.rarity - 1],
      {
        'mora': (i) => i.moraAmount,
        info.matElite: (i) => i.eliteAmount,
        info.matCommon: (i) => i.commonAmount,
        info.matWeapon: (i) => i.weaponAmount,
      },
      {
        info.matElite: (i) => i.eliteIndex,
        info.matCommon: (i) => i.commonIndex,
        info.matWeapon: (i) => i.weaponIndex,
      },
      level,
    );
  }
}

extension GsDatabaseExt on JsonInfoDetails<InfoCharacterInfo> {
  List<CharacterTal> characterTalents() => _characterTalents;
  List<CharacterAsc> characterAscension() => _characterAscension;

  List<AscendMaterial> getCharNextAscensionMats(String id) {
    final max = GsUtils.characters.isCharMaxAscended(id);
    if (max) return const [];
    final ascension = GsUtils.characters.getCharAscension(id);
    return getAscensionMaterials(id, ascension + 1)
        .entries
        .map((e) => AscendMaterial.fromId(e.key, e.value))
        .toList();
  }

  /// Gets all character ascension materials at level.
  Map<String, int> getAscensionMaterials(String id, [int? level]) {
    final info = getItemOrNull(id);
    if (info == null) return const {};

    return _getMaterials<CharacterAsc>(
      _characterAscension,
      {
        'mora': (i) => i.moraAmount,
        info.ascension.matGem: (i) => i.gemAmount,
        info.ascension.matBoss: (i) => i.bossAmount,
        info.ascension.matRegion: (i) => i.regionAmount,
        info.ascension.matCommon: (i) => i.commonAmount,
      },
      {
        info.ascension.matGem: (i) => i.gemIndex,
        info.ascension.matCommon: (i) => i.commonIndex,
      },
      level,
    );
  }

  /// Gets all character talent materials at level.
  /// * Returns materials for all 3 talents.
  Map<String, int> getTalentMaterials(String id, [int? level]) {
    final info = getItemOrNull(id);
    if (info == null) return const {};

    return _getMaterials<CharacterTal>(
      _characterTalents,
      {
        'mora': (i) => i.moraAmount,
        'crown_of_insight': (i) => i.crownAmount,
        info.ascension.matCommon: (i) => i.commonAmount,
        info.ascension.matTalent: (i) => i.talentAmount,
        info.ascension.matWeekly: (i) => i.weeklyAmount,
      },
      {
        info.ascension.matCommon: (i) => i.commonIndex,
        info.ascension.matTalent: (i) => i.talentIndex,
      },
      level,
    ).map((key, value) => MapEntry(key, value * 3));
  }

  /// Gets all character ascension and talent materials.
  Map<String, int> getAllMaterials(String id) {
    return {...getTalentMaterials(id), ...getAscensionMaterials(id)}
        .entries
        .groupBy((e) => e.key)
        .map((k, v) => MapEntry(k, v.sumBy((e) => e.value).toInt()));
  }
}
