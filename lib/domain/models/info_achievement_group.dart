import 'package:tracker/domain/gs_domain.dart';

class InfoAchievementGroup extends IdData<InfoAchievementGroup> {
  @override
  final String id;
  final String name;
  final String icon;
  final String version;
  final String namecard;
  final int rewards;
  final int achievements;

  InfoAchievementGroup.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        icon = data.getString('icon'),
        version = data.getString('version'),
        namecard = data.getString('namecard'),
        rewards = data.getInt('rewards'),
        achievements = data.getInt('achievements');
}
