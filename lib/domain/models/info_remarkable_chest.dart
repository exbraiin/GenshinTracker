import 'package:tracker/domain/gs_domain.dart';

class InfoRemarkableChest implements IdData {
  final String id;
  final String name;
  final GsSetCategory type;
  final String image;
  final int rarity;
  final int energy;
  final String source;
  final String version;
  final String category;

  InfoRemarkableChest({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.rarity,
    required this.energy,
    required this.source,
    required this.version,
    required this.category,
  });

  factory InfoRemarkableChest.fromMap(Map<String, dynamic> map) {
    return InfoRemarkableChest(
      id: map['id'],
      name: map['name'],
      type: GsSetCategory.values.fromName(map['type']),
      image: map['image'],
      rarity: map['rarity'],
      energy: map['energy'],
      source: map['source'],
      version: map['version'],
      category: map['category'],
    );
  }
}
