import 'package:tracker/domain/gs_domain.dart';

class InfoCharacterDetails implements IdData {
  final String id;
  final String boss;
  final String region;
  final List<String> gems;
  final List<String> mobs;

  InfoCharacterDetails({
    required this.id,
    required this.gems,
    required this.boss,
    required this.region,
    required this.mobs,
  });

  factory InfoCharacterDetails.fromMap(Map<String, dynamic> map) {
    return InfoCharacterDetails(
      id: map['id'],
      boss: map['boss'],
      region: map['region'],
      gems: GsUtils.parseIds(map['gems']),
      mobs: GsUtils.parseIds(map['mobs']),
    );
  }
}
