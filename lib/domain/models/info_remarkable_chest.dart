import 'package:tracker/domain/gs_domain.dart';

class InfoRemarkableChest extends IdData<InfoRemarkableChest> {
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
  final GsRegion region;

  InfoRemarkableChest.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        type = data.getGsEnum('type', GsSetCategory.values),
        image = data.getString('image'),
        rarity = data.getInt('rarity', 2),
        energy = data.getInt('energy'),
        source = data.getString('source'),
        version = data.getString('version'),
        category = data.getString('category'),
        region = data.getGsEnum('region', GsRegion.values);

  @override
  int compareTo(InfoRemarkableChest other) {
    return _comparator.compare(this, other);
  }
}

final _comparator = GsComparator<InfoRemarkableChest>([
  (a, b) => a.region.index.compareTo(b.region.index),
  (a, b) => a.rarity.compareTo(b.rarity),
  (a, b) => a.name.compareTo(b.name),
]);
