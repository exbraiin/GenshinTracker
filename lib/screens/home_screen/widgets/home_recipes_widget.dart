import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeRecipesWidget extends StatelessWidget {
  const HomeRecipesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        final all = Database.instance
            .infoOf<GsRecipe>()
            .items
            .where((e) => e.baseRecipe.isEmpty)
            .where((e) => e.type == GeRecipeType.permanent);
        final saved = Database.instance.saveOf<GiRecipe>().items;
        final groups = all.groupBy((e) => e.rarity);

        int owned([int? rarity]) {
          final values = groups[rarity] ?? groups.values.expand((e) => e);
          return values.count((e) => saved.any((t) => t.id == e.id));
        }

        int master([int? rarity]) {
          final values = groups[rarity] ?? groups.values.expand((e) => e);
          bool compare(GsRecipe i) => saved
              .any((t) => t.id == i.id && t.proficiency == i.maxProficiency);
          return values.count(compare);
        }

        int total([int? rarity]) {
          final values = groups[rarity] ?? groups.values.expand((e) => e);
          return values.length;
        }

        final tm = master();
        final to = owned();
        final tt = total();

        return GsDataBox.info(
          title: Text(context.labels.recipes()),
          children: [
            HomeTable(
              headers: [
                HomeRow.header(context.labels.rarity()),
                HomeRow.header(context.labels.master()),
                HomeRow.header(context.labels.owned()),
                HomeRow.header(context.labels.total()),
              ],
              rows: [
                ...Iterable.generate(5, (i) {
                  i++;
                  final m = master(i);
                  final o = owned(i);
                  final t = total(i);
                  return [
                    HomeRow('$i★'),
                    HomeRow.missing(context, m, o),
                    HomeRow.missing(context, o, t),
                    HomeRow('$t'),
                  ];
                }),
                List.generate(4, (i) => const Divider()),
                [
                  HomeRow(context.labels.total()),
                  HomeRow.missing(context, tm, to),
                  HomeRow.missing(context, to, tt),
                  HomeRow(tt.format()),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}
