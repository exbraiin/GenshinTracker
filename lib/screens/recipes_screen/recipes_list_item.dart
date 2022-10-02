import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class RecipesListItem extends StatelessWidget {
  final InfoRecipe recipe;
  final SaveRecipe? savedRecipe;

  RecipesListItem({
    required this.recipe,
    this.savedRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: savedRecipe != null ? 1 : kDisableOpacity,
      child: ItemCardButton(
        label: recipe.name,
        rarity: recipe.rarity,
        imageUrlPath: recipe.image,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (recipe.effect != GsRecipeBuff.none)
              Positioned(
                top: 2,
                left: 2,
                child: ItemCardLabel(
                  asset: recipe.effect.assetPath,
                ),
              ),
            Positioned(
              top: 2,
              right: 3,
              child: GsIconButton(
                size: 20,
                color: savedRecipe != null ? Colors.green : Colors.deepOrange,
                icon: savedRecipe != null ? Icons.check : Icons.close,
                onPress: () => GsDatabase.instance.saveRecipes.ownRecipe(
                  recipe.id,
                  savedRecipe == null,
                ),
              ),
            ),
          ],
        ),
        subChild: Padding(
          padding: EdgeInsets.all(2),
          child: Row(
            children: [
              GsIconButton(
                icon: Icons.remove,
                size: 20,
                onPress: (savedRecipe?.proficiency ?? 0) != 0
                    ? () => GsDatabase.instance.saveRecipes.changeSavedRecipe(
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
                    ? () => GsDatabase.instance.saveRecipes.changeSavedRecipe(
                          recipe.id,
                          ((savedRecipe?.proficiency ?? 0) + 1)
                              .clamp(0, recipe.maxProficiency),
                        )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
