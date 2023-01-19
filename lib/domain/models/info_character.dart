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
  final GsItemSource source;

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
    required this.source,
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
      source: GsItemSource.values.fromName(map['source']),
    );
  }
}
