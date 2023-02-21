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

  InfoWeaponInfo.fromJsonData(JsonData data)
      : id = data.getString('id'),
        effectName = data.getString('effect_name'),
        effectDesc = data.getString('effect_desc'),
        matElite = data.getString('mat_elite'),
        matCommon = data.getString('mat_common'),
        matWeapon = data.getString('mat_weapon'),
        ascAtkValues = data.getStringAsStringList('asc_atk_values'),
        ascStatValues = data.getStringAsStringList('asc_stat_values'),
        ascStatType = data.getGsEnum('asc_stat_type', GsAttributeStat.values);
}
