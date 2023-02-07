import '../gs_domain.dart';

class InfoSereniteaSet implements IdData {
  @override
  final String id;
  final String name;
  final String image;
  final String version;
  final int rarity;
  final int energy;
  final GsSetCategory category;
  final List<String> chars;

  InfoSereniteaSet({
    required this.id,
    required this.name,
    required this.image,
    required this.version,
    required this.rarity,
    required this.energy,
    required this.category,
    required this.chars,
  });

  factory InfoSereniteaSet.fromMap(Map<String, dynamic> map) {
    return InfoSereniteaSet(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      version: map['version'] ?? '',
      rarity: map['rarity'] ?? 4,
      energy: map['energy'],
      category: GsSetCategory.values.fromName(map['category']),
      chars: (map['chars'] as List).cast<String>(),
    );
  }
}
