import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/lang/labels.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';

class HomeBirthdaysWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    now = DateTime(0, now.month, now.day);
    final characters = GsDatabase.instance.infoCharacters
        .getItems()
        .where((e) => !e.birthday.isBefore(now))
        .sortedBy((e) => e.birthday)
        .take(8);

    return GsDataBox.summary(
      title: context.fromLabel(Labels.birthday),
      child: Center(
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: characters.map<Widget>((e) {
            return Tooltip(
              message: e.name,
              child: GsItemCardButton(
                height: 76,
                width: 64,
                shadow: true,
                label: e.birthday.toBirthday(),
                rarity: e.rarity,
                imageUrlPath: e.image,
                onTap: () => Navigator.of(context).pushNamed(
                  CharacterDetailsScreen.id,
                  arguments: e,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
