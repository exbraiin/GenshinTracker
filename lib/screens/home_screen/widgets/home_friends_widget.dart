import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';

class HomeFriendsWidget extends StatelessWidget {
  const HomeFriendsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final chars = GsUtils.characters;
        final db = GsDatabase.instance;
        final sc = db.saveCharacters;
        final characters = db.infoCharacters
            .getItems()
            .where((c) => chars.hasCaracter(c.id))
            .where((c) => chars.getCharFriendship(c.id) != 10)
            .sortedByDescending((e) => chars.getCharFriendship(e.id))
            .take(8);

        if (characters.isEmpty) {
          return GsDataBox.summary(
            title: context.fromLabel(Labels.friendship),
            child: const GsNoResultsState(),
          );
        }

        return GsDataBox.summary(
          title: context.fromLabel(Labels.friendship),
          child: Center(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: characters.map<Widget>((e) {
                return GsRarityItemCard(
                  key: ValueKey('friend_${e.id}'),
                  size: 70,
                  image: GsUtils.characters.getImage(e.id),
                  rarity: e.rarity,
                  footer: Text(e.name),
                  header: GsNumberField(
                    length: 2,
                    onUpdate: (i) => sc.setCharFriendship(e.id, i),
                    onDbUpdate: () => chars.getCharFriendship(e.id),
                  ),
                  onTap: () => Navigator.of(context).pushNamed(
                    CharacterDetailsScreen.id,
                    arguments: e,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
