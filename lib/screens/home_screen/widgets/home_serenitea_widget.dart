import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/home_screen/widgets/home_table.dart';

class HomeSereniteaWidget extends StatelessWidget {
  const HomeSereniteaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const primogems = GsDomain.primogemsPerCharSet;
    final sets = GsDatabase.instance.infoSereniteaSets.getItems();
    final ss = GsDatabase.instance.saveSereniteaSets;
    final hasChar = GsUtils.characters.hasCaracter;
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final ic = GsDatabase.instance.infoCharacters;
        final totalTotal = sets.expand((e) => e.chars).count(ic.exists);
        final totalObtain = sets.expand((e) => e.chars.where(hasChar)).length;
        final totalOwned = sets.expand((e) {
          final saved = ss.getItemOrNull(e.id);
          return e.chars.where((c) => saved?.chars.contains(c) ?? false);
        }).length;

        return GsDataBox.info(
          title: Row(
            children: [
              Expanded(child: Text(context.fromLabel(Labels.sereniteaSets))),
              Text(
                totalOwned < totalObtain
                    ? '${(totalOwned * primogems).format()} / '
                        '${(totalObtain * primogems).format()}'
                    : (totalOwned * primogems).format(),
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
                HomeRow.header(context.fromLabel(Labels.obtainable)),
                HomeRow.header(context.fromLabel(Labels.total)),
              ],
              rows: [
                ...GsSetCategory.values.map((e) {
                  final cat = sets.where((s) => s.category == e);
                  final total = cat.expand((e) => e.chars).where(ic.exists);

                  final hasChar = GsUtils.characters.hasCaracter;
                  final obtainable = total.where(hasChar);

                  final owned = cat.expand((e) {
                    final saved = ss.getItemOrNull(e.id);
                    return e.chars
                        .where((c) => saved?.chars.contains(c) ?? false);
                  });

                  return [
                    HomeRow(context.fromLabel(e.label)),
                    HomeRow.missing(context, owned.length, obtainable.length),
                    HomeRow(obtainable.length.format()),
                    HomeRow(total.length.format()),
                  ];
                }),
                List.generate(4, (i) => const Divider()),
                [
                  HomeRow(context.fromLabel(Labels.total)),
                  HomeRow.missing(context, totalOwned, totalObtain),
                  HomeRow(totalObtain.format()),
                  HomeRow(totalTotal.format()),
                ]
              ],
            ),
          ],
        );
      },
    );
  }
}
