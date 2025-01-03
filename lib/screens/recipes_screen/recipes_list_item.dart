import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class RecipesListItem extends StatelessWidget {
  final GsRecipe recipe;
  final bool selected;
  final GiRecipe? savedRecipe;
  final VoidCallback? onTap;

  const RecipesListItem({
    super.key,
    required this.recipe,
    this.selected = false,
    this.savedRecipe,
    this.onTap,
  });

  bool _hasSpecialDishChar() {
    final db = Database.instance;
    final char = db
        .infoOf<GsCharacter>()
        .items
        .firstOrNullWhere((e) => e.specialDish == recipe.id);
    return char != null && GsUtils.characters.hasCaracter(char.id);
  }

  @override
  Widget build(BuildContext context) {
    final isSpecial = recipe.baseRecipe.isNotEmpty;
    final hasSpecial = isSpecial && _hasSpecialDishChar();
    late final char = Database.instance
        .infoOf<GsCharacter>()
        .items
        .firstOrNullWhere((e) => e.specialDish == recipe.id);
    return GsItemCardButton(
      label: recipe.name,
      rarity: recipe.rarity,
      selected: selected,
      disable: savedRecipe == null && !hasSpecial,
      banner: GsItemBanner.fromVersion(context, recipe.version),
      imageUrlPath: recipe.image,
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: kSeparator2,
            left: kSeparator2,
            child: ItemCircleWidget(
              asset: recipe.effect.assetPath,
              size: ItemSize.small,
            ),
          ),
          if (isSpecial)
            Positioned(
              right: kSeparator2,
              bottom: kSeparator2,
              child: ItemCircleWidget(
                image: char?.image ?? '',
                rarity: char?.rarity ?? 1,
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
    );
  }
}
