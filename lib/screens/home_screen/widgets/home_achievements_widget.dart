import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeAchievementsWidget extends StatelessWidget {
  const HomeAchievementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final isaved = GsUtils.saveAchievements.countSavedRewards();
        final itotal = GsUtils.saveAchievements.countTotalRewards();
        return GsDataBox.info(
          title: Row(
            children: [
              Expanded(child: Text(context.fromLabel(Labels.achievements))),
              Text(
                isaved < itotal
                    ? '${isaved.format()} / ${itotal.format()}'
                    : isaved.format(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(width: kSeparator2),
              primoWidget(18, -1),
            ],
          ),
          children: [
            HomeTable(
              headers: [
                HomeRow.header(context.fromLabel(Labels.type)),
                HomeRow.header(Lang.of(context).getValue(Labels.owned)),
                HomeRow.header(Lang.of(context).getValue(Labels.total)),
              ],
              rows: GsAchievementType.values.map((e) {
                final utils = GsUtils.saveAchievements;
                final saved = utils.countSaved((a) => a.type == e);
                final total = utils.countTotal((a) => a.type == e);
                final color =
                    saved < total ? context.themeColors.badValue : Colors.white;
                return [
                  HomeRow(context.fromLabel(e.label)),
                  HomeRow(saved.format(), color: color),
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
