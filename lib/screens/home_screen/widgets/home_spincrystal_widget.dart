import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeSpincrystalsWidget extends StatelessWidget {
  const HomeSpincrystalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        final db = Database.instance;
        final spins = db.infoOf<GsSpincrystal>().items;
        final sv = db.saveOf<GiSpincrystal>().ids;

        final world = spins.where((e) => !e.fromChubby);
        final ownedWorld = world.count((e) => sv.contains(e.id));
        final totalWorld = world.length;

        final chubby = spins.where((e) => e.fromChubby);
        final ownedChubby = chubby.count((e) => sv.contains(e.id));
        final totalChubby = chubby.length;

        final totalOwned = spins.count((e) => sv.contains(e.id));
        final totalTotal = spins.length;

        return GsDataBox.info(
          title: Text(context.labels.spincrystals()),
          child: HomeTable(
            headers: [
              HomeRow.header(context.labels.source()),
              HomeRow.header(context.labels.owned()),
              HomeRow.header(context.labels.total()),
            ],
            rows: [
              [
                HomeRow(context.labels.world()),
                HomeRow.missing(context, ownedWorld, totalWorld),
                HomeRow('$totalWorld'),
              ],
              [
                HomeRow(context.labels.chubby()),
                HomeRow.missing(context, ownedChubby, totalChubby),
                HomeRow('$totalChubby'),
              ],
              List.generate(3, (i) => const Divider()),
              [
                HomeRow(context.labels.total()),
                HomeRow.missing(context, totalOwned, totalTotal),
                HomeRow(totalTotal.format()),
              ],
            ],
          ),
        );
      },
    );
  }
}
