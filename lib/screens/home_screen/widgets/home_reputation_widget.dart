import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeReputationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final db = GsDatabase.instance;
        return GsDataBox.summary(
          title: context.fromLabel(Labels.reputation),
          child: HomeTable(
            headers: [
              HomeRow.header(Lang.of(context).getValue(Labels.city)),
              HomeRow.header(Lang.of(context).getValue(Labels.current)),
              HomeRow.header(Lang.of(context).getValue(Labels.max)),
            ],
            rows: db.infoCities.getItems().map((city) {
              final sr = db.saveReputations;
              final maxLvl = sr.getCityMaxLevelWeeks(city.id);
              final nextLvl = sr.getCityNextLevelWeeks(city.id);
              return [
                HomeRow(city.name),
                HomeRow(
                  '${sr.getCityLevel(city.id)}'
                  '${nextLvl > 0 ? ' ($nextLvl wk)' : ''}',
                ),
                HomeRow(
                  '${db.infoCities.getCityMaxLevel(city.id)}'
                  '${maxLvl > 0 ? ' ($maxLvl wk)' : ''}',
                ),
              ];
            }).toList(),
          ),
        );
      },
    );
  }
}
