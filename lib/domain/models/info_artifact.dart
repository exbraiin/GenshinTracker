import 'package:dartx/dartx.dart';
import 'package:tracker/domain/gs_domain.dart';

class InfoArtifact implements IdData {
  final String id;
  final String name;
  final String domain;
  final String version;
  final String desc1Pc;
  final String desc2Pc;
  final String desc4Pc;
  final int rarity;
  final List<InfoArtifactPiece> pieces;

  String get image => pieces.firstOrNull?.icon ?? '';

  InfoArtifact({
    required this.id,
    required this.name,
    required this.domain,
    required this.version,
    required this.desc1Pc,
    required this.desc2Pc,
    required this.desc4Pc,
    required this.rarity,
    required this.pieces,
  });

  factory InfoArtifact.fromMap(Map<String, dynamic> map) {
    return InfoArtifact(
      id: map['id'],
      name: map['name'],
      domain: map['domain'],
      version: map['version'] ?? '',
      desc1Pc: map['1pc'] ?? '',
      desc2Pc: map['2pc'] ?? '',
      desc4Pc: map['4pc'] ?? '',
      rarity: map['rarity'],
      pieces: (map['pieces'] as Map<String, dynamic>)
          .entries
          .map((e) => InfoArtifactPiece.fromMap(e.value..['id'] = e.key))
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

  factory InfoArtifactPiece.fromMap(Map<String, dynamic> map) {
    return InfoArtifactPiece(
      name: map['name'],
      icon: map['icon'],
      desc: map['desc'],
      type: GsArtifactPieces.values.fromId(map['id']),
    );
  }
}
