import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_colors.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeRemarkableChestsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ic = GsDatabase.instance.infoRemarkableChests;
    final sc = GsDatabase.instance.saveRemarkableChests;
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        return GsDataBox.summary(
          title: context.fromLabel(Labels.remarkableChests),
          children: [
            HomeTable(
              headers: [
                HomeRow.header(Lang.of(context).getValue(Labels.source)),
                HomeRow.header(Lang.of(context).getValue(Labels.owned)),
                HomeRow.header(Lang.of(context).getValue(Labels.total)),
              ],
              rows: ic
                  .getItems()
                  .groupBy((e) => e.source)
                  .entries
                  .sortedBy((e) => e.key)
                  .map((entry) {
                final owned = entry.value.count((e) => sc.exists(e.id));
                final total = entry.value.length;
                final color = owned < total ? GsColors.missing : Colors.white;
                return [
                  HomeRow(entry.key),
                  HomeRow(owned.format(), color: color),
                  HomeRow(total.format()),
                ];
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
