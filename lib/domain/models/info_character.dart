import 'package:tracker/domain/gs_domain.dart';

class InfoCharacter implements IdData {
  final String id;
  final String name;
  final String title;
  final String version;
  final String constellation;
  final String affiliation;
  final String specialDish;
  final String description;
  final String image;
  final String fullImage;
  final DateTime birthday;
  final DateTime releaseDate;
  final int rarity;
  final GsRegion region;
  final GsWeapon weapon;
  final GsElement element;
  final List<InfoCharacterTalent> talents;
  final List<InfoCharacterAscension> ascension;
  final List<InfoCharacterConstellation> constellations;

  GsAttributeStat get specialStat => ascension.first.valuesAfter.keys.last;

  InfoCharacter({
    required this.id,
    required this.name,
    required this.title,
    required this.version,
    required this.constellation,
    required this.affiliation,
    required this.specialDish,
    required this.description,
    required this.image,
    required this.fullImage,
    required this.birthday,
    required this.releaseDate,
    required this.rarity,
    required this.region,
    required this.weapon,
    required this.element,
    required this.talents,
    required this.ascension,
    required this.constellations,
  });

  factory InfoCharacter.fromMap(Map<String, dynamic> map) {
    return InfoCharacter(
      id: map['id'],
      name: map['name'],
      title: map['title'],
      version: map['version'],
      constellation: map['constellation'],
      affiliation: map['affiliation'],
      specialDish: map['special_dish'],
      description: map['description'],
      image: map['image'],
      fullImage: map['full_image'],
      birthday: DateTime.tryParse(map['birthday'] ?? '') ?? DateTime(0),
      releaseDate: DateTime.tryParse(map['release_date'] ?? '') ?? DateTime(0),
      rarity: map['rarity'],
      region: GsRegion.values.fromName(map['region']),
      weapon: GsWeapon.values.fromName(map['weapon']),
      element: GsElement.values.fromName(map['element']),
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
  final Map<GsAttributeStat, double> valuesAfter;
  final Map<GsAttributeStat, double> valuesBefore;

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
          GsAttributeStat.values.firstWhere(
            (e) => e.name == key,
            orElse: () => GsAttributeStat.none,
          ),
          _toDouble(value),
        ),
      ),
      valuesBefore: (map['values_before'] as Map? ?? {}).map(
        (key, value) => MapEntry(
          GsAttributeStat.values.firstWhere(
            (e) => e.name == key,
            orElse: () => GsAttributeStat.none,
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
