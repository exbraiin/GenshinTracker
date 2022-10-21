import '../gs_domain.dart';

class InfoWeapon implements IdData {
  final String id;
  final String name;
  final String image;
  final String version;
  final int atk;
  final int rarity;
  final double statValue;
  final GsWeapon type;
  final GsAttributeStat statType;

  InfoWeapon({
    required this.id,
    required this.name,
    required this.image,
    required this.version,
    required this.atk,
    required this.type,
    required this.rarity,
    required this.statType,
    required this.statValue,
  });

  factory InfoWeapon.fromMap(String id, Map<String, dynamic> map) {
    return InfoWeapon(
      id: id,
      atk: map['atk'],
      name: map['name'],
      image: map['image'],
      version: map['version'] ?? '',
      type: GsWeapon.values.fromName(map['type']),
      rarity: map['rarity'],
      statType: GsAttributeStat.values.fromName(map['stat_type']),
      statValue: map['stat_value'],
    );
  }
}
