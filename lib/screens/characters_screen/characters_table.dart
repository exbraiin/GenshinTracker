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
    final builders = [
      _TableItem(
        label: 'Icon',
        builder: (char, info) => ItemCircleWidget(
          image: info.iconImage,
          size: ItemSize.large,
          rarity: char.rarity,
        ),
        allowTap: true,
        onTap: (char, info) => Navigator.of(context).pushNamed(
          CharacterDetailsScreen.id,
          arguments: char,
        ),
      ),
      _TableItem(
        label: 'Element',
        builder: (char, info) => ItemCircleWidget.element(
          char.element,
          size: ItemSize.medium,
        ),
      ),
      _TableItem(
        label: 'Name',
        builder: (char, info) => Text(char.name),
        expand: true,
      ),
      _TableItem(
        label: 'Friendship',
        builder: (char, info) => Text(
          info.isOwned ? '${info.friendship}' : '-',
          textAlign: TextAlign.center,
        ),
        onTap: (char, info) =>
            GsUtils.characters.increaseFriendshipCharacter(char.id),
      ),
      _TableItem(
        label: 'Ascension',
        builder: (char, info) => Text(
          info.isOwned ? '${info.ascension} ✦' : '-',
          textAlign: TextAlign.center,
        ),
        onTap: (char, info) => GsUtils.characters.increaseAscension(char.id),
      ),
      _TableItem(
        label: 'Constellations',
        builder: (char, info) => Text.rich(
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
      ),
      _TableItem(
        label: 'Tal. A',
        builder: (char, info) => Text(
          info.talent1?.toString() ?? '-',
          textAlign: TextAlign.center,
        ),
        onTap: (char, info) => GsUtils.characters.increaseTalent1(char.id),
      ),
      _TableItem(
        label: 'Tal. E',
        builder: (char, info) => Text(
          info.talent2?.toString() ?? '-',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: (info.talent2 ?? 0) > 10 ? Colors.lightBlue : null,
          ),
        ),
        onTap: (char, info) => GsUtils.characters.increaseTalent2(char.id),
      ),
      _TableItem(
        label: 'Tal. Q',
        builder: (char, info) => Text(
          info.talent3?.toString() ?? '-',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: (info.talent3 ?? 0) > 10 ? Colors.lightBlue : null,
          ),
        ),
        onTap: (char, info) => GsUtils.characters.increaseTalent3(char.id),
      ),
    ];

    return SingleChildScrollView(
      child: Table(
        columnWidths: Map.fromEntries(
          builders.mapIndexed(
            (i, e) => MapEntry(
              i,
              e.expand ? const FlexColumnWidth() : const IntrinsicColumnWidth(),
            ),
          ),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.symmetric(
          inside: BorderSide(
            color: context.themeColors.mainColor0,
          ),
        ),
        children: [
          TableRow(
            children: builders.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: kSeparator4,
                  horizontal: kSeparator8,
                ),
                child: Text(
                  e.label,
                  textAlign: !e.expand ? TextAlign.center : null,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
          ...characters.map((char) {
            final info = GsUtils.characters.getCharInfo(char.id);
            return TableRow(
              children: builders.map<Widget>((e) {
                final child = Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kSeparator4,
                    horizontal: kSeparator8,
                  ),
                  child: Opacity(
                    opacity: info.isOwned ? 1 : kDisableOpacity,
                    child: e.builder(char, info),
                  ),
                );

                if (e.onTap != null && (e.allowTap || info.isOwned)) {
                  return InkWell(
                    onTap: () => e.onTap!(char, info),
                    child: child,
                  );
                }

                return child;
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

class _TableItem {
  final String label;
  final bool expand;
  final bool allowTap;
  final void Function(GsCharacter char, CharInfo info)? onTap;

  final Widget Function(GsCharacter char, CharInfo info) builder;

  _TableItem({
    required this.label,
    required this.builder,
    this.onTap,
    this.expand = false,
    this.allowTap = false,
  });
}
