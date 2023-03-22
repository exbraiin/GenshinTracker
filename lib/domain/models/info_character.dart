import 'package:tracker/domain/gs_domain.dart';

class InfoCharacter extends IdData<InfoCharacter> {
  @override
  final String id;
  final String enkaId;
  final String name;
  final String title;
  final String version;
  final String constellation;
  final String constellationImage;
  final String affiliation;
  final String specialDish;
  final String description;
  final String image;
  final String fullImage;
  final DateTime birthday;
  final DateTime releaseDate;
  final int rarity;
  final GsRegion region;
  final GsWeapon weapon;
  final GsElement element;
  final GsItemSource source;

  InfoCharacter.fromJsonData(JsonData data)
      : id = data.getString('id'),
        enkaId = data.getString('enka_id'),
        name = data.getString('name'),
        title = data.getString('title'),
        version = data.getString('version'),
        constellation = data.getString('constellation'),
        constellationImage = data.getString('constellation_image'),
        affiliation = data.getString('affiliation'),
        specialDish = data.getString('special_dish'),
        description = data.getString('description'),
        image = data.getString('image'),
        fullImage = data.getString('full_image'),
        birthday = data.getDate('birthday'),
        releaseDate = data.getDate('release_date'),
        rarity = data.getInt('rarity', 4),
        region = data.getGsEnum('region', GsRegion.values),
        weapon = data.getGsEnum('weapon', GsWeapon.values),
        element = data.getGsEnum('element', GsElement.values),
        source = data.getGsEnum('source', GsItemSource.values);

  @override
  List<Comparator<InfoCharacter>> get comparators => [
        (a, b) => b.rarity.compareTo(a.rarity),
        (a, b) => a.name.compareTo(b.name),
      ];
}
