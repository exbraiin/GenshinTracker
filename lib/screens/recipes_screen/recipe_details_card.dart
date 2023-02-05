import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class RecipeDetailsCard extends StatelessWidget {
  final InfoRecipe item;

  const RecipeDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final db = GsDatabase.instance;
    late final baseRecipe = db.infoRecipes.getItemOrNull(item.baseRecipe);
    late final char = db.infoCharacters
        .getItems()
        .firstOrNullWhere((e) => e.specialDish == item.id);
    return ItemDetailsCard(
      name: item.name,
      rarity: item.rarity,
      image: (context, page) => item.image,
      info: (context, page) => Align(
        alignment: Alignment.topLeft,
        child: Row(
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
      ),
      child: (context, page) {
        final texts = <InlineSpan>[];

        final labelStyle = TextStyle(
          fontSize: 16,
          color: Color.lerp(Colors.black, Colors.orange, 0.8)!,
          fontWeight: FontWeight.bold,
        );

        if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
        final label = context.fromLabel(item.effect.label);
        texts.add(TextSpan(text: '$label\n', style: labelStyle));
        texts.add(TextSpan(text: '  \u2022  ${item.effectDesc}'));

        if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
        final style = TextStyle(color: Colors.grey[600]);
        texts.add(TextSpan(text: item.description, style: style));

        if (item.ingredients.isNotEmpty) {
          if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
          final label1 = context.fromLabel(Labels.ingredients);
          texts.add(TextSpan(text: '$label1\n', style: labelStyle));
          final list = Wrap(
            spacing: kSeparator4,
            runSpacing: kSeparator4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...item.ingredients.entries.map((e) {
                final item = db.infoIngredients.getItemOrNull(e.key);
                return GsRarityItemCard.withLabels(
                  image: item?.image ?? '',
                  rarity: item?.rarity ?? 1,
                  labelHeader: e.value.format(),
                  labelFooter: item?.name ?? '',
                );
              }),
              if (baseRecipe != null) ...[
                Icon(
                  Icons.add_rounded,
                  color: labelStyle.color!,
                ),
                GsRarityItemCard.withLabels(
                  image: baseRecipe.image,
                  rarity: baseRecipe.rarity,
                  labelFooter: baseRecipe.name,
                ),
                if (char != null)
                  GsRarityItemCard.withLabels(
                    image: char.image,
                    rarity: char.rarity,
                    labelFooter: char.name,
                  )
              ],
            ],
          );
          texts.add(WidgetSpan(child: list));
        }

        return Text.rich(TextSpan(children: texts));
      },
    );
  }
}
