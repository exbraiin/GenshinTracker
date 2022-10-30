import 'package:dartx/dartx.dart';

import '../gs_domain.dart';

class InfoWeapon implements IdData {
  final String id;
  final String name;
  final String image;
  final String version;
  final String description;
  final String effectName;
  final String effectDescription;
  final int atk;
  final int rarity;
  final double statValue;
  final GsWeapon type;
  final GsAttributeStat statType;
  final List<List<String>> effectValues;
  final List<InfoCharacterAscension> ascension;

  /// Gets all ascension materials.
  Map<String, int> get allAscensionMaterials => ascension
      .expand((e) => e.materials.entries)
      .groupBy((e) => e.key)
      .map((k, v) => MapEntry(k, v.sumBy((e) => e.value).toInt()));

  InfoWeapon({
    required this.id,
    required this.name,
    required this.image,
    required this.version,
    required this.description,
    required this.effectName,
    required this.effectValues,
    required this.effectDescription,
    required this.atk,
    required this.type,
    required this.rarity,
    required this.statType,
    required this.statValue,
    required this.ascension,
  });

  factory InfoWeapon.fromMap(Map<String, dynamic> map) {
    return InfoWeapon(
      id: map['id'],
      atk: map['atk'],
      name: map['name'],
      image: map['image'],
      version: map['version'] ?? '',
      description: map['desc'] ?? '',
      effectName: map['effect_name'] ?? '',
      effectValues: (map['effect_values'] as List? ?? [])
          .cast<List>()
          .map((e) => e.cast<String>())
          .toList(),
      effectDescription: map['effect_desc'] ?? '',
      type: GsWeapon.values.fromName(map['type']),
      rarity: map['rarity'],
      statType: GsAttributeStat.values.fromName(map['stat_type']),
      statValue: map['stat_value'],
      ascension: (map['ascension'] as List? ?? [])
          .map((e) => InfoCharacterAscension.fromMap(e))
          .toList(),
    );
  }
}
