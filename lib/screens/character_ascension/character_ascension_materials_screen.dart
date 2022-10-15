import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/character_ascension/character_ascension_screen.dart';

class CharacterAscensionMaterialsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GsAppBar(label: 'Character Materials'),
      body: ValueStreamBuilder(
        stream: GsDatabase.instance.loaded,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox();

          final table = GsDatabase.instance.saveMaterials;
          final mats = _getMaterials();

          return GsGridView.builder(
            itemCount: mats.length,
            itemBuilder: (context, index) {
              final asc = mats[index];
              final onlyCraftable = asc.owned == 0 && asc.craftable > 0;
              final mat = asc.material;
              final amount = asc.owned;

              const colorValid = Colors.lightGreen;
              const colorCraft = Colors.yellow;
              const colorInvalid = Colors.deepOrange;

              return ItemCardButton(
                label: '',
                rarity: mats[index].material?.rarity ?? 1,
                imageUrlPath: mats[index].material?.image,
                subChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GsIconButtonHold(
                      icon: Icons.remove,
                      size: 16,
                      onPress: amount > 0 && mat != null
                          ? (i) => table.changeAmount(
                                mat.id,
                                (amount - i).clamp(0, amount),
                              )
                          : null,
                    ),
                    Spacer(),
                    if (!onlyCraftable)
                      Text(
                        asc.owned.toString(),
                        style: context.textTheme.infoLabel.copyWith(
                          fontSize: 12,
                          color: asc.owned >= asc.required ||
                                  asc.owned + asc.craftable >= asc.required
                              ? colorValid
                              : colorInvalid,
                        ),
                      ),
                    if (asc.owned < asc.required && asc.craftable > 0)
                      Text(
                        '+${(asc.required - asc.owned).clamp(0, asc.craftable)}',
                        style: context.textTheme.infoLabel.copyWith(
                          fontSize: 12,
                          color: colorCraft,
                        ),
                      ),
                    Text(
                      '/${asc.required}',
                      style: context.textTheme.infoLabel.copyWith(
                        fontSize: 12,
                        color: asc.hasRequired ? colorValid : colorInvalid,
                      ),
                    ),
                    Spacer(),
                    GsIconButtonHold(
                      icon: Icons.add,
                      size: 16,
                      onPress: amount < 9999 && mat != null
                          ? (i) => table.changeAmount(
                                mat.id,
                                (amount + i).clamp(amount, 9999),
                              )
                          : null,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<AscendMaterial> _getMaterials() {
    final savedMats = GsDatabase.instance.saveMaterials;
    final wishes = GsDatabase.instance.saveWishes;
    final saved = GsDatabase.instance.saveCharacters;
    final items = GsDatabase.instance.infoCharacters.getItems();
    final characters = items
        .where((e) => wishes.hasCaracter(e.id))
        .sortedBy((e) => saved.getCharAscension(e.id))
        .thenByDescending((e) => e.rarity)
        .thenBy((e) => e.name)
        .toList();
    return characters
        .expand(
            (e) => getAscendMaterials(e.id, saved.getCharAscension(e.id) + 1))
        .where((e) => e.material != null)
        .groupBy((e) => e.material!.id)
        .entries
        .map((e) {
      final material = e.value.first.material;
      final owned = e.value.first.owned;
      final required = e.value.sumBy((e) => e.required).toInt();
      final craftable =
          owned < required ? savedMats.getCraftableAmount(material!.id) : 0;
      return AscendMaterial(owned, required, craftable, material);
    }).toList();
  }
}
