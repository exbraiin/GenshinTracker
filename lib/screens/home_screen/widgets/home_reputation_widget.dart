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
          title: Text(context.fromLabel(Labels.reputation)),
          child: HomeTable(
            headers: [
              HomeRow.header(context.fromLabel(Labels.city)),
              HomeRow.header(context.fromLabel(Labels.current)),
              HomeRow.header(context.fromLabel(Labels.max)),
            ],
            rows: db.infoCities
                .getItems()
                .where((e) => GsUtils.cities.getCityMaxLevel(e.id) > 1)
                .map((city) {
              final utils = GsUtils.cities;
              final maxLvl = utils.getCityMaxLevelWeeks(city.id);
              final nextLvl = utils.getCityNextLevelWeeks(city.id);
              final nColor = nextLvl > 0 ? badColor : Colors.white;
              final mColor = maxLvl > 0 ? badColor : Colors.white;
              return [
                HomeRow(city.name),
                HomeRow(
                  '${utils.getCityLevel(city.id)}'
                  '${nextLvl > 0 ? ' (${context.fromLabel(Labels.shortWeek, nextLvl)})' : ''}',
                  color: nColor,
                ),
                HomeRow(
                  '${GsUtils.cities.getCityMaxLevel(city.id)}'
                  '${maxLvl > 0 ? ' (${context.fromLabel(Labels.shortWeek, maxLvl)})' : ''}',
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
