import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/widgets/button.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

typedef FilterBuilder<T extends GsModel<T>> = Widget Function(
  BuildContext context,
  ScreenFilter<T> filter,
  Widget button,
  void Function(String extra) toggle,
);

class ScreenFilterBuilder<T extends GsModel<T>> extends StatelessWidget {
  final notifier = ValueNotifier(false);
  final ScreenFilter<T> filter;
  final FilterBuilder<T> builder;

  ScreenFilterBuilder({
    super.key,
    required this.filter,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, value, child) {
        final button = IconButton(
          onPressed: () => _GsFilterDialog.show(context, filter)
              .then((value) => notifier.value = !notifier.value),
          icon: const Icon(Icons.filter_alt_rounded),
        );
        return builder(context, filter, button, (v) {
          filter.toggleExtra(v);
          notifier.value = !notifier.value;
        });
      },
    );
  }
}

class _GsFilterDialog extends StatefulWidget {
  static Future<void> show(BuildContext context, ScreenFilter filter) async {
    return showDialog(
      context: context,
      builder: (_) => _GsFilterDialog(filter),
    );
  }

  final ScreenFilter filter;

  const _GsFilterDialog(this.filter);

  @override
  State<_GsFilterDialog> createState() => _GsFilterDialogState();
}

class _GsFilterDialogState extends State<_GsFilterDialog> {
  final notifier = ValueNotifier(false);

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.height / 4,
        horizontal: size.width / 4,
      ),
      padding: kListPadding,
      decoration: BoxDecoration(
        color: context.themeColors.mainColor0,
        borderRadius: kGridRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            InventoryBox(
              child: Row(
                children: [
                  const SizedBox(width: kGridSeparator),
                  Expanded(
                    child: Text(
                      context.fromLabel(Labels.filter),
                      style: context.themeStyles.title18n,
                      strutStyle: context.themeStyles.title18n.toStrut(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.restart_alt_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      widget.filter.reset();
                      notifier.value = !notifier.value;
                      Navigator.of(context).maybePop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: kGridSeparator),
            Expanded(
              child: InventoryBox(
                padding: const EdgeInsets.all(kGridSeparator * 2),
                child: ValueListenableBuilder<bool>(
                  valueListenable: notifier,
                  builder: (context, value, child) {
                    final half = widget.filter.sections.length ~/ 2;
                    return SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.filter.sections
                                  .take(half)
                                  .map(_filter)
                                  .separate(const SizedBox(height: 12))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(width: kSeparator8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.filter.sections
                                  .skip(half)
                                  .map(_filter)
                                  .separate(const SizedBox(height: 12))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filter(FilterSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title(context),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: kGridSeparator * 2),
        Wrap(
          spacing: kGridSeparator,
          runSpacing: kGridSeparator,
          children: section.values.map((v) {
            return MainButton(
              selected: section.enabled.contains(v),
              label: section.label(context, v),
              onPress: () {
                section.toggle(v);
                notifier.value = !notifier.value;
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
