import 'package:dartx/dartx.dart';
import 'package:tracker/domain/gs_domain.dart';

class InfoCharacterDetails implements IdData {
  final String id;
  final List<InfoCharacterTalent> talents;
  final List<InfoAscension> ascension;
  final List<InfoCharacterConstellation> constellations;
  final List<Map<String, int>> talentMaterials;

  /// Gets all talents materials.
  Map<String, int> get allTalentMaterials => talentMaterials
      .expand((e) => e.entries)
      .groupBy((e) => e.key)
      .map((k, v) => MapEntry(k, v.sumBy((e) => e.value).toInt() * 3));

  /// Gets all ascension materials.
  Map<String, int> get allAscensionMaterials => ascension
      .expand((e) => e.materials.entries)
      .groupBy((e) => e.key)
      .map((k, v) => MapEntry(k, v.sumBy((e) => e.value).toInt()));

  /// Gets both talent and ascension materials
  Map<String, int> get allMaterials => [
        ...talentMaterials
            .expand((e) => e.entries)
            .map((e) => MapEntry(e.key, e.value * 3)),
        ...ascension.expand((e) => e.materials.entries),
      ]
          .groupBy((e) => e.key)
          .map((k, v) => MapEntry(k, v.sumBy((e) => e.value).toInt()));

  GsAttributeStat get specialStat =>
      ascension.firstOrNull?.valuesAfter.keys.except([
        GsAttributeStat.hp,
        GsAttributeStat.atk,
        GsAttributeStat.def
      ]).firstOrNull ??
      GsAttributeStat.none;

  InfoCharacterDetails({
    required this.id,
    required this.talents,
    required this.ascension,
    required this.constellations,
    required this.talentMaterials,
  });

  factory InfoCharacterDetails.fromMap(Map<String, dynamic> map) {
    return InfoCharacterDetails(
      id: map['id'],
      talents: (map['talents'] as List)
          .map((e) => InfoCharacterTalent.fromMap(e))
          .toList(),
      ascension: (map['ascension'] as List)
          .map((e) => InfoAscension.fromMap(e))
          .toList(),
      constellations: (map['constellations'] as List)
          .map((e) => InfoCharacterConstellation.fromMap(e))
          .toList(),
      talentMaterials: (map['talents_materials'] as List)
          .map((e) => (e as Map).cast<String, int>())
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
