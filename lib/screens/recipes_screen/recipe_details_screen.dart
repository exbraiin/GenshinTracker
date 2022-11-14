import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/text_style_parser.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/domain_ext/enum/gs_recipe_buff_ext.dart';

class RecipeDetailsScreen extends StatelessWidget {
  static const id = 'recipe_details_screen';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final info = args as InfoRecipe;

    return Scaffold(
      appBar: GsAppBar(label: info.name),
      body: ValueStreamBuilder<bool>(
        stream: GsDatabase.instance.loaded,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(kSeparator4),
            child: Column(
              children: [
                _getInfo(context, info),
                SizedBox(height: kSeparator8),
                if (info.effect != GsRecipeBuff.none) _getEffect(context, info),
                if (info.effect != GsRecipeBuff.none)
                  SizedBox(height: kSeparator8),
                _getIngredients(context, info),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getInfo(BuildContext context, InfoRecipe info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GsRarityItemCard(
          size: 120,
          image: info.image,
          rarity: info.rarity,
        ),
        SizedBox(width: kSeparator8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    info.name,
                    style: Theme.of(context).textTheme.bigTitle2,
                  ),
                  SizedBox(width: kSeparator8),
                  if (info.effect != GsRecipeBuff.none)
                    Image.asset(
                      info.effect.assetPath,
                      width: 18,
                      height: 18,
                    ),
                ],
              ),
              Text(
                info.description,
                style: context.textTheme.description2,
              ),
              SizedBox(height: kSeparator8),
              _getTags(context, info),
            ],
          ),
        ),
        SizedBox(width: 360),
      ],
    );
  }

  Widget _getTags(BuildContext context, InfoRecipe info) {
    return Row(
      children: [
        context.fromLabel(Labels.rarityStar, info.rarity),
        context.fromLabel(info.effect.label),
        if (info.baseRecipe.isNotEmpty) context.fromLabel(Labels.specialDish),
      ]
          .map<Widget>((e) => GsDataBox.label(e))
          .separate(SizedBox(width: kSeparator4))
          .toList(),
    );
  }

  Widget _getEffect(BuildContext context, InfoRecipe info) {
    return GsDataBox.info(
      title: context.fromLabel(info.effect.label),
      child: info.effect != GsRecipeBuff.none
          ? TextParserWidget(
              info.effectDesc,
              style: context.textTheme.subtitle2!.copyWith(color: Colors.white),
            )
          : SizedBox(),
    );
  }

  Widget _getIngredients(BuildContext context, InfoRecipe info) {
    final ir = GsDatabase.instance.infoRecipes;
    final ic = GsDatabase.instance.infoCharacters;
    final baseRecipe = ir.getItemOrNull(info.baseRecipe);
    late final char =
        ic.getItems().firstOrNullWhere((e) => e.specialDish == info.id);
    return GsDataBox.info(
      title: 'Ingredients',
      child: Row(
        children: [
          if (baseRecipe != null)
            GsRarityItemCard.withLabels(
              size: 80,
              labelFooter: baseRecipe.name,
              rarity: baseRecipe.rarity,
              image: baseRecipe.image,
            ),
          if (baseRecipe != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kSeparator8),
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
            ),
          ...info.ingredients.entries.map<Widget>((e) {
            final i = GsDatabase.instance.infoIngredients.getItemOrNull(e.key);
            return GsRarityItemCard.withLabels(
              size: 80,
              labelFooter: i?.name ?? e.key,
              labelHeader: e.value.toString(),
              image: i?.image ?? '',
              rarity: i?.rarity ?? 1,
            );
          }).separate(SizedBox(width: kSeparator4)),
          if (baseRecipe != null && char != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kSeparator8),
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
            ),
          if (baseRecipe != null && char != null)
            GsRarityItemCard.withLabels(
              size: 80,
              labelFooter: char.name,
              rarity: char.rarity,
              image: char.image,
            ),
        ],
      ),
    );
  }
}
