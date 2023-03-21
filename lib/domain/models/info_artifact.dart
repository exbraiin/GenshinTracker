import 'package:dartx/dartx.dart';
import 'package:tracker/domain/gs_domain.dart';

class InfoArtifact implements IdData<InfoArtifact> {
  @override
  final String id;
  final String name;
  final String domain;
  final String version;
  final String desc1Pc;
  final String desc2Pc;
  final String desc4Pc;
  final int rarity;
  final GsRegion region;
  final List<InfoArtifactPiece> pieces;

  String get image => pieces.firstOrNull?.icon ?? '';

  InfoArtifact.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        region = data.getGsEnum('region', GsRegion.values),
        domain = data.getString('domain'),
        version = data.getString('version'),
        desc1Pc = data.getString('1pc'),
        desc2Pc = data.getString('2pc'),
        desc4Pc = data.getString('4pc'),
        rarity = data.getInt('rarity', 1),
        pieces =
            data.getModelMapAsList('pieces', InfoArtifactPiece.fromJsonData);

  @override
  int compareTo(InfoArtifact other) {
    return _comparator.compare(this, other);
  }
}

final _comparator = GsComparator<InfoArtifact>([
  (a, b) => b.rarity.compareTo(a.rarity),
  (a, b) => a.region.index.compareTo(b.region.index),
  (a, b) => a.version.compareTo(b.version),
  (a, b) => a.domain.compareTo(b.domain),
  (a, b) => a.name.compareTo(b.name),
]);

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
