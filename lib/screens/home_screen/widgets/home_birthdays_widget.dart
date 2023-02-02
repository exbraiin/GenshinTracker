import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
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
        .thenBy((e) => e.birthday)
        .take(8);

    return GsDataBox.summary(
      title: context.fromLabel(Labels.birthday),
      child: Center(
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: characters.map<Widget>((e) {
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
          }).toList(),
        ),
      ),
    );
  }
}
