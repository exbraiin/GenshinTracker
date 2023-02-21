import 'package:dartx/dartx.dart';
import 'package:tracker/domain/gs_domain.dart';

class InfoArtifact implements IdData {
  @override
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

  InfoArtifact.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        domain = data.getString('domain'),
        version = data.getString('version'),
        desc1Pc = data.getString('1pc'),
        desc2Pc = data.getString('2pc'),
        desc4Pc = data.getString('4pc'),
        rarity = data.getInt('rarity', 1),
        pieces = data.getModelList('pieces', InfoArtifactPiece.fromJsonData);
}

class InfoArtifactPiece {
  final String name;
  final String icon;
  final String desc;
  final GsArtifactPieces type;

  InfoArtifactPiece.fromJsonData(JsonData data)
      : name = data.getString('name'),
        icon = data.getString('icon'),
        desc = data.getString('desc'),
        type = data.getGsEnum('id', GsArtifactPieces.values);
}
