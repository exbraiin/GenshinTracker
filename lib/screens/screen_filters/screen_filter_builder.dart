import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/theme/theme.dart';

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
      decoration: BoxDecoration(
        color: context.themeColors.mainColor1,
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
                                .separate(const SizedBox(height: kSeparator8))
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
                                .separate(const SizedBox(height: kSeparator8))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: kSeparator8),
        Wrap(
          spacing: kSeparator4,
          runSpacing: kSeparator4,
          children: section.values.map((v) {
            return _chip(
              context,
              section.label(context, v),
              section.icon(v),
              section.asset(v),
              section.enabled.contains(v),
              () {
                section.toggle(v);
                notifier.value = !notifier.value;
              },
            );
          }).toList(),
        ),
      ],
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
        color: context.themeColors.mainColor0.withOpacity(0.6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          width: 2,
          color: selected
              ? context.themeColors.primary.withOpacity(0.8)
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
                style: context.textTheme.filterLabel.copyWith(
                  color: selected ? context.themeColors.primary : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
