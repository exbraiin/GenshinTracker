import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeReputationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.subtitle2!.copyWith(color: Colors.white);
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final db = GsDatabase.instance;
        return Container(
          decoration: BoxDecoration(
            color: GsColors.mainColor2,
            boxShadow: mainShadow,
            borderRadius: kMainRadius,
          ),
          padding: EdgeInsets.all(4),
          child: Column(
            children: [
              SizedBox(
                height: 26,
                child: Center(
                  child: Text(
                    Lang.of(context).getValue(Labels.reputation),
                    style: style.copyWith(fontSize: 16),
                  ),
                ),
              ),
              Divider(indent: 8, endIndent: 8, color: Colors.white),
              HomeTable(
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
            ],
          ),
        );
      },
    );
  }
}
