import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class HomeFriendsWidget extends StatelessWidget {
  const HomeFriendsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final chars = GsUtils.characters;
        final db = GsDatabase.instance;
        final characters = db.infoCharacters
            .getItems()
            .where((c) => chars.hasCaracter(c.id))
            .where((c) => chars.getCharFriendship(c.id) != 10)
            .sortedByDescending((e) => chars.getCharFriendship(e.id));

        if (characters.isEmpty) {
          return GsDataBox.info(
            title: Text(context.fromLabel(Labels.friendship)),
            child: const GsNoResultsState.small(),
          );
        }

        return GsDataBox.info(
          title: Text(context.fromLabel(Labels.friendship)),
          child: LayoutBuilder(
            builder: (context, layout) {
              final itemSize = ItemSize.small.gridSize + kGridSeparator;
              final width = layout.maxWidth;
              final items = (width ~/ itemSize).coerceAtMost(8);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: characters
                    .take(items)
                    .map<Widget>((info) {
                      return ItemGridWidget.character(
                        info,
                        label: chars.getCharFriendship(info.id).format(),
                      );
                    })
                    .separate(const SizedBox(width: kGridSeparator))
                    .toList(),
              );
            },
          ),
        );
      },
    );
  }
}
