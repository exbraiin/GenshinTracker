import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
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
        final characters = db.infoCharacters
            .getItems()
            .where((c) => chars.hasCaracter(c.id))
            .where((c) => chars.getCharFriendship(c.id) != 10)
            .sortedByDescending((e) => chars.getCharFriendship(e.id));

        if (characters.isEmpty) {
          return GsDataBox.info(
            title: Text(context.fromLabel(Labels.friendship)),
            child: const GsNoResultsState.small(),
          );
        }

        return GsDataBox.info(
          title: Text(context.fromLabel(Labels.friendship)),
          child: LayoutBuilder(
            builder: (context, layout) {
              final width = layout.maxWidth;
              final items = (width ~/ 74).coerceAtMost(8);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: characters
                    .take(items)
                    .map<Widget>((e) {
                      return ItemRarityBubble.withLabel(
                        size: 70,
                        key: ValueKey('friend_${e.id}'),
                        image: GsUtils.characters.getImage(e.id),
                        rarity: e.rarity,
                        label: chars.getCharFriendship(e.id).format(),
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
      },
    );
  }
}
