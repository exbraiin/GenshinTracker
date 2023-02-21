import 'package:tracker/domain/gs_domain.dart';

class InfoWeapon implements IdData {
  @override
  final String id;
  final String name;
  final String image;
  final String imageAscension;
  final String version;
  final String description;
  final int atk;
  final int rarity;
  final double statValue;
  final GsWeapon type;
  final GsItemSource source;
  final GsAttributeStat statType;

  InfoWeapon.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        image = data.getString('image'),
        imageAscension = data.getString('image_asc'),
        version = data.getString('version'),
        description = data.getString('desc'),
        atk = data.getInt('atk'),
        rarity = data.getInt('rarity', 1),
        statValue = data.getDouble('stat_value'),
        type = data.getGsEnum('type', GsWeapon.values),
        source = data.getGsEnum('source', GsItemSource.values),
        statType = data.getGsEnum('stat_type', GsAttributeStat.values);
}
