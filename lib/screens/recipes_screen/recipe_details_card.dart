import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class RecipeDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final InfoRecipe item;

  const RecipeDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final isSpecial = item.baseRecipe.isNotEmpty;
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final owned = GsDatabase.instance.saveRecipes.exists(item.id);
        final saved = GsDatabase.instance.saveRecipes.getItemOrNull(item.id);
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
                if (!isSpecial)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GsIconButton(
                      size: 26,
                      color: saved != null
                          ? context.themeColors.goodValue
                          : context.themeColors.badValue,
                      icon: saved != null ? Icons.check : Icons.close,
                      onPress: () =>
                          GsUtils.recipes.update(item.id, own: saved == null),
                    ),
                  ),
                if (!isSpecial && owned)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 180,
                      margin: const EdgeInsets.only(top: kSeparator4),
                      padding: const EdgeInsets.all(kSeparator4),
                      decoration: BoxDecoration(
                        color: context.themeColors.mainColor2.withOpacity(0.3),
                        borderRadius: kMainRadius,
                        border: Border.all(
                          color:
                              context.themeColors.mainColor1.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          GsNumberField(
                            onUpdate: (i) {
                              final amount = i.clamp(0, item.maxProficiency);
                              GsUtils.recipes
                                  .update(item.id, proficiency: amount);
                            },
                            onDbUpdate: () {
                              final db = GsDatabase.instance.saveRecipes;
                              return db.getItemOrNull(item.id)?.proficiency ??
                                  0;
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
      },
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
                final item = db.infoMaterials.getItemOrNull(e.key);
                return ItemRarityBubble.withLabel(
                  image: item?.image ?? '',
                  rarity: item?.rarity ?? 1,
                  tooltip: item?.name ?? '',
                  label: e.value.format(),
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
                  ),
              ],
            ],
          ),
        ),
    ]);
  }
}
