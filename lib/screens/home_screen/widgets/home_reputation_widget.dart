import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';
import 'package:tracker/theme/theme.dart';

class HomeReputationWidget extends StatelessWidget {
  const HomeReputationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    late final badColor = context.themeColors.badValue;
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final db = GsDatabase.instance;
        return GsDataBox.info(
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
              final nColor = nextLvl > 0 ? badColor : Colors.white;
              final mColor = maxLvl > 0 ? badColor : Colors.white;
              return [
                HomeRow(city.name),
                HomeRow(
                  '${sr.getCityLevel(city.id)}'
                  '${nextLvl > 0 ? ' ($nextLvl wk)' : ''}',
                  color: nColor,
                ),
                HomeRow(
                  '${GsUtils.cities.getCityMaxLevel(city.id)}'
                  '${maxLvl > 0 ? ' ($maxLvl wk)' : ''}',
                  color: mColor,
                ),
              ];
            }).toList(),
          ),
        );
      },
    );
  }
}
