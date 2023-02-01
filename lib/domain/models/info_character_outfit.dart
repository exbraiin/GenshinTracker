import 'package:tracker/domain/gs_domain.dart';

class InfoCharacterOutfit implements IdData {
  @override
  final String id;
  final String name;
  final int rarity;
  final String version;
  final String character;
  final String image;
  final String fullImage;

  InfoCharacterOutfit.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? '',
        name = map['name'] ?? '',
        rarity = map['rarity'] ?? 1,
        version = map['version'] ?? '',
        character = map['character'] ?? '',
        image = map['image'] ?? '',
        fullImage = map['full_image'] ?? '';
}
