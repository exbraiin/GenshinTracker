import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeRecipesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final all = GsDatabase.instance.infoRecipes.getItems();
        final saved = GsDatabase.instance.saveRecipes.getItems();
        final groups = all.groupBy((e) => e.rarity);

        int owned(int rarity) {
          return groups[rarity]
                  ?.where((e) => saved.any((t) => t.id == e.id))
                  .length ??
              0;
        }

        int master(int rarity) {
          return groups[rarity]
                  ?.where((e) => saved.any(
                      (t) => t.id == e.id && t.proficiency == e.maxProficiency))
                  .length ??
              0;
        }

        return GsDataBox.summary(
          title: context.fromLabel(Labels.recipes),
          children: [
            HomeTable(
              headers: [
                HomeRow.header(Lang.of(context).getValue(Labels.rarity)),
                HomeRow.header(Lang.of(context).getValue(Labels.master)),
                HomeRow.header(Lang.of(context).getValue(Labels.owned)),
                HomeRow.header(Lang.of(context).getValue(Labels.total)),
              ],
              rows: List.generate(5, (i) {
                i++;
                final m = master(i);
                final o = owned(i);
                final t = groups[i]?.length ?? 0;
                final mColor = m < o ? Colors.deepOrange : Colors.white;
                final oColor = o < t ? Colors.deepOrange : Colors.white;
                return [
                  HomeRow('$i★'),
                  HomeRow('$m', color: mColor),
                  HomeRow('$o', color: oColor),
                  HomeRow('$t'),
                ];
              }),
            ),
          ],
        );
      },
    );
  }
}
