import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class HomeAscensionWidget extends StatefulWidget {
  const HomeAscensionWidget({super.key});

  @override
  State<HomeAscensionWidget> createState() => _HomeAscensionWidgetState();
}

class _HomeAscensionWidgetState extends State<HomeAscensionWidget> {
  final _notifier = ValueNotifier(false);

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        final characters = Database.instance
            .infoOf<GsCharacter>()
            .items
            .where(GsUtils.characters.isCharAscendable)
            .sortedByDescending((e) => e.rarity)
            .thenBy((e) => e.id);

        if (characters.isEmpty) {
          return GsDataBox.info(
            title: Text(context.labels.ascension()),
            child: const GsNoResultsState.small(),
          );
        }

        const chars = GsUtils.characters;
        return GsDataBox.info(
          title: Text(context.labels.ascension()),
          child: LayoutBuilder(
            builder: (context, layout) {
              final itemSize = ItemSize.small.gridSize + kGridSeparator;
              final width = layout.maxWidth;
              final items = (width ~/ itemSize).coerceAtMost(8);
              final list = characters.take(items);
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: list
                        .map<Widget>((info) {
                          return ItemGridWidget.character(
                            info,
                            label: '✦${chars.getCharAscension(info.id)}',
                            onAdd: (ctx) =>
                                GsUtils.characters.increaseAscension(info.id),
                          );
                        })
                        .separate(const SizedBox(width: kGridSeparator))
                        .toList(),
                  ),
                  _getMaterialsList(list),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _getMaterialsList(Iterable<GsCharacter> characters) {
    if (characters.isEmpty) return const SizedBox();

    MapEntry<GsMaterial?, int> combine(
      List<MapEntry<GsMaterial?, int>> list,
    ) {
      final valid = list.where((e) => e.key != null);
      final first = valid.firstOrNull;
      if (first == null) return const MapEntry(null, 0);
      if (valid.map((e) => e.key!.id).toSet().length != 1) return first;
      return MapEntry(first.key, valid.sumBy((e) => e.value).toInt());
    }

    const db = GsUtils.characterMaterials;
    final materials = characters
        .expand((e) => db.getCharNextAscensionMats(e.id))
        .groupBy((e) => e.key?.id)
        .values
        .map(combine)
        .where((e) => e.key != null)
        .sortedWith((a, b) => a.key!.compareTo(b.key!));

    return ValueListenableBuilder<bool>(
      valueListenable: _notifier,
      builder: (context, expanded, child) {
        return Column(
          children: [
            SizedBox(
              child: Center(
                child: IconButton(
                  onPressed: () => _notifier.value = !_notifier.value,
                  padding: const EdgeInsets.all(kSeparator4),
                  constraints: const BoxConstraints.tightFor(),
                  icon: AnimatedRotation(
                    turns: expanded ? 0.5 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 400),
              constraints: BoxConstraints(maxHeight: expanded ? 300 : 0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: kSeparator4),
                child: Wrap(
                  spacing: kSeparator4,
                  runSpacing: kSeparator4,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: materials.map((e) {
                    return ItemGridWidget.material(
                      e.key!,
                      label: e.value.compact(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
