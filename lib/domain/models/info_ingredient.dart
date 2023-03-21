import 'package:tracker/domain/gs_domain.dart';

class InfoIngredient implements IdData<InfoIngredient> {
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

  @override
  int compareTo(InfoIngredient other) {
    return _comparator.compare(this, other);
  }
}

final _comparator = GsComparator<InfoIngredient>([
  (a, b) => a.rarity.compareTo(b.rarity),
  (a, b) => a.name.compareTo(b.name),
]);
