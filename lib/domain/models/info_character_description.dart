import 'package:tracker/domain/gs_domain.dart';

class InfoCharacterDescription implements IdData {
  final String id;
  final String title;
  final String constellation;
  final String affiliation;
  final String specialDish;
  final String fullImage;
  final List<InfoCharacterTalent> talents;
  final List<InfoCharacterAscension> ascension;
  final List<InfoCharacterConstellation> constellations;

  InfoCharacterDescription({
    required this.id,
    required this.title,
    required this.constellation,
    required this.affiliation,
    required this.specialDish,
    required this.fullImage,
    required this.talents,
    required this.ascension,
    required this.constellations,
  });

  factory InfoCharacterDescription.fromMap(
      String id, Map<String, dynamic> map) {
    return InfoCharacterDescription(
      id: id,
      title: map['title'],
      constellation: map['constellation'],
      affiliation: map['affiliation'],
      specialDish: map['special_dish'],
      fullImage: map['full_image'],
      talents: (map['talents'] as List)
          .map((e) => InfoCharacterTalent.fromMap(e))
          .toList(),
      ascension: (map['ascension'] as List)
          .map((e) => InfoCharacterAscension.fromMap(e))
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

class InfoCharacterAscension {
  final int level;
  final Map<String, int> materials;
  final Map<GsWeaponStat, double> valuesAfter;
  final Map<GsWeaponStat, double> valuesBefore;

  InfoCharacterAscension({
    required this.level,
    required this.materials,
    required this.valuesAfter,
    required this.valuesBefore,
  });

  factory InfoCharacterAscension.fromMap(Map<String, dynamic> map) {
    return InfoCharacterAscension(
      level: map['level'],
      materials: (map['materials'] as Map).cast<String, int>(),
      valuesAfter: (map['values_after'] as Map? ?? {}).map(
        (key, value) => MapEntry(
          GsWeaponStat.values.firstWhere(
            (e) => e.name == key,
            orElse: () => GsWeaponStat.none,
          ),
          _toDouble(value),
        ),
      ),
      valuesBefore: (map['values_before'] as Map? ?? {}).map(
        (key, value) => MapEntry(
          GsWeaponStat.values.firstWhere(
            (e) => e.name == key,
            orElse: () => GsWeaponStat.none,
          ),
          _toDouble(value),
        ),
      ),
    );
  }
}

double _toDouble(Object obj) {
  if (obj is double) return obj;
  if (obj is int) return obj.toDouble();
  return double.tryParse(obj.toString()) ?? 0;
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