import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class RecipesListItem extends StatelessWidget {
  final InfoRecipe recipe;
  final bool selected;
  final SaveRecipe? savedRecipe;
  final VoidCallback? onTap;

  const RecipesListItem({
    super.key,
    required this.recipe,
    this.selected = false,
    this.savedRecipe,
    this.onTap,
  });

  bool _hasSpecialDishChar() {
    final db = GsDatabase.instance;
    final char = db.infoCharacters
        .getItems()
        .firstOrNullWhere((e) => e.specialDish == recipe.id);
    return char != null && GsUtils.characters.hasCaracter(char.id);
  }

  @override
  Widget build(BuildContext context) {
    final isSpecial = recipe.baseRecipe.isNotEmpty;
    final hasSpecial = isSpecial && _hasSpecialDishChar();
    late final char = GsDatabase.instance.infoCharacters
        .getItems()
        .firstOrNullWhere((e) => e.specialDish == recipe.id);
    return Opacity(
      opacity: savedRecipe != null || hasSpecial ? 1 : kDisableOpacity,
      child: GsItemCardButton(
        label: recipe.name,
        rarity: recipe.rarity,
        selected: selected,
        banner: GsItemBanner.fromVersion(recipe.version),
        imageUrlPath: recipe.image,
        onTap: onTap,
        subChild: isSpecial
            ? null
            : Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    GsIconButton(
                      icon: Icons.remove,
                      size: 20,
                      onPress: (savedRecipe?.proficiency ?? 0) != 0
                          ? () =>
                              GsDatabase.instance.saveRecipes.changeSavedRecipe(
                                recipe.id,
                                ((savedRecipe?.proficiency ?? 0) - 1)
                                    .clamp(0, recipe.maxProficiency),
                              )
                          : null,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${savedRecipe?.proficiency ?? 0} / ${recipe.maxProficiency}',
                          style: context.textTheme.subtitle2!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    GsIconButton(
                      icon: Icons.add,
                      size: 20,
                      onPress: (savedRecipe?.proficiency ?? 0) !=
                              recipe.maxProficiency
                          ? () =>
                              GsDatabase.instance.saveRecipes.changeSavedRecipe(
                                recipe.id,
                                ((savedRecipe?.proficiency ?? 0) + 1)
                                    .clamp(0, recipe.maxProficiency),
                              )
                          : null,
                    ),
                  ],
                ),
              ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (recipe.effect != GsRecipeBuff.none)
              Positioned(
                top: kSeparator2,
                left: kSeparator2,
                child: GsItemCardLabel(
                  asset: recipe.effect.assetPath,
                ),
              ),
            if (isSpecial)
              Positioned(
                right: kSeparator2,
                bottom: kSeparator2,
                child: ItemRarityBubble(
                  image: GsUtils.characters.getImage(char?.id ?? ''),
                  rarity: char?.rarity ?? 1,
                ),
              ),
            if (!isSpecial)
              Positioned(
                top: kSeparator2,
                right: kSeparator2,
                child: GsIconButton(
                  size: 20,
                  color: savedRecipe != null ? Colors.green : GsColors.missing,
                  icon: savedRecipe != null ? Icons.check : Icons.close,
                  onPress: () => GsDatabase.instance.saveRecipes.ownRecipe(
                    recipe.id,
                    savedRecipe == null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
