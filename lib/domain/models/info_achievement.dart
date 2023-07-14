import 'package:tracker/domain/gs_domain.dart';

class InfoAchievement extends IdData<InfoAchievement> {
  @override
  final String id;
  final String name;
  final GsAchievementType type;
  final String group;
  final bool hidden;
  final String version;
  final List<InfoAchievementPhase> phases;

  InfoAchievement.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        type = GsAchievementType.fromId(data.getString('type')),
        group = data.getString('group'),
        hidden = data.getBool('hidden'),
        version = data.getString('version'),
        phases = data.getModelListAsList(
          'phases',
          InfoAchievementPhase.fromJsonData,
        );
}

class InfoAchievementPhase {
  final String desc;
  final int reward;

  InfoAchievementPhase.fromJsonData(JsonData data)
      : desc = data.getString('desc'),
        reward = data.getInt('reward');
}
