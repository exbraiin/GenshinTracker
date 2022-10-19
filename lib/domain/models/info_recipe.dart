import 'package:tracker/domain/gs_domain.dart';

class InfoRecipe implements IdData {
  final String id;
  final String name;
  final String version;
  final String image;
  final int rarity;
  final GsRecipeBuff effect;

  int get maxProficiency => (rarity * 5).clamp(0, 25);

  InfoRecipe({
    required this.id,
    required this.name,
    required this.image,
    required this.rarity,
    required this.effect,
    required this.version,
  });

  factory InfoRecipe.fromMap(String id, Map<String, dynamic> map) {
    return InfoRecipe(
      id: id,
      name: map['name'],
      image: map['image'],
      rarity: map['rarity'],
      version: map['version'],
      effect: GsRecipeBuff.values.fromName(map['effect']),
    );
  }
}
