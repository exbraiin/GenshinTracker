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
  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final db = GsDatabase.instance;
        final sw = db.saveWishes;
        final sc = db.saveCharacters;
        final characters = db.infoCharacters
            .getItems()
            .where((c) => sw.hasCaracter(c.id))
            .where((c) => sc.getCharFriendship(c.id) != 10)
            .sortedByDescending((e) => sc.getCharFriendship(e.id))
            .take(8);

        if (characters.isEmpty) {
          return GsDataBox.summary(
            title: context.fromLabel(Labels.friendship),
            child: GsNoResultsState(),
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
                  image: e.image,
                  rarity: e.rarity,
                  footer: Text(e.name),
                  header: GsNumberField(
                    length: 2,
                    onUpdate: (i) => sc.setCharFriendship(e.id, i),
                    onDbUpdate: () => sc.getCharFriendship(e.id),
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
