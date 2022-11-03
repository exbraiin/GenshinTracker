import 'package:tracker/domain/gs_domain.dart';

class InfoRecipe implements IdData {
  final String id;
  final String name;
  final String description;
  final String version;
  final String image;
  final String baseRecipe;
  final String effectDesc;
  final int rarity;
  final GsRecipeBuff effect;
  final Map<String, int> ingredients;

  int get maxProficiency => (rarity * 5).clamp(0, 25);

  InfoRecipe({
    required this.id,
    required this.name,
    required this.image,
    required this.rarity,
    required this.effect,
    required this.effectDesc,
    required this.version,
    required this.description,
    required this.baseRecipe,
    required this.ingredients,
  });

  factory InfoRecipe.fromMap(Map<String, dynamic> map) {
    return InfoRecipe(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      rarity: map['rarity'],
      version: map['version'],
      description: map['desc'] ?? '',
      baseRecipe: map['base_recipe'] ?? '',
      effectDesc: map['effect_desc'] ?? '',
      effect: GsRecipeBuff.values.fromName(map['effect']),
      ingredients: (map['ingredients'] as Map<String, dynamic>? ?? {})
          .cast<String, int>(),
    );
  }
}
