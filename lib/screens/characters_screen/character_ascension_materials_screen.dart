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
import 'package:tracker/screens/characters_screen/character_ascension_screen.dart';

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

  List<AscensionMaterial> _getMaterials() {
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
        .expand((char) =>
            AscMat.values.expand((e) => AscensionMaterial.getMats(e, char)))
        .groupBy((e) => e.key)
        .entries
        .map((e) {
          final mat = GsDatabase.instance.infoMaterials.getItem(e.key);
          final db = GsDatabase.instance.saveMaterials;
          final total = e.value.sumBy((e) => e.value).toInt();
          final owned = db.getItemOrNull(mat.id)?.amount ?? 0;
          final craft = owned < total ? db.getCraftableAmount(mat) : 0;
          return AscensionMaterial(
            material: mat,
            craftable: craft,
            owned: owned,
            required: total,
          );
        })
        .sortedBy((e) => e.material!.group)
        .thenBy((e) => e.material!.subgroup)
        .thenBy((e) => e.material!.rarity)
        .thenBy((e) => e.material!.name)
        .toList();
  }
}
