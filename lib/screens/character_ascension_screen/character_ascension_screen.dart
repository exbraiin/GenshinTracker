import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/character_ascension_screen/character_ascension_material.dart';

const radius = BorderRadius.all(Radius.circular(6));

class CharacterAscensionScreen extends StatelessWidget {
  static const id = 'character_ascension_screen';

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (!snapshot.data!) return SizedBox();

        final wishes = GsDatabase.instance.saveWishes;
        final saved = GsDatabase.instance.saveCharacters;
        final items = GsDatabase.instance.infoCharacters.getItems();
        final characters = items
            .where((e) => wishes.hasCaracter(e.id))
            .sortedBy((e) => saved.getCharAscension(e.id))
            .thenByDescending((e) => e.rarity)
            .thenBy((e) => e.name)
            .toList();

        if (characters.isEmpty) {
          return GsNoResultsState();
        }

        return Scaffold(
          appBar: GsAppBar(
            label: context.fromLabel(Labels.ascension),
          ),
          body: ListView.separated(
            padding: EdgeInsets.all(kSeparator4),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              return _CharacterAscensionListItem(characters[index]);
            },
            separatorBuilder: (context, index) => SizedBox(height: kSeparator4),
          ),
        );
      },
    );
  }
}

class _CharacterAscensionListItem extends StatelessWidget {
  final InfoCharacter item;

  _CharacterAscensionListItem(this.item);

  @override
  Widget build(BuildContext context) {
    final sw = GsDatabase.instance.saveWishes;
    final sc = GsDatabase.instance.saveCharacters;
    final ic = GsDatabase.instance.infoCharactersInfo;
    final ascension = sc.getCharAscension(item.id);
    final maxAscend = sc.getCharMaxAscended(item.id);
    final materials = ic.getCharNextAscensionMats(item.id);
    final canAscend = materials.all((e) => e.hasRequired);
    return Opacity(
      opacity: maxAscend ? kDisableOpacity : 1,
      child: GsDataBox.info(
        child: Row(
          children: [
            SizedBox(width: kSeparator4),
            GsRarityItemCard(
              size: 70,
              image: item.image,
              rarity: item.rarity,
            ),
            SizedBox(width: kSeparator4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: context.textTheme.bigTitle3,
                ),
                SizedBox(height: kSeparator2),
                InkWell(
                  onTap: sw.getOwnedCharacter(item.id) != 0
                      ? () => sc.increaseAscension(item.id)
                      : null,
                  child: Text(
                    '${'✦' * ascension}${'✧' * (6 - ascension)}',
                    style: context.textTheme.bigTitle3,
                  ),
                ),
              ],
            ),
            Spacer(),
            if (materials.isNotEmpty)
              ...materials
                  .map<Widget>((e) => CharacterAscensionMaterial(
                        e.material?.id ?? '',
                        e.required,
                      ))
                  .separate(SizedBox(width: kSeparator4)),
            SizedBox(width: kSeparator4),
            if (materials.isNotEmpty)
              GsIconButton(
                size: 24,
                color: canAscend ? Colors.green : GsColors.missing,
                icon: canAscend ? Icons.check : Icons.close,
                onPress: canAscend
                    ? () => materials
                        .where((material) => material.material != null)
                        .forEach((e) =>
                            GsDatabase.instance.saveMaterials.changeAmount(
                              e.material!.id,
                              (e.owned - e.required).clamp(0, e.owned),
                            ))
                    : null,
              ),
            SizedBox(width: kSeparator4),
          ],
        ),
      ),
    );
  }
}
