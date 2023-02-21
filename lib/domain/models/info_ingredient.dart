import 'package:tracker/domain/gs_domain.dart';

class InfoIngredient implements IdData {
  @override
  final String id;
  final String name;
  final String desc;
  final String image;
  final String version;
  final int rarity;

  InfoIngredient.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        desc = data.getString('desc'),
        image = data.getString('image'),
        rarity = data.getInt('rarity', 1),
        version = data.getString('version');
}
