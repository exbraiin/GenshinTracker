import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/theme/theme.dart';

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
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (recipe.effect != GsRecipeBuff.none)
              Positioned(
                top: kSeparator2,
                left: kSeparator2,
                child: ItemRarityBubble(
                  size: 30,
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
                  color: savedRecipe != null
                      ? context.themeColors.goodValue
                      : context.themeColors.badValue,
                  icon: savedRecipe != null ? Icons.check : Icons.close,
                  onPress: () => GsDatabase.instance.saveRecipes.ownRecipe(
                    recipe.id,
                    own: savedRecipe == null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
