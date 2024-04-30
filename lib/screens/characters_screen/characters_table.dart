import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class CharactersTable extends StatelessWidget {
  final List<GsCharacter> characters;

  const CharactersTable({super.key, required this.characters});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: FlexColumnWidth(),
          3: IntrinsicColumnWidth(),
          4: IntrinsicColumnWidth(),
          5: IntrinsicColumnWidth(),
          6: IntrinsicColumnWidth(),
          7: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.symmetric(
          inside: BorderSide(
            color: context.themeColors.mainColor0,
          ),
        ),
        children: [
          TableRow(
            children: [
              'Icon',
              'Element',
              'Name',
              'Ascension',
              'Constellations',
              'Tal. A',
              'Tal. E',
              'Tal. Q',
            ].mapIndexed((i, e) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSeparator8,
                  vertical: kSeparator4,
                ),
                child: Text(
                  e,
                  textAlign: i != 2 ? TextAlign.center : null,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
          ...characters.map((char) {
            final info = GsUtils.characters.getCharInfo(char.id);

            return TableRow(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                    CharacterDetailsScreen.id,
                    arguments: char,
                  ),
                  child: ItemCircleWidget(
                    image: info.iconImage,
                    size: ItemSize.large,
                    rarity: char.rarity,
                  ),
                ),
                ItemCircleWidget.element(
                  char.element,
                  size: ItemSize.medium,
                ),
                Text(char.name),
                InkWell(
                  onTap: info.isOwned
                      ? () => GsUtils.characters.increaseAscension(char.id)
                      : null,
                  child: Text(
                    info.isOwned ? '${info.ascension} ✦' : '-',
                    textAlign: TextAlign.center,
                  ),
                ),
                Text.rich(
                  info.isOwned
                      ? TextSpan(
                          children: [
                            TextSpan(text: 'C${info.constellations}'),
                            if (info.extraConstellations > 0)
                              TextSpan(
                                text: ' (+${info.extraConstellations})',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        )
                      : const TextSpan(text: '-'),
                  textAlign: TextAlign.center,
                ),
                InkWell(
                  onTap: info.isOwned
                      ? () => GsUtils.characters.increaseTalent1(char.id)
                      : null,
                  child: Text(
                    info.talent1?.toString() ?? '-',
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: info.isOwned
                      ? () => GsUtils.characters.increaseTalent2(char.id)
                      : null,
                  child: Text(
                    info.talent2?.toString() ?? '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: info.hasCons3 ? Colors.lightBlue : null,
                    ),
                  ),
                ),
                InkWell(
                  onTap: info.isOwned
                      ? () => GsUtils.characters.increaseTalent3(char.id)
                      : null,
                  child: Text(
                    info.talent3?.toString() ?? '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: info.hasCons5 ? Colors.lightBlue : null,
                    ),
                  ),
                ),
              ].map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kSeparator8,
                    vertical: kSeparator4,
                  ),
                  child: Opacity(
                    opacity: info.isOwned ? 1 : kDisableOpacity,
                    child: e,
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
