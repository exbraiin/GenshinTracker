import 'package:tracker/domain/gs_domain.dart';

class InfoRecipe extends IdData<InfoRecipe> {
  @override
  final String id;
  final String name;
  final String description;
  final String version;
  final String image;
  final String baseRecipe;
  final String effectDesc;
  final int rarity;
  final GsRecipeType type;
  final GsRecipeBuff effect;
  final Map<String, int> ingredients;

  int get maxProficiency => (rarity * 5).clamp(0, 25);

  InfoRecipe.fromJsonData(JsonData data)
      : id = data.getString('id'),
        name = data.getString('name'),
        image = data.getString('image'),
        rarity = data.getInt('rarity', 1),
        version = data.getString('version'),
        description = data.getString('desc'),
        baseRecipe = data.getString('base_recipe'),
        effectDesc = data.getString('effect_desc'),
        type = data.getGsEnum('type', GsRecipeType.values),
        effect = data.getGsEnum('effect', GsRecipeBuff.values),
        ingredients = data.getMap<String, int>('ingredients');

  @override
  List<Comparator<InfoRecipe>> get comparators => [
        (a, b) => b.rarity.compareTo(a.rarity),
        (a, b) => a.name.compareTo(b.name),
      ];
}
