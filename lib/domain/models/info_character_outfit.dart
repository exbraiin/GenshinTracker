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

  InfoCharacterOutfit.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        rarity = data.getInt('rarity', 4),
        version = data.getString('version'),
        character = data.getString('character'),
        image = data.getString('image'),
        fullImage = data.getString('full_image');
}
