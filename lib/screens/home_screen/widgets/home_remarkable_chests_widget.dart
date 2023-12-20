import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeRemarkableChestsWidget extends StatelessWidget {
  const HomeRemarkableChestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ic = Database.instance.infoOf<GsFurnitureChest>();
    final sc = Database.instance.saveRemarkableChests;

    final totalOwned = ic.items.count((e) => sc.exists(e.id));
    final totalTotal = ic.items.length;

    return ValueStreamBuilder(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        return GsDataBox.info(
          title: Text(context.fromLabel(Labels.remarkableChests)),
          children: [
            HomeTable(
              headers: [
                HomeRow.header(context.fromLabel(Labels.source)),
                HomeRow.header(context.fromLabel(Labels.owned)),
                HomeRow.header(context.fromLabel(Labels.total)),
              ],
              rows: [
                ...ic.items
                    .groupBy((e) => e.region)
                    .entries
                    .sortedBy((e) => e.key.index)
                    .map((entry) {
                  final owned = entry.value.count((e) => sc.exists(e.id));
                  final total = entry.value.length;
                  return [
                    HomeRow(context.fromLabel(entry.key.label)),
                    HomeRow.missing(context, owned, total),
                    HomeRow(total.format()),
                  ];
                }),
                List.generate(3, (i) => const Divider()),
                [
                  HomeRow(context.fromLabel(Labels.total)),
                  HomeRow.missing(context, totalOwned, totalTotal),
                  HomeRow(totalTotal.format()),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}
