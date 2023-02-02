import 'package:tracker/domain/gs_domain.dart';

class InfoCharacterInfo implements IdData {
  @override
  final String id;
  final InfoCharacterAscension ascension;
  final List<InfoCharacterTalent> talents;
  final List<InfoCharacterConstellation> constellations;

  InfoCharacterInfo({
    required this.id,
    required this.talents,
    required this.ascension,
    required this.constellations,
  });

  factory InfoCharacterInfo.fromMap(Map<String, dynamic> map) {
    return InfoCharacterInfo(
      id: map['id'],
      ascension: InfoCharacterAscension.fromMap(map),
      talents: (map['talents'] as List)
          .map((e) => InfoCharacterTalent.fromMap(e))
          .toList(),
      constellations: (map['constellations'] as List)
          .map((e) => InfoCharacterConstellation.fromMap(e))
          .toList(),
    );
  }
}

class InfoCharacterTalent {
  final String name;
  final String type;
  final String icon;
  final String desc;

  InfoCharacterTalent({
    required this.name,
    required this.type,
    required this.icon,
    required this.desc,
  });

  factory InfoCharacterTalent.fromMap(Map<String, dynamic> map) {
    return InfoCharacterTalent(
      name: map['name'],
      type: map['type'],
      icon: map['icon'],
      desc: map['desc'],
    );
  }
}

class InfoCharacterConstellation {
  final String name;
  final String icon;
  final String desc;

  InfoCharacterConstellation({
    required this.name,
    required this.icon,
    required this.desc,
  });

  factory InfoCharacterConstellation.fromMap(Map<String, dynamic> map) {
    return InfoCharacterConstellation(
      name: map['name'],
      icon: map['icon'],
      desc: map['desc'],
    );
  }
}

class InfoCharacterAscension {
  final String matGem;
  final String matBoss;
  final String matCommon;
  final String matRegion;
  final String matTalent;
  final String matWeekly;
  final List<String> ascHpValues;
  final List<String> ascAtkValues;
  final List<String> ascDefValues;
  final List<String> ascStatValues;
  final GsAttributeStat ascStatType;

  InfoCharacterAscension.fromMap(Map<String, dynamic> map)
      : matGem = map['mat_gem'] ?? '',
        matBoss = map['mat_boss'] ?? '',
        matCommon = map['mat_common'] ?? '',
        matRegion = map['mat_region'] ?? '',
        matTalent = map['mat_talent'] ?? '',
        matWeekly = map['mat_weekly'] ?? '',
        ascHpValues = map.getAsStringList('asc_hp_values'),
        ascAtkValues = map.getAsStringList('asc_atk_values'),
        ascDefValues = map.getAsStringList('asc_def_values'),
        ascStatValues = map.getAsStringList('asc_stat_values'),
        ascStatType = GsAttributeStat.values.fromName(map['asc_stat_type']);
}
