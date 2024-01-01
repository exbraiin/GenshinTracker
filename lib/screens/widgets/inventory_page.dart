import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';

typedef ItemBuilder = Widget Function(BuildContext context, IndexState state);
typedef IndexState = ({int index, bool selected, VoidCallback onSelect});
typedef ItemState<T extends GsModel<T>> = ({
  T item,
  bool selected,
  VoidCallback onSelect,
  ScreenFilter<T>? filter,
});

enum SortOrder {
  none,
  ascending,
  descending,
}

class InventoryListPage<T extends GsModel<T>> extends StatelessWidget {
  final String icon;
  final String title;
  final Size childSize;
  final SortOrder sortOrder;
  final Iterable<T> Function(Database db) items;
  final List<Widget> Function(
    bool Function(String) hasExtra,
    void Function(String label) toggle,
  )? actions;
  final Widget Function(BuildContext context, T item)? itemCardBuilder;
  final Widget Function(BuildContext context, ItemState<T> state) itemBuilder;

  const InventoryListPage({
    super.key,
    this.actions,
    this.sortOrder = SortOrder.ascending,
    this.childSize = const Size(126, 160),
    this.itemCardBuilder,
    required this.icon,
    required this.title,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();
        final db = Database.instance;
        final items = switch (sortOrder) {
          SortOrder.none => this.items(db).toList(),
          SortOrder.ascending => this.items(db).sorted(),
          SortOrder.descending => this.items(db).sortedDescending(),
        };

        final filter = ScreenFilters.of<T>();
        if (filter == null) {
          return _InventoryGridPage.builder(
            childWidth: childSize.width,
            childHeight: childSize.height,
            appBar: InventoryAppBar(
              label: title,
              iconAsset: icon,
            ),
            itemCount: items.length,
            itemBuilder: (context, state) => itemBuilder(
              context,
              (
                item: items[state.index],
                selected: state.selected,
                onSelect: state.onSelect,
                filter: null,
              ),
            ),
            itemCardBuilder: itemCardBuilder != null
                ? (context, index) => itemCardBuilder!(context, items[index])
                : null,
          );
        }

        return ScreenFilterBuilder<T>(
          builder: (context, filter, button, toggle) {
            final sorted = filter.match(items).toList();
            final hasExtra = filter.hasExtra;
            final other = actions?.call(hasExtra, toggle) ?? const [];
            return _InventoryGridPage.builder(
              childWidth: childSize.width,
              childHeight: childSize.height,
              appBar: InventoryAppBar(
                label: title,
                iconAsset: icon,
                actions: [...other, button].separate(const SizedBox(width: 2)),
              ),
              itemCount: sorted.length,
              itemBuilder: (context, state) => itemBuilder(
                context,
                (
                  item: sorted[state.index],
                  selected: state.selected,
                  onSelect: state.onSelect,
                  filter: filter,
                ),
              ),
              itemCardBuilder: itemCardBuilder != null
                  ? (context, index) => itemCardBuilder!(context, sorted[index])
                  : null,
            );
          },
        );
      },
    );
  }
}

class InventoryRow {
  final List<InventoryBox> boxes;
  InventoryRow(this.boxes);
  InventoryRow.one(InventoryBox box) : boxes = [box];
}

class InventoryPage extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? child;

  const InventoryPage({
    super.key,
    this.appBar,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.themeColors.mainColor0,
      padding: const EdgeInsets.all(kGridSeparator),
      child: Column(
        children: [
          if (appBar != null)
            InventoryBox(
              height: appBar!.preferredSize.height,
              margin: const EdgeInsets.only(bottom: kGridSeparator),
              child: appBar,
            ),
          if (child != null) Expanded(child: child!),
        ],
      ),
    );
  }
}

class _InventoryGridPage extends StatefulWidget {
  final double childWidth;
  final double childHeight;
  final int itemCount;
  final PreferredSizeWidget? appBar;
  final ItemBuilder itemBuilder;
  final IndexedWidgetBuilder? itemCardBuilder;

  const _InventoryGridPage.builder({
    this.appBar,
    this.childWidth = 126,
    this.childHeight = 160,
    this.itemCardBuilder,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<_InventoryGridPage> createState() => _InventoryGridPageState();
}

class _InventoryGridPageState extends State<_InventoryGridPage> {
  var _selectedIndex = 0;

  @override
  void didUpdateWidget(covariant _InventoryGridPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemCount == widget.itemCount) return;
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return InventoryPage(
      appBar: widget.appBar,
      child: Row(
        children: [
          Expanded(
            child: InventoryBox(
              child: widget.itemCount < 1
                  ? const GsNoResultsState()
                  : GsGridView.builder(
                      padding: EdgeInsets.zero,
                      childWidth: widget.childWidth,
                      childHeight: widget.childHeight,
                      itemCount: widget.itemCount,
                      itemBuilder: (context, index) => widget.itemBuilder(
                        context,
                        (
                          index: index,
                          selected: index == _selectedIndex,
                          onSelect: () =>
                              setState(() => _selectedIndex = index),
                        ),
                      ),
                    ),
            ),
          ),
          if (widget.itemCardBuilder != null)
            InventoryBox(
              width: 400,
              height: double.infinity,
              margin: const EdgeInsets.only(left: kGridSeparator),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: widget.itemCount > 0
                    ? widget.itemCardBuilder!(context, _selectedIndex)
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

class InventoryBox extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;

  const InventoryBox({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? kListPadding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.themeColors.mainColor1,
        borderRadius: kGridRadius,
      ),
      child: child,
    );
  }
}

class InventoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final Widget? icon;
  final String? iconAsset;
  final Iterable<Widget> actions;

  const InventoryAppBar({
    super.key,
    required this.label,
    this.icon,
    this.iconAsset,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: kGridSeparator),
            child: icon,
          ),
        if (iconAsset != null)
          Padding(
            padding: const EdgeInsets.only(right: kGridSeparator),
            child: Image.asset(iconAsset!, width: 40, height: 40),
          ),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).appBarTheme.titleTextStyle ??
                context.textTheme.titleLarge,
          ),
        ),
        ...actions,
        if (Navigator.of(context).canPop()) ...[
          const VerticalDivider(),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
