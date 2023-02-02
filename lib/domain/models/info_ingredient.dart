import 'package:tracker/domain/gs_domain.dart';

class InfoIngredient implements IdData {
  @override
  final String id;
  final String name;
  final String desc;
  final String image;
  final String version;
  final int rarity;

  InfoIngredient({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.version,
    required this.rarity,
  });

  factory InfoIngredient.fromMap(Map<String, dynamic> map) {
    return InfoIngredient(
      id: map['id'],
      name: map['name'],
      desc: map['desc'],
      image: map['image'],
      rarity: map['rarity'],
      version: map['version'],
    );
  }
}
