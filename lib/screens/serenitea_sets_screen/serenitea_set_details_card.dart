import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/static/circle_widget.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class SereniteaSetDetailsCard extends StatelessWidget
    with GsDetailedDialogMixin {
  final InfoSereniteaSet item;

  const SereniteaSetDetailsCard(
    this.item, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ItemDetailsCard.single(
      name: item.name,
      fgImage: item.image,
      banner: GsItemBanner.fromVersion(item.version),
      info: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Image.asset(
              item.category == GsSetCategory.indoor
                  ? imageIndoorSet
                  : imageOutdoorSet,
              width: 32,
              height: 32,
            ),
            const SizedBox(width: kSeparator4),
            Text(context.fromLabel(item.category.label)),
          ],
        ),
      ),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    final ic = GsDatabase.instance.infoCharacters;
    final saved = GsDatabase.instance.saveSereniteaSets.getItemOrNull(item.id);

    return ItemDetailsCardContent.generate(context, [
      if (item.energy > 0)
        ItemDetailsCardContent(
          label: context.fromLabel(item.category.label),
          description: context.fromLabel(Labels.energyN, item.energy.format()),
        ),
      if (item.chars.isNotEmpty)
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.characters),
          content: Wrap(
            spacing: kSeparator4,
            runSpacing: kSeparator4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: item.chars
                .map((e) => ic.getItemOrNull(e))
                .whereNotNull()
                .sortedBy((e) => GsUtils.characters.hasCaracter(e.id) ? 0 : 1)
                .thenByDescending((element) => element.rarity)
                .thenBy((element) => element.name)
                .map((char) {
              final owns = GsUtils.characters.hasCaracter(char.id);
              final marked = saved?.chars.contains(char.id) ?? false;
              return Opacity(
                opacity: owns ? 1 : 0.4,
                child: ItemRarityBubble(
                  image: GsUtils.characters.getImage(char.id),
                  rarity: char.rarity,
                  onTap: owns
                      ? () => GsDatabase.instance.saveSereniteaSets
                          .setSetCharacter(item.id, char.id, !marked)
                      : null,
                  child: marked
                      ? const Align(
                          alignment: Alignment.bottomRight,
                          child: CircleWidget(
                            color: Colors.black,
                            borderColor: Colors.white,
                            borderSize: 1.6,
                            size: 20,
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.lightGreen,
                              size: 16,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
    ]);

    final texts = <InlineSpan>[];

    final labelStyle = TextStyle(
      fontSize: 16,
      color: Color.lerp(Colors.black, Colors.orange, 0.8)!,
      fontWeight: FontWeight.bold,
    );

    if (item.chars.isNotEmpty) {
      if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
      final label = context.fromLabel(Labels.characters);
      texts.add(TextSpan(text: '$label\n', style: labelStyle));
      final list = Wrap(
        spacing: kSeparator4,
        runSpacing: kSeparator4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...item.chars
              .map((e) => ic.getItemOrNull(e))
              .whereNotNull()
              .sortedBy((e) => GsUtils.characters.hasCaracter(e.id) ? 0 : 1)
              .thenByDescending((element) => element.rarity)
              .thenBy((element) => element.name)
              .map((char) {
            final owns = GsUtils.characters.hasCaracter(char.id);
            final marked = saved?.chars.contains(char.id) ?? false;
            return Opacity(
              opacity: owns ? 1 : 0.4,
              child: ItemRarityBubble(
                image: GsUtils.characters.getImage(char.id),
                rarity: char.rarity,
                onTap: owns
                    ? () => GsDatabase.instance.saveSereniteaSets
                        .setSetCharacter(item.id, char.id, !marked)
                    : null,
                child: marked
                    ? const Align(
                        alignment: Alignment.bottomRight,
                        child: CircleWidget(
                          color: Colors.black,
                          borderColor: Colors.white,
                          borderSize: 1.6,
                          size: 20,
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.lightGreen,
                            size: 16,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          }),
        ],
      );
      texts.add(WidgetSpan(child: list));
    }

    return Text.rich(TextSpan(children: texts));
  }
}
