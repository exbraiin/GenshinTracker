import 'package:dartx/dartx.dart';
import 'package:tracker/domain/gs_domain.dart';

/// The artifact pieces
enum GsArtifactPieces implements GsEnum {
  /// 0 - Flower of life
  flowerOfLife('flower_of_life'),

  /// 1 - Plume of death
  plumeOfDeath('plume_of_death'),

  /// 2 - Sands of Eon
  sandsOfEon('sands_of_eon'),

  /// 3 - Goblet of Eonothem
  gobletOfEonothem('goblet_of_eonothem'),

  /// 4 - Circlet of Logos
  circletOfLogos('circlet_of_logos');

  @override
  final String id;
  const GsArtifactPieces(this.id);

  static GsArtifactPieces fromId(String id) =>
      GsArtifactPieces.values.firstOrNullWhere((e) => e.id == id) ??
      GsArtifactPieces.flowerOfLife;
}
