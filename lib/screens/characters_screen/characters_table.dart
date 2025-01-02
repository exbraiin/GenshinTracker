import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/characters_screen/character_details_card.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class CharactersTable extends StatefulWidget {
  final bool showTodo;
  final List<GsCharacter> characters;

  const CharactersTable({
    super.key,
    this.showTodo = false,
    required this.characters,
  });

  @override
  State<CharactersTable> createState() => _CharactersTableState();
}

class _CharactersTableState extends State<CharactersTable> {
  var _sorter = false;
  _TableItem? _sortItem;
  var _idSortedList = <String>[];
  late final List<_TableItem> _builders;

  @override
  void initState() {
    super.initState();
    _builders = _getBuilders(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Table(
        columnWidths: Map.fromEntries(
          _builders.mapIndexed(
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
            children: _builders.map((item) {
              return InkWell(
                onTap: item.sortBy != null
                    ? () {
                        setState(() {
                          if (_sortItem == null || _sortItem != item) {
                            _sorter = true;
                            _sortItem = item;
                          } else if (_sorter) {
                            _sorter = false;
                          } else {
                            _sorter = true;
                            _sortItem = null;
                          }
                          _idSortedList = _getCharsIdsSorted();
                        });
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kSeparator4,
                    horizontal: kSeparator8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        item.label,
                        textAlign: !item.expand ? TextAlign.center : null,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        _sortItem == item
                            ? _sorter
                                ? Icons.arrow_drop_up_rounded
                                : Icons.arrow_drop_down_rounded
                            : null,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          ..._getCharsSorted().map((item) {
            final char = item.char;
            final info = item.info;
            return TableRow(
              children: _builders.map<Widget>((e) {
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

  List<_TableItem> _getBuilders(BuildContext context) {
    double unowned() => _sorter ? double.infinity : double.negativeInfinity;
    return [
      _TableItem(
        label: 'Icon',
        builder: (char, info) => ItemCircleWidget(
          image: info.iconImage,
          size: ItemSize.large,
          rarity: char.rarity,
        ),
        allowTap: true,
        onTap: (char, info) => CharacterDetailsCard(char).show(context),
      ),
      _TableItem(
        label: 'Element',
        sortBy: (e) => e.char.element.index,
        builder: (char, info) => ItemCircleWidget.element(
          char.element,
          size: ItemSize.medium,
        ),
      ),
      _TableItem(
        label: 'Name',
        sortBy: (e) => e.char.name,
        builder: (char, info) => Text(char.name),
        expand: true,
      ),
      _TableItem(
        label: 'Friendship',
        sortBy: (e) => e.info.isOwned ? e.info.friendship : unowned(),
        builder: (char, info) => Text(
          info.isOwned ? '${info.friendship}' : '-',
          textAlign: TextAlign.center,
        ),
        onTap: (char, info) =>
            GsUtils.characters.increaseFriendshipCharacter(char.id),
      ),
      _TableItem(
        label: 'Ascension',
        sortBy: (e) => e.info.isOwned ? e.info.ascension : unowned(),
        builder: (char, info) => Text(
          info.isOwned ? '${info.ascension} ✦' : '-',
          textAlign: TextAlign.center,
        ),
        onTap: (char, info) => GsUtils.characters.increaseAscension(char.id),
      ),
      _TableItem(
        label: 'Constellations',
        sortBy: (e) => e.info.isOwned ? e.info.totalConstellations : unowned(),
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
        sortBy: (e) => e.info.talent1 ?? unowned(),
        builder: (char, info) => Text(
          info.talent1?.toString() ?? '-',
          textAlign: TextAlign.center,
        ),
        onTap: (char, info) => GsUtils.characters.increaseTalent1(char.id),
      ),
      _TableItem(
        label: 'Tal. E',
        sortBy: (e) => e.info.talent2 ?? unowned(),
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
        sortBy: (e) => e.info.talent3 ?? unowned(),
        builder: (char, info) => Text(
          info.talent3?.toString() ?? '-',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: (info.talent3 ?? 0) > 10 ? Colors.lightBlue : null,
          ),
        ),
        onTap: (char, info) => GsUtils.characters.increaseTalent3(char.id),
      ),
      _TableItem(
        label: 'Tal. T',
        sortBy: (e) => e.info.talents ?? unowned(),
        builder: (char, info) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              info.talents?.toString() ?? '-',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: (info.talents ?? 0) >= 30 ? Colors.yellow : null,
              ),
            ),
            if ((info.talents ?? 0) >= 30)
              const Padding(
                padding: EdgeInsets.only(left: kSeparator2),
                child: Icon(
                  Icons.star_rounded,
                  color: Colors.yellow,
                ),
              ),
          ],
        ),
      ),
    ];
  }

  Iterable<_CharData> _getCharsSorted() {
    final info = GsUtils.characters.getCharInfo;
    var chars = widget.characters.map((e) => (char: e, info: info(e.id)));
    if (_idSortedList.isNotEmpty) {
      chars = chars.sortedBy((e) => _idSortedList.indexOf(e.char.id));
    }
    return chars;
  }

  List<String> _getCharsIdsSorted() {
    if (_sortItem == null) return const [];

    final info = GsUtils.characters.getCharInfo;
    final chars = widget.characters.map((e) => (char: e, info: info(e.id)));
    final sorted = _sorter ? chars.sortedBy : chars.sortedByDescending;

    return sorted((e) => _sortItem!.sortBy?.call(e) ?? 0)
        .thenBy((e) => e.char.name)
        .map((e) => e.char.id)
        .toList();
  }
}

typedef _CharData = ({GsCharacter char, CharInfo info});

class _TableItem {
  final String label;
  final bool expand;
  final bool allowTap;
  final Comparable Function(_CharData)? sortBy;
  final void Function(GsCharacter char, CharInfo info)? onTap;
  final Widget Function(GsCharacter char, CharInfo info) builder;

  _TableItem({
    this.sortBy,
    required this.label,
    required this.builder,
    this.onTap,
    this.expand = false,
    this.allowTap = false,
  });
}
