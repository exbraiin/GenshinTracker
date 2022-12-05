import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';

class HomeAscensionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final sw = GsDatabase.instance.saveWishes;
        final sc = GsDatabase.instance.saveCharacters;
        final characters = GsDatabase.instance.infoCharacters
            .getItems()
            .where((e) => sw.hasCaracter(e.id) && !sc.getCharMaxAscended(e.id))
            .sortedBy((e) => sc.getCharAscension(e.id))
            .thenByDescending((e) => e.rarity)
            .thenBy((e) => e.name)
            .take(8);

        if (characters.isEmpty) {
          return GsDataBox.summary(
            title: context.fromLabel(Labels.friendship),
            child: GsNoResultsState(),
          );
        }

        return GsDataBox.summary(
          title: context.fromLabel(Labels.ascension),
          child: Center(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: characters.map<Widget>((e) {
                return GsRarityItemCard.withLabels(
                  size: 70,
                  image: e.image,
                  rarity: e.rarity,
                  labelHeader: '${sc.getCharAscension(e.id)} ✦',
                  labelFooter: e.name,
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
