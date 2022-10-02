import '../gs_domain.dart';

class InfoWeapon implements IdData {
  final String id;
  final String name;
  final String? image;
  final int atk;
  final int rarity;
  final double statValue;
  final GsWeapon type;
  final GsWeaponStat statType;

  String get valueString {
    final i = statValue.toInt();
    if (statValue == i) return i.toString();
    return statValue.toString();
  }

  InfoWeapon({
    required this.id,
    required this.name,
    required this.image,
    required this.atk,
    required this.type,
    required this.rarity,
    required this.statType,
    required this.statValue,
  });

  factory InfoWeapon.fromMap(Map<String, dynamic> map) {
    return InfoWeapon(
      id: map['id'],
      atk: map['atk'],
      name: map['name'],
      image: map['image'],
      type: GsWeapon.values.elementAt(map['type']),
      rarity: map['rarity'],
      statType: GsWeaponStat.values.elementAt(map['stat_type']),
      statValue: map['stat_value'],
    );
  }
}
