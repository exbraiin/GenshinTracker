import 'package:tracker/domain/enums/gs_weekday.dart';
import 'package:tracker/domain/gs_domain.dart';

class InfoMaterial implements IdData {
  @override
  final String id;
  final String name;
  final String desc;
  final String image;
  final String source;
  final String version;
  final int rarity;
  final int subgroup;
  final GsMaterialGroup group;
  final List<GsWeekday> weekdays;

  int get maxAmount => id == 'mora' ? 9999999999 : 9999;

  InfoMaterial.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        desc = data.getString('desc'),
        image = data.getString('image'),
        version = data.getString('version'),
        group = data.getGsEnum('group', GsMaterialGroup.values),
        rarity = data.getInt('rarity', 1),
        source = data.getString('source'),
        subgroup = data.getInt('subgroup'),
        weekdays = data.getGsEnumList('weekdays', GsWeekday.values);
}
