import 'package:tracker/domain/gs_domain.dart';

class InfoWeapon implements IdData {
  @override
  final String id;
  final String name;
  final String image;
  final String version;
  final String description;
  final int atk;
  final int rarity;
  final double statValue;
  final GsWeapon type;
  final GsItemSource source;
  final GsAttributeStat statType;

  InfoWeapon({
    required this.id,
    required this.name,
    required this.image,
    required this.version,
    required this.description,
    required this.atk,
    required this.type,
    required this.rarity,
    required this.statType,
    required this.statValue,
    required this.source,
  });

  factory InfoWeapon.fromMap(Map<String, dynamic> map) {
    return InfoWeapon(
      id: map['id'],
      atk: map['atk'],
      name: map['name'],
      image: map['image'],
      version: map['version'] ?? '',
      description: map['desc'] ?? '',
      type: GsWeapon.values.fromName(map['type']),
      rarity: map['rarity'],
      statType: GsAttributeStat.values.fromName(map['stat_type']),
      statValue: map['stat_value'],
      source: GsItemSource.values.fromName(map['source']),
    );
  }
}
