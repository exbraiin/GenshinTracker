import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';
import 'package:tracker/theme/theme.dart';

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
        final ownedWorld = world.where((e) => sv.contains(e.id)).length;
        final totalWorld = world.length;

        final chubby = spins.where((e) => e.fromChubby);
        final ownedChubby = chubby.where((e) => sv.contains(e.id)).length;
        final totalChubby = chubby.length;

        final ownedAll = sv.length;
        final totalAll = spins.length;

        late final missing = context.themeColors.badValue;
        final oWorldColor = ownedWorld < totalWorld ? missing : Colors.white;
        final oChubbyColor = ownedChubby < totalChubby ? missing : Colors.white;
        final oAllColor = ownedAll < totalAll ? missing : Colors.white;

        return GsDataBox.info(
          title: Text(context.fromLabel(Labels.spincrystals)),
          child: HomeTable(
            headers: [
              HomeRow.header(Lang.of(context).getValue(Labels.source)),
              HomeRow.header(Lang.of(context).getValue(Labels.owned)),
              HomeRow.header(Lang.of(context).getValue(Labels.total)),
            ],
            rows: [
              [
                HomeRow(Lang.of(context).getValue(Labels.world)),
                HomeRow('$ownedWorld', color: oWorldColor),
                HomeRow('$totalWorld'),
              ],
              [
                HomeRow(Lang.of(context).getValue(Labels.chubby)),
                HomeRow('$ownedChubby', color: oChubbyColor),
                HomeRow('$totalChubby'),
              ],
              [
                HomeRow(Lang.of(context).getValue(Labels.all)),
                HomeRow('$ownedAll', color: oAllColor),
                HomeRow('$totalAll'),
              ],
            ],
          ),
        );
      },
    );
  }
}
