import 'package:tracker/domain/gs_domain.dart';

class InfoNamecard extends IdData<InfoNamecard> {
  @override
  final String id;
  final int rarity;
  final String name;
  final String desc;
  final String image;
  final String fullImage;
  final String obtain;
  final String version;
  final GsNamecardType type;

  InfoNamecard.fromJsonData(JsonData data)
      : id = data.getString('id'),
        rarity = data.getInt('rarity', 4),
        name = data.getString('name'),
        desc = data.getString('desc'),
        type = data.getGsEnum('type', GsNamecardType.values),
        image = data.getString('image'),
        fullImage = data.getString('full_image'),
        obtain = data.getString('obtain'),
        version = data.getString('version');

  @override
  List<Comparator<InfoNamecard>> get comparators => [
        (a, b) => a.type.index.compareTo(b.type.index),
        (a, b) => a.name.compareTo(b.name),
      ];
}
