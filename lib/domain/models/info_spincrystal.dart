import 'package:tracker/domain/gs_domain.dart';

class InfoSpincrystal implements IdData {
  @override
  final String id;
  final int number;
  final int rarity;
  final String name;
  final String desc;
  final String region;
  final String source;
  final String version;

  bool get fromChubby => source == 'Chubby';

  InfoSpincrystal.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        desc = data.getString('desc'),
        number = data.getInt('number'),
        rarity = data.getInt('rarity', 4),
        region = data.getString('region'),
        source = data.getString('source'),
        version = data.getString('version');
}
