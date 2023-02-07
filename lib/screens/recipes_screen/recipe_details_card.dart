import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class RecipeDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final InfoRecipe item;

  const RecipeDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final isSpecial = item.baseRecipe.isNotEmpty;
    final owned = GsDatabase.instance.saveRecipes.exists(item.id);
    return ItemDetailsCard.single(
      name: item.name,
      rarity: item.rarity,
      image: item.image,
      banner: GsItemBanner.fromVersion(item.version),
      info: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  item.effect.assetPath,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: kSeparator4),
                Text(context.fromLabel(item.effect.label)),
              ],
            ),
            const Spacer(),
            if (!isSpecial && owned)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(kSeparator4),
                  decoration: BoxDecoration(
                    color: GsColors.mainColor2.withOpacity(0.3),
                    borderRadius: kMainRadius,
                    border: Border.all(
                      color: GsColors.mainColor1.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      GsNumberField(
                        onUpdate: (i) {
                          final db = GsDatabase.instance.saveRecipes;
                          final amount = i.clamp(0, item.maxProficiency);
                          db.changeSavedRecipe(item.id, amount);
                        },
                        onDbUpdate: () {
                          final db = GsDatabase.instance.saveRecipes;
                          return db.getItemOrNull(item.id)?.proficiency ?? 0;
                        },
                        fontSize: 14,
                      ),
                      Text(
                        '${context.fromLabel(Labels.proficiency)}'
                        ' (max: ${item.maxProficiency.format()})',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    final db = GsDatabase.instance;
    late final baseRecipe = db.infoRecipes.getItemOrNull(item.baseRecipe);
    late final char = db.infoCharacters
        .getItems()
        .firstOrNullWhere((e) => e.specialDish == item.id);

    return ItemDetailsCardContent.generate(context, [
      ItemDetailsCardContent(
        label: context.fromLabel(item.effect.label),
        description: item.effectDesc,
      ),
      ItemDetailsCardContent(description: item.description),
      if (item.ingredients.isNotEmpty)
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.ingredients),
          content: Wrap(
            spacing: kSeparator4,
            runSpacing: kSeparator4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...item.ingredients.entries.map((e) {
                final item = db.infoIngredients.getItemOrNull(e.key);
                return ItemRarityBubble(
                  image: item?.image ?? '',
                  rarity: item?.rarity ?? 1,
                  tooltip: item?.name ?? '',
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      e.value.format(),
                      style: const TextStyle(
                        color: Colors.white,
                        shadows: kMainShadowBlack,
                      ),
                    ),
                  ),
                );
              }),
              if (baseRecipe != null) ...[
                const Icon(
                  Icons.add_rounded,
                  color: Colors.black45,
                ),
                ItemRarityBubble(
                  image: baseRecipe.image,
                  rarity: baseRecipe.rarity,
                  tooltip: baseRecipe.name,
                ),
                if (char != null)
                  ItemRarityBubble(
                    image: GsUtils.characters.getImage(char.id),
                    rarity: char.rarity,
                    tooltip: char.name,
                  )
              ],
            ],
          ),
        ),
    ]);
  }
}
