import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeRecipesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.subtitle2!.copyWith(color: Colors.white);

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

        return Container(
          decoration: BoxDecoration(
            color: GsColors.mainColor2,
            boxShadow: mainShadow,
            borderRadius: kMainRadius,
          ),
          padding: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 26,
                child: Center(
                  child: Text(
                    Lang.of(context).getValue(Labels.recipes),
                    style: style.copyWith(fontSize: 16),
                  ),
                ),
              ),
              Divider(indent: 8, endIndent: 8, color: Colors.white),
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
              SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }
}
