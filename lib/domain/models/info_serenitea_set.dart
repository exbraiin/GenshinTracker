import '../gs_domain.dart';

class InfoSereniteaSet implements IdData {
  final String id;
  final String name;
  final String? image;
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

  factory InfoSereniteaSet.fromMap(Map<String, dynamic> map) {
    return InfoSereniteaSet(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      energy: map['energy'],
      category: GsSetCategory.values.elementAt(map['category']),
      chars: GsUtils.parseIds(map['chars'] as String),
    );
  }
}
