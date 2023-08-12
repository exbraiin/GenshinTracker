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
        final info = GsUtils.achievements;
        final itotal = info.countTotalRewards();
        final isaved = info.countSavedRewards();

        final totalSaved = info.countSaved();
        final totalTotal = info.countTotal();

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
              const PrimogemIcon(size: 18, offset: Offset(0, -1)),
            ],
          ),
          children: [
            HomeTable(
              headers: [
                HomeRow.header(context.fromLabel(Labels.type)),
                HomeRow.header(context.fromLabel(Labels.owned)),
                HomeRow.header(context.fromLabel(Labels.total)),
              ],
              rows: [
                ...GsAchievementType.values.map((e) {
                  final saved = info.countSaved((a) => a.type == e);
                  final total = info.countTotal((a) => a.type == e);
                  return [
                    HomeRow(context.fromLabel(e.label)),
                    HomeRow.missing(context, saved, total),
                    HomeRow(total.format()),
                  ];
                }),
                List.generate(3, (i) => const Divider()),
                [
                  HomeRow(context.fromLabel(Labels.total)),
                  HomeRow.missing(context, totalSaved, totalTotal),
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
