import 'package:tracker/domain/gs_domain.dart';

class InfoRemarkableChest implements IdData {
  @override
  final String id;
  final String name;
  final GsSetCategory type;
  final String image;
  final int rarity;
  final int energy;
  final String source;
  final String version;
  final String category;

  InfoRemarkableChest.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        type = data.getGsEnum('type', GsSetCategory.values),
        image = data.getString('image'),
        rarity = data.getInt('rarity', 2),
        energy = data.getInt('energy'),
        source = data.getString('source'),
        version = data.getString('version'),
        category = data.getString('category');
}
