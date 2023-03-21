import 'package:tracker/domain/gs_domain.dart';

class InfoCharacterInfo implements IdData<InfoCharacterInfo> {
  @override
  final String id;
  final InfoCharacterAscension ascension;
  final List<InfoCharacterTalent> talents;
  final List<InfoCharacterConstellation> constellations;

  InfoCharacterInfo.fromJsonData(JsonData data)
      : id = data.getString('id'),
        ascension = InfoCharacterAscension.fromJsonData(data),
        talents = data.getModelListAsList(
          'talents',
          InfoCharacterTalent.fromJsonData,
        ),
        constellations = data.getModelListAsList(
          'constellations',
          InfoCharacterConstellation.fromJsonData,
        );

  @override
  int compareTo(InfoCharacterInfo other) {
    return id.compareTo(other.id);
  }
}

class InfoCharacterTalent {
  final String name;
  final String type;
  final String icon;
  final String desc;

  InfoCharacterTalent.fromJsonData(JsonData data)
      : name = data.getString('name'),
        type = data.getString('type'),
        icon = data.getString('icon'),
        desc = data.getString('desc');
}

class InfoCharacterConstellation {
  final String name;
  final String icon;
  final String desc;

  InfoCharacterConstellation.fromJsonData(JsonData data)
      : name = data.getString('name'),
        icon = data.getString('icon'),
        desc = data.getString('desc');
}

class InfoCharacterAscension {
  final String matGem;
  final String matBoss;
  final String matCommon;
  final String matRegion;
  final String matTalent;
  final String matWeekly;
  final List<String> ascHpValues;
  final List<String> ascAtkValues;
  final List<String> ascDefValues;
  final List<String> ascStatValues;
  final GsAttributeStat ascStatType;

  InfoCharacterAscension.fromJsonData(JsonData data)
      : matGem = data.getString('mat_gem'),
        matBoss = data.getString('mat_boss'),
        matCommon = data.getString('mat_common'),
        matRegion = data.getString('mat_region'),
        matTalent = data.getString('mat_talent'),
        matWeekly = data.getString('mat_weekly'),
        ascHpValues = data.getStringAsStringList('asc_hp_values'),
        ascAtkValues = data.getStringAsStringList('asc_atk_values'),
        ascDefValues = data.getStringAsStringList('asc_def_values'),
        ascStatValues = data.getStringAsStringList('asc_stat_values'),
        ascStatType = data.getGsEnum('asc_stat_type', GsAttributeStat.values);
}
