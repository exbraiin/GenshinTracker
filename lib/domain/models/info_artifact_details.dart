import 'package:tracker/domain/gs_domain.dart';

enum GsArtifactPieces {
  flowerOfLife,
  plumeOfDeath,
  sandsOfEon,
  gobletOfEonothem,
  circletOfLogos,
}

class InfoArtifactDetails implements IdData {
  final String id;
  final String name;
  final String domain;
  final String desc2Pc;
  final String desc4Pc;
  final int rarity;
  final List<InfoArtifactPiece> pieces;

  InfoArtifactDetails({
    required this.id,
    required this.name,
    required this.domain,
    required this.desc2Pc,
    required this.desc4Pc,
    required this.rarity,
    required this.pieces,
  });

  factory InfoArtifactDetails.fromMap(String id, Map<String, dynamic> map) {
    return InfoArtifactDetails(
      id: id,
      name: map['name'],
      domain: map['domain'],
      desc2Pc: map['2pc'],
      desc4Pc: map['4pc'],
      rarity: map['rarity'],
      pieces: (map['pieces'] as Map<String, dynamic>)
          .entries
          .map((e) => InfoArtifactPiece.fromMap(e.key, e.value))
          .toList(),
    );
  }
}

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
