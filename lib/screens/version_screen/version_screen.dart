import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/version_screen/version_details_card.dart';
import 'package:tracker/screens/version_screen/version_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class VersionScreen extends StatelessWidget {
  static const id = 'version_screen';

  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<GsVersion>(
      childSize: const Size(126 * 2 + 6, 160),
      icon: menuIconBook,
      sortOrder: SortOrder.descending,
      title: context.labels.version(),
      items: (db) => db.infoOf<GsVersion>().items,
      actions: (hasExtra, toggle) {
        return [
          _TimeBuilder(
            builder: (context, child) {
              final seconds = Database.instance.cooldown.inSeconds;
              final disabled = seconds > 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: !disabled ? Database.instance.fetchRemote : null,
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Colors.white.withOpacity(
                        disabled ? 0.05 : kDisableOpacity,
                      ),
                    ),
                  ),
                  if (disabled)
                    Text(
                      '${seconds}s',
                      style: TextStyle(
                        color: Colors.white.withOpacity(kDisableOpacity),
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.right,
                    ),
                ],
              );
            },
          ),
          Text(
            'v${Database.instance.version}',
            style: TextStyle(color: Colors.white.withOpacity(kDisableOpacity)),
          ),
          const SizedBox(width: kSeparator4),
        ];
      },
      itemBuilder: (context, state) => VersionListItem(
        state.item,
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => VersionDetailsCard(
        item,
        key: ValueKey(item.id),
      ),
    );
  }
}

class _TimeBuilder extends StatefulWidget {
  final TransitionBuilder builder;

  const _TimeBuilder({
    required this.builder,
  });

  @override
  State<_TimeBuilder> createState() => _TimeBuilderState();
}

class _TimeBuilderState extends State<_TimeBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..forward()
      ..addStatusListener((status) {
        if (status != AnimationStatus.completed) return;
        setState(() {
          _controller
            ..reset()
            ..forward();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, null);
  }
}
