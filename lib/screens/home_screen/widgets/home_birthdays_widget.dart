import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';

class HomeBirthdaysWidget extends StatelessWidget {
  const HomeBirthdaysWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    now = DateTime(0, now.month, now.day);

    final characters = GsDatabase.instance.infoCharacters
        .getItems()
        .sortedBy((e) => !e.birthday.isBefore(now) ? 0 : 1)
        .thenBy((e) => e.birthday);

    return GsDataBox.info(
      title: context.fromLabel(Labels.birthday),
      child: LayoutBuilder(
        builder: (context, layout) {
          final width = layout.maxWidth;
          final items = (width ~/ 74).coerceAtMost(8);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: characters
                .take(items)
                .map<Widget>((e) {
                  return GsRarityItemCard.withLabels(
                    size: 70,
                    rarity: e.rarity,
                    image: GsUtils.characters.getImage(e.id),
                    labelFooter: e.name,
                    labelHeader: e.birthday.toBirthday(),
                    onTap: () => Navigator.of(context).pushNamed(
                      CharacterDetailsScreen.id,
                      arguments: e,
                    ),
                  );
                })
                .separate(const SizedBox(width: kSeparator4))
                .toList(),
          );
        },
      ),
    );
  }
}
