import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';

class HomeResourceCalcWidget extends StatefulWidget {
  const HomeResourceCalcWidget({super.key});

  @override
  State<HomeResourceCalcWidget> createState() => _HomeResourceCalcWidgetState();
}

class _HomeResourceCalcWidgetState extends State<HomeResourceCalcWidget> {
  late final ValueNotifier<_ResourceInfo> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(_ResourceInfo());
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.subtitle2!.copyWith(color: Colors.white);
    return GsDataBox.summary(
      title: context.fromLabel(Labels.resourceCalculator),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Lang.of(context).getValue(Labels.required),
            style: style.copyWith(fontSize: 14),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (idx) => Expanded(
              child: _getField(
                style,
                (i) => _notifier.value = _notifier.value.setRequired(idx, i),
              ),
            ),
          ),
        ),
        const SizedBox(height: kSeparator4),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Lang.of(context).getValue(Labels.owned),
            style: style.copyWith(fontSize: 14),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (idx) => Expanded(
              child: _getField(
                style,
                (i) => _notifier.value = _notifier.value.setOwned(idx, i),
              ),
            ),
          ),
        ),
        _getResourceInfo(),
      ],
    );
  }

  Widget _getResourceInfo() {
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.infoLabel.copyWith(
      fontSize: 12,
      color: Colors.white,
    );
    return ValueListenableBuilder<_ResourceInfo>(
      valueListenable: _notifier,
      builder: (context, value, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: kSeparator4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Lang.of(context).getValue(Labels.craftable),
                style: style.copyWith(fontSize: 14),
              ),
            ),
            Row(
              children: List.generate(
                5,
                (idx) => Expanded(
                  child: _getText(
                    value.getCraftable(idx).toString(),
                    style.copyWith(color: Colors.white.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: kSeparator4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Lang.of(context).getValue(Labels.missing),
                style: style.copyWith(fontSize: 14),
              ),
            ),
            Row(
              children: List.generate(
                5,
                (idx) {
                  final missing = value.getMissing(idx);
                  final st = style.copyWith(
                    color: missing > 0 ? Colors.redAccent : Colors.lightGreen,
                  );
                  return Expanded(
                    child: _getText(missing.toString(), st),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getText(String text, TextStyle style) {
    return Container(
      margin: const EdgeInsets.all(kSeparator2),
      padding: const EdgeInsets.all(kSeparator4),
      decoration: BoxDecoration(
        border: Border.all(color: GsColors.mainColor3, width: 0.6),
        borderRadius: kMainRadius,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }

  Widget _getField(TextStyle style, void Function(int) onEdit) {
    return Container(
      margin: const EdgeInsets.all(kSeparator2),
      padding: const EdgeInsets.all(kSeparator4),
      decoration: BoxDecoration(
        borderRadius: kMainRadius,
        border: Border.all(
          color: GsColors.mainColor3,
          width: 0.6,
        ),
      ),
      child: GsNumberField(
        length: 4,
        onUpdate: (t) => onEdit.call(t),
      ),
    );
  }
}

class _ResourceInfo {
  final List<int> owned;
  final List<int> required;

  _ResourceInfo._({
    required this.owned,
    required this.required,
  });

  _ResourceInfo()
      : owned = [0, 0, 0, 0, 0],
        required = [0, 0, 0, 0, 0];

  _ResourceInfo selfCopy() => _ResourceInfo._(owned: owned, required: required);

  _ResourceInfo setOwned(int idx, int value) {
    owned[idx] = value;
    return selfCopy();
  }

  _ResourceInfo setRequired(int idx, int value) {
    required[idx] = value;
    return selfCopy();
  }

  int getOwned(int idx) => owned[idx];

  int getRequired(int idx) => required[idx];

  int getCraftable(int idx) => idx < 1
      ? 0
      : ((getCraftable(idx - 1) + getOwned(idx - 1) - getRequired(idx - 1))
                  .coerceAtLeast(0) /
              3)
          .floor();

  int getMissing(int idx) =>
      (getRequired(idx) - getOwned(idx) - getCraftable(idx)).coerceAtLeast(0);
}
