import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/common/widgets/value_notifier_builder.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class RecipeDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final GsRecipe item;

  const RecipeDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final isSpecial = item.baseRecipe.isNotEmpty;
    return ValueStreamBuilder(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        final owned = Database.instance.saveOf<GiRecipe>().exists(item.id);
        final saved = Database.instance.saveOf<GiRecipe>().getItem(item.id);
        return ItemDetailsCard.single(
          name: item.name,
          rarity: item.rarity,
          image: item.image,
          banner: GsItemBanner.fromVersion(context, item.version),
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
                      width: 200,
                      margin: const EdgeInsets.only(top: kSeparator4),
                      padding: const EdgeInsets.all(kSeparator4),
                      decoration: BoxDecoration(
                        color: context.themeColors.mainColor0.withOpacity(0.4),
                        borderRadius: kGridRadius,
                      ),
                      child: Column(
                        children: [
                          GsNumberField(
                            onUpdate: _setProficiency,
                            onDbUpdate: _getProficiency,
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${context.fromLabel(Labels.proficiency)} '
                            '${context.fromLabel(Labels.maxProficiency, item.maxProficiency.format())}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 30,
                            child: ValueNotifierBuilder<int>(
                              value: _getProficiency(),
                              builder: (context, notifier, child) {
                                return Slider(
                                  min: 0,
                                  max: item.maxProficiency.toDouble(),
                                  activeColor: Colors.white,
                                  label: notifier.value.toString(),
                                  divisions: item.maxProficiency,
                                  value: notifier.value.toDouble(),
                                  onChanged: (i) => notifier.value = i.toInt(),
                                  onChangeEnd: (i) =>
                                      _setProficiency(i.toInt()),
                                );
                              },
                            ),
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

  int _getProficiency() {
    final db = Database.instance.saveOf<GiRecipe>();
    return db.getItem(item.id)?.proficiency ?? 0;
  }

  void _setProficiency(int value) {
    final amount = value.clamp(0, item.maxProficiency);
    final current = _getProficiency();
    if (amount == current) return;
    GsUtils.recipes.update(item.id, proficiency: amount);
  }

  Widget _content(BuildContext context) {
    final db = Database.instance;
    late final baseRecipe = db.infoOf<GsRecipe>().getItem(item.baseRecipe);
    late final char = db
        .infoOf<GsCharacter>()
        .items
        .firstOrNullWhere((e) => e.specialDish == item.id);

    return ItemDetailsCardContent.generate(context, [
      ItemDetailsCardContent(
        label: context.fromLabel(item.effect.label),
        description: item.effectDesc,
      ),
      ItemDetailsCardContent(description: item.desc),
      if (item.ingredients.isNotEmpty)
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.ingredients),
          content: Wrap(
            spacing: kSeparator4,
            runSpacing: kSeparator4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...item.ingredients.map((e) {
                final item = db.infoOf<GsMaterial>().getItem(e.id);
                if (item == null) return const SizedBox();
                return ItemGridWidget.material(item, label: e.amount.format());
              }),
              if (baseRecipe != null) ...[
                Icon(
                  Icons.add_rounded,
                  color: context.themeColors.mainColor1,
                ),
                ItemGridWidget.recipe(baseRecipe, onTap: null),
                if (char != null)
                  ItemGridWidget.character(
                    char,
                    onTap: null,
                  ),
              ],
            ],
          ),
        ),
    ]);
  }
}
