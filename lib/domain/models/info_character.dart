import '../gs_domain.dart';

class InfoCharacter implements IdData {
  final String id;
  final String name;
  final String? image;
  final String version;
  final String birthday;
  final GsRegion region;
  final GsWeapon weapon;
  final GsElement element;
  final int rarity;

  InfoCharacter({
    required this.id,
    required this.name,
    required this.image,
    required this.version,
    required this.birthday,
    required this.region,
    required this.weapon,
    required this.element,
    required this.rarity,
  });

  factory InfoCharacter.fromMap(Map<String, dynamic> map) {
    return InfoCharacter(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      version: map['version'] ?? '',
      region: GsRegion.values.elementAt(map['region']),
      weapon: GsWeapon.values.elementAt(map['weapon']),
      element: GsElement.values.elementAt(map['element']),
      birthday: map['birthdate'] ?? '01-01',
      rarity: map['rarity'],
    );
  }
}
