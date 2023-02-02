import 'package:tracker/domain/gs_domain.dart';

class InfoWeaponInfo implements IdData {
  @override
  final String id;
  final String effectName;
  final String effectDesc;
  final String matElite;
  final String matCommon;
  final String matWeapon;
  final List<String> ascAtkValues;
  final List<String> ascStatValues;
  final GsAttributeStat ascStatType;

  InfoWeaponInfo({
    required this.id,
    required this.effectName,
    required this.effectDesc,
    required this.matWeapon,
    required this.matCommon,
    required this.matElite,
    required this.ascStatType,
    required this.ascAtkValues,
    required this.ascStatValues,
  });

  factory InfoWeaponInfo.fromMap(Map<String, dynamic> map) {
    return InfoWeaponInfo(
      id: map['id'],
      effectName: map['effect_name'],
      effectDesc: map['effect_desc'],
      matWeapon: map['mat_weapon'],
      matCommon: map['mat_common'],
      matElite: map['mat_elite'],
      ascAtkValues: map.getAsStringList('asc_atk_values'),
      ascStatValues: map.getAsStringList('asc_stat_values'),
      ascStatType: GsAttributeStat.values.fromName(map['asc_stat_type'] ?? ''),
    );
  }
}
