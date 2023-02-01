import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/character_ascension_screen/character_ascension_material.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';

class HomeAscensionWidget extends StatefulWidget {
  @override
  State<HomeAscensionWidget> createState() => _HomeAscensionWidgetState();
}

class _HomeAscensionWidgetState extends State<HomeAscensionWidget> {
  final _notifier = ValueNotifier(false);

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final characters = GsDatabase.instance.infoCharacters
            .getItems()
            .where((e) =>
                GsUtils.characters.hasCaracter(e.id) &&
                !GsUtils.characters.isCharMaxAscended(e.id))
            .sortedBy((e) => GsUtils.characters.getCharAscension(e.id))
            .thenByDescending((e) => e.rarity)
            .thenBy((e) => e.name)
            .take(8);

        if (characters.isEmpty) {
          return GsDataBox.summary(
            title: context.fromLabel(Labels.ascension),
            child: GsNoResultsState(),
          );
        }

        final chars = GsUtils.characters;
        return GsDataBox.summary(
          title: context.fromLabel(Labels.ascension),
          child: Column(
            children: [
              Center(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: characters.map<Widget>((e) {
                    return GsRarityItemCard.withLabels(
                      size: 70,
                      image: GsUtils.characters.getImage(e.id),
                      rarity: e.rarity,
                      labelHeader: '${chars.getCharAscension(e.id)} ✦',
                      labelFooter: e.name,
                      onTap: () => Navigator.of(context).pushNamed(
                        CharacterDetailsScreen.id,
                        arguments: e,
                      ),
                    );
                  }).toList(),
                ),
              ),
              _getMaterialsList(characters),
            ],
          ),
        );
      },
    );
  }

  Widget _getMaterialsList(Iterable<InfoCharacter> characters) {
    if (characters.isEmpty) return SizedBox();

    final db = GsDatabase.instance.infoCharactersInfo;
    final materials = characters
        .expand((e) => db.getCharNextAscensionMats(e.id))
        .groupBy((e) => e.material?.id)
        .map((key, value) => MapEntry(key, AscendMaterial.combine(value)))
        .values
        .sortedBy((element) => element.material!.group.index)
        .thenBy((element) => element.material!.subgroup)
        .thenBy((element) => element.material!.rarity)
        .thenBy((element) => element.material!.name);

    return ValueListenableBuilder<bool>(
      valueListenable: _notifier,
      builder: (context, expanded, child) {
        return Column(
          children: [
            SizedBox(
              child: Center(
                child: IconButton(
                  onPressed: () => _notifier.value = !_notifier.value,
                  padding: EdgeInsets.all(kSeparator4),
                  constraints: BoxConstraints.tightFor(),
                  icon: AnimatedRotation(
                    turns: expanded ? 0.5 : 1,
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              curve: Curves.easeOut,
              duration: Duration(milliseconds: 400),
              constraints: BoxConstraints(maxHeight: expanded ? 300 : 0),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: kSeparator4),
                child: Wrap(
                  spacing: kSeparator4,
                  runSpacing: kSeparator4,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: materials
                      .map((e) => CharacterAscensionMaterial(
                            e.material!.id,
                            e.required,
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
