import 'package:tracker/domain/gs_domain.dart';

class InfoArtifactPiece {
  final String name;
  final String icon;
  final String desc;
  final GsArtifactPieces type;

  InfoArtifactPiece({
    required this.name,
    required this.icon,
    required this.desc,
    required this.type,
  });

  factory InfoArtifactPiece.fromMap(String id, Map<String, dynamic> map) {
    return InfoArtifactPiece(
      name: map['name'],
      icon: map['icon'],
      desc: map['desc'],
      type: {
        'flower_of_life': GsArtifactPieces.flowerOfLife,
        'plume_of_death': GsArtifactPieces.plumeOfDeath,
        'sands_of_eon': GsArtifactPieces.sandsOfEon,
        'goblet_of_eonothem': GsArtifactPieces.gobletOfEonothem,
        'circlet_of_logos': GsArtifactPieces.circletOfLogos,
      }[id]!,
    );
  }
}
