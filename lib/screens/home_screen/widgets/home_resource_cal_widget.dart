import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/graphics/gs_style.dart';

class HomeResourceCalcWidget extends StatefulWidget {
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
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: GsColors.mainColor2,
        boxShadow: mainShadow,
        borderRadius: kMainRadius,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 26,
            child: Center(
              child: Text(
                Lang.of(context).getValue(Labels.resourceCalculator),
                style: style.copyWith(fontSize: 16),
              ),
            ),
          ),
          Divider(indent: 8, endIndent: 8, color: Colors.white),
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
      ),
    );
  }

  Widget _getResourceInfo() {
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.subtitle2!.copyWith(color: Colors.white);
    return ValueListenableBuilder<_ResourceInfo>(
      valueListenable: _notifier,
      builder: (context, value, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            SizedBox(height: 6),
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
    final color = Colors.white.withOpacity(0.5);
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 0.5),
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
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 0.5),
      borderRadius: kMainRadius,
    );
    return Padding(
      padding: EdgeInsets.all(2),
      child: TextField(
        maxLength: 4,
        onChanged: (t) => onEdit.call(int.parse(t.isNullOrEmpty ? '0' : t)),
        style: style,
        decoration: InputDecoration(
          border: border,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: kMainRadius,
          ),
          disabledBorder: border,
          enabledBorder: border,
          counter: SizedBox(),
          hintText: '0',
          hintStyle: style.copyWith(color: Colors.white.withOpacity(0.5)),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          isDense: true,
        ),
        textAlign: TextAlign.center,
        scrollPadding: EdgeInsets.zero,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
