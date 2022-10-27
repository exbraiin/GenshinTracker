import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeFriendsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final textTheme = Theme.of(context).textTheme;
        final style = textTheme.subtitle2!.copyWith(color: Colors.white);

        final db = GsDatabase.instance;
        final sw = db.saveWishes;
        final sc = db.saveCharacters;
        final characters = db.infoCharacters
            .getItems()
            .where((c) => sw.hasCaracter(c.id))
            .where((c) => sc.getCharFriendship(c.id) != 10)
            .sortedByDescending((e) => sc.getCharFriendship(e.id))
            .take(5);

        return GsDataBox.summary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 26,
                child: Center(
                  child: Text(
                    Lang.of(context).getValue(Labels.friendship),
                    style: style.copyWith(fontSize: 16),
                  ),
                ),
              ),
              Divider(indent: 8, endIndent: 8, color: Colors.white),
              HomeTable(
                headers: [
                  HomeRow.header(Lang.of(context).getValue(Labels.name)),
                  HomeRow.header(Lang.of(context).getValue(Labels.rarity)),
                  HomeRow.header(Lang.of(context).getValue(Labels.friendship)),
                ],
                rows: characters.map((e) {
                  return [
                    HomeRow(e.name),
                    HomeRow('${e.rarity}★',
                        color: GsColors.getRarityColor(e.rarity)),
                    HomeRow(sc.getCharFriendship(e.id).toString()),
                  ];
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
