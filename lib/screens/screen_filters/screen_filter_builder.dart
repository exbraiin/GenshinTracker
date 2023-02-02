import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';

typedef FilterBuilder<T> = Widget Function(
  BuildContext context,
  ScreenFilter<T> filter,
  Widget button,
  void Function(String extra) toggle,
);

class ScreenFilterBuilder<T> extends StatelessWidget {
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
      padding: const EdgeInsets.all(kSeparator8),
      decoration: const BoxDecoration(
        color: GsColors.mainColor1,
        borderRadius: kMainRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.fromLabel(Labels.filter),
                    style: const TextStyle(color: Colors.white, fontSize: 26),
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
            const Divider(color: Colors.white),
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: notifier,
                builder: (context, value, child) {
                  return ListView(
                    children: widget.filter.sections
                        .map((e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.title(context),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: kSeparator8),
                                Wrap(
                                  spacing: kSeparator4,
                                  runSpacing: kSeparator4,
                                  children: e.values
                                      .map((v) => _chip(
                                            context,
                                            e.label(context, v),
                                            e.icon(v),
                                            e.asset(v),
                                            e.enabled.contains(v),
                                            () {
                                              e.toggle(v);
                                              notifier.value = !notifier.value;
                                            },
                                          ))
                                      .toList(),
                                ),
                              ],
                            ))
                        .toGrid(
                          spacing: kSeparator8,
                          runSpacing: kSeparator8,
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    IconData? eIcon,
    String? eAsset,
    bool selected,
    VoidCallback onTap,
  ) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: GsColors.mainColor0.withOpacity(0.6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: selected
              ? Colors.orange.withOpacity(0.8)
              : Colors.white.withOpacity(0.8),
        ),
      ),
      padding: const EdgeInsets.all(kSeparator4),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (eIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: kSeparator4),
                child: Icon(
                  eIcon,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            if (eAsset != null && eAsset.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: kSeparator4),
                child: Image.asset(
                  eAsset,
                  width: 20,
                  height: 20,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSeparator4),
              child: Text(
                label,
                style: context.textTheme.cardLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Iterable<Widget> {
  Iterable<Widget> toGrid({
    int columns = 2,
    double spacing = 0,
    double runSpacing = 0,
  }) sync* {
    final it = iterator;
    if (!it.moveNext()) return;
    var canMove = true;
    while (true) {
      var items = <Widget>[];
      for (var r = 0; r < columns; ++r) {
        items.add(Expanded(child: canMove ? it.current : const SizedBox()));
        if (spacing > 0 && r + 1 < columns) items.add(SizedBox(width: spacing));
        canMove = it.moveNext();
      }
      yield Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      );
      if (!canMove) return;
      if (runSpacing > 0) yield SizedBox(height: runSpacing);
    }
  }
}
