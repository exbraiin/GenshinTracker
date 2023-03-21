import 'package:tracker/domain/gs_domain.dart';

class InfoSereniteaSet extends IdData<InfoSereniteaSet> {
  @override
  final String id;
  final String name;
  final String image;
  final String version;
  final int rarity;
  final int energy;
  final GsSetCategory category;
  final List<String> chars;

  InfoSereniteaSet.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        image = data.getString('image'),
        version = data.getString('version'),
        rarity = data.getInt('rarity', 4),
        energy = data.getInt('energy'),
        category = data.getGsEnum('category', GsSetCategory.values),
        chars = data.getStringList('chars');

  @override
  int compareTo(InfoSereniteaSet other) {
    return _comparator.compare(this, other);
  }
}

final _comparator = GsComparator<InfoSereniteaSet>([
  (a, b) => a.category.index.compareTo(b.category.index),
  (a, b) => a.name.compareTo(b.name),
]);
