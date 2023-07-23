import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
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
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final db = GsDatabase.instance;
        final spins = db.infoSpincrystal.getItems();
        final sv = db.saveSpincrystals
            .getItems()
            .where((e) => e.obtained)
            .map((e) => e.id);

        final world = spins.where((e) => !e.fromChubby);
        final ownedWorld = world.count((e) => sv.contains(e.id));
        final totalWorld = world.length;

        final chubby = spins.where((e) => e.fromChubby);
        final ownedChubby = chubby.count((e) => sv.contains(e.id));
        final totalChubby = chubby.length;

        final totalOwned = spins.count((e) => sv.contains(e.id));
        final totalTotal = spins.length;

        return GsDataBox.info(
          title: Text(context.fromLabel(Labels.spincrystals)),
          child: HomeTable(
            headers: [
              HomeRow.header(context.fromLabel(Labels.source)),
              HomeRow.header(context.fromLabel(Labels.owned)),
              HomeRow.header(context.fromLabel(Labels.total)),
            ],
            rows: [
              [
                HomeRow(Lang.of(context).getValue(Labels.world)),
                HomeRow.missing(context, ownedWorld, totalWorld),
                HomeRow('$totalWorld'),
              ],
              [
                HomeRow(Lang.of(context).getValue(Labels.chubby)),
                HomeRow.missing(context, ownedChubby, totalChubby),
                HomeRow('$totalChubby'),
              ],
              List.generate(3, (i) => const Divider()),
              [
                HomeRow(context.fromLabel(Labels.total)),
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
