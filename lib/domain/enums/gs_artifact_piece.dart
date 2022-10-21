/// The artifact pieces
enum GsArtifactPieces {
  /// 0 - Flower of life
  flowerOfLife,

  /// 1 - Plume of death
  plumeOfDeath,

  /// 2 - Sands of Eon
  sandsOfEon,

  /// 3 - Goblet of Eonothem
  gobletOfEonothem,

  /// 4 - Circlet of Logos
  circletOfLogos,
}

extension GsArtifactPiecesList on List<GsArtifactPieces> {
  String toId(GsArtifactPieces piece) => const {
        GsArtifactPieces.flowerOfLife: 'flower_of_life',
        GsArtifactPieces.plumeOfDeath: 'plume_of_death',
        GsArtifactPieces.sandsOfEon: 'sands_of_eon',
        GsArtifactPieces.gobletOfEonothem: 'goblet_of_eonothem',
        GsArtifactPieces.circletOfLogos: 'circlet_of_logos',
      }[piece]!;

  GsArtifactPieces fromId(String id) => const {
        'flower_of_life': GsArtifactPieces.flowerOfLife,
        'plume_of_death': GsArtifactPieces.plumeOfDeath,
        'sands_of_eon': GsArtifactPieces.sandsOfEon,
        'goblet_of_eonothem': GsArtifactPieces.gobletOfEonothem,
        'circlet_of_logos': GsArtifactPieces.circletOfLogos,
      }[id]!;
}
