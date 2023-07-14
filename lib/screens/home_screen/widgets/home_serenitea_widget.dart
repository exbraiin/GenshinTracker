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
        final obtainableTotal =
            sets.expand((e) => e.chars.where(hasChar)).length;
        final ownedTotal = sets.expand((e) {
          final saved = ss.getItemOrNull(e.id);
          return e.chars.where((c) => saved?.chars.contains(c) ?? false);
        }).length;
        return GsDataBox.info(
          title: Row(
            children: [
              Expanded(child: Text(context.fromLabel(Labels.sereniteaSets))),
              Text(
                ownedTotal < obtainableTotal
                    ? '${(ownedTotal * primogems).format()} / '
                        '${(obtainableTotal * primogems).format()}'
                    : (ownedTotal * primogems).format(),
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
                HomeRow.header(Lang.of(context).getValue(Labels.obtainable)),
                HomeRow.header(Lang.of(context).getValue(Labels.total)),
              ],
              rows: GsSetCategory.values.map((e) {
                final cat = sets.where((s) => s.category == e);
                final ic = GsDatabase.instance.infoCharacters;
                final total = cat.expand((e) => e.chars).where(ic.exists);

                final hasChar = GsUtils.characters.hasCaracter;
                final obtainable = total.where(hasChar);

                final owned = cat.expand((e) {
                  final saved = ss.getItemOrNull(e.id);
                  return e.chars
                      .where((c) => saved?.chars.contains(c) ?? false);
                });

                final color = owned.length < obtainable.length
                    ? context.themeColors.badValue
                    : Colors.white;
                return [
                  HomeRow(context.fromLabel(e.label)),
                  HomeRow(owned.length.format(), color: color),
                  HomeRow(obtainable.length.format()),
                  HomeRow(total.length.format()),
                ];
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
