import 'package:tracker/domain/gs_domain.dart';

class InfoNamecard implements IdData {
  @override
  final String id;
  final int rarity;
  final String name;
  final String desc;
  final String type;
  final String image;
  final String fullImage;
  final String obtain;
  final String version;

  InfoNamecard.fromJsonData(JsonData data)
      : id = data.getString('id'),
        rarity = data.getInt('rarity', 4),
        name = data.getString('name'),
        desc = data.getString('desc'),
        type = data.getString('type'),
        image = data.getString('image'),
        fullImage = data.getString('full_image'),
        obtain = data.getString('obtain'),
        version = data.getString('version');
}
