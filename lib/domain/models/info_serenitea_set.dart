import '../gs_domain.dart';

class InfoSereniteaSet implements IdData {
  final String id;
  final String name;
  final String image;
  final int energy;
  final GsSetCategory category;
  final List<String> chars;

  InfoSereniteaSet({
    required this.id,
    required this.name,
    required this.image,
    required this.energy,
    required this.category,
    required this.chars,
  });

  factory InfoSereniteaSet.fromMap(String id, Map<String, dynamic> map) {
    return InfoSereniteaSet(
      id: id,
      name: map['name'],
      image: map['image'],
      energy: map['energy'],
      category: GsSetCategory.values.fromName(map['category']),
      chars: (map['chars'] as List).cast<String>(),
    );
  }
}
