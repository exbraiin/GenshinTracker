import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_button.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';

class ScreenDrawerBuilder<T> extends StatelessWidget {
  final _notifier = ValueNotifier(false);
  final ScreenFilter<T> Function() filter;
  final Widget Function(BuildContext c, ScreenFilter<T> f, _Drawer<T> d)
      builder;

  ScreenDrawerBuilder({
    required this.filter,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _notifier,
      builder: (context, trigger, child) {
        final filter = this.filter();
        final drawer = _Drawer<T>(filter, _trigger);
        return builder(context, filter, drawer);
      },
    );
  }

  void _trigger() => _notifier.value = !_notifier.value;
}

class _Drawer<T> extends StatelessWidget {
  final ScreenFilter<T> filter;
  final VoidCallback onNotify;

  _Drawer(this.filter, this.onNotify);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(kSeparator8),
      decoration: BoxDecoration(
        color: GsColors.mainColor0,
        border: Border(left: BorderSide(color: GsColors.mainColor3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.fromLabel(Labels.filter),
            style: context.textTheme.bigTitle2,
          ),
          SizedBox(height: kSeparator4),
          Expanded(
            child: ListView(
              children: filter.sections
                  .map((item) => _buildSection(context, item))
                  .toList(),
            ),
          ),
          SizedBox(height: kSeparator4),
          Row(
            children: [
              Expanded(
                child: GsButton(
                  onPressed: () {
                    filter.reset();
                    onNotify();
                    Navigator.of(context).maybePop();
                  },
                  borderRadius: kMainRadius,
                  child: Center(
                    child: Text(
                      'Clear',
                      style: context.textTheme.infoLabel
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(width: kSeparator8),
              Expanded(
                child: GsButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  borderRadius: kMainRadius,
                  child: Center(
                    child: Text(
                      'Apply',
                      style: context.textTheme.infoLabel
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    FilterSection<dynamic, T> section,
  ) {
    final hasSorting = section.comparator != null;
    final sorting = filter.sorting.contains(section);
    final icon = !sorting
        ? Icons.remove_circle_outline_rounded
        : section.order < 0
            ? Icons.arrow_circle_down_rounded
            : Icons.arrow_circle_up_rounded;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (hasSorting)
              IconButton(
                onPressed: () {
                  filter.addSort(section);
                  onNotify();
                },
                iconSize: 18,
                color: Colors.white.withOpacity(sorting ? 1 : kDisableOpacity),
                constraints: BoxConstraints.tightFor(),
                icon: Icon(icon),
                padding: EdgeInsets.all(kSeparator4),
              ),
            Text(
              section.title(context),
              style: context.textTheme.infoLabel.copyWith(color: Colors.white),
            ),
            if (hasSorting && sorting)
              Text(
                ' (${filter.sorting.indexOf(section) + 1})',
                style: Theme.of(context)
                    .textTheme
                    .infoLabel
                    .copyWith(color: Colors.green),
              ),
          ],
        ),
        SizedBox(height: kSeparator2),
        Wrap(
          spacing: kSeparator4,
          runSpacing: kSeparator4,
          children: section.values.map((e) {
            final eIcon = section.icon.call(e);
            final eAsset = section.asset.call(e);
            final selected = section.enabled.contains(e);
            return GsButton(
              onPressed: () {
                section.toggle(e);
                onNotify();
              },
              color: selected ? GsColors.mainColor3 : Colors.transparent,
              border: Border.all(color: GsColors.mainColor3),
              borderRadius: kMainRadius,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (eIcon != null)
                    Padding(
                      padding: EdgeInsets.only(right: kSeparator4),
                      child: Icon(
                        eIcon,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  if (eAsset != null && eAsset.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(right: kSeparator4),
                      child: Image.asset(
                        eAsset,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  Text(
                    section.label(context, e),
                    style: context.textTheme.infoLabel
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: kSeparator8),
      ],
    );
  }
}
