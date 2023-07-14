import 'package:tracker/domain/enums/gs_spincrystal_source.dart';
import 'package:tracker/domain/gs_domain.dart';

class InfoSpincrystal extends IdData<InfoSpincrystal> {
  @override
  final String id;
  final int number;
  final int rarity;
  final String name;
  final String desc;
  final GsRegion region;
  final GsSpincrystalSource source;
  final String version;

  bool get fromChubby => source == GsSpincrystalSource.chubby;

  InfoSpincrystal.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        desc = data.getString('desc'),
        number = data.getInt('number'),
        rarity = data.getInt('rarity', 4),
        region = data.getGsEnum('region', GsRegion.values),
        source = GsSpincrystalSource.fromId(data.getString('source')),
        version = data.getString('version');

  @override
  int compareTo(InfoSpincrystal other) {
    return number.compareTo(other.number);
  }
}
