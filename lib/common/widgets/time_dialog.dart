import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/card_dialog.dart';

class TimeDialog extends StatefulWidget {
  final DateTime? date;

  TimeDialog._(this.date);

  static Future<DateTime?> show(BuildContext context, [DateTime? date]) {
    return showDialog<DateTime?>(
      context: context,
      builder: (_) => TimeDialog._(date),
    );
  }

  @override
  _TimeDialogState createState() => _TimeDialogState();
}

class _TimeDialogState extends State<TimeDialog>
    with SingleTickerProviderStateMixin {
  static DateTime? _savedTime;
  late final AnimationController _animation;
  late final FixedExtentScrollController year, month, day;
  late final FixedExtentScrollController hour, minute, second;

  bool get _isLocked => _savedTime != null;

  @override
  void initState() {
    super.initState();

    final initial = _savedTime ?? widget.date ?? DateTime.now();

    year = FixedExtentScrollController(initialItem: initial.year - 2010);
    month = FixedExtentScrollController(initialItem: initial.month - 1);
    day = FixedExtentScrollController(initialItem: initial.day - 1);

    hour = FixedExtentScrollController(initialItem: initial.hour);
    minute = FixedExtentScrollController(initialItem: initial.minute);
    second = FixedExtentScrollController(initialItem: initial.second);

    _animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    [year, month, day, hour, minute, second]
        .forEach((element) => element.dispose());
    _animation.dispose();
    super.dispose();
  }

  Widget _selector(
    FixedExtentScrollController controller,
    int min,
    int max,
    TextStyle style,
  ) {
    return Opacity(
      opacity: _isLocked ? kDisableOpacity : 1,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: GsColors.mainColor2,
          borderRadius: kMainRadius,
        ),
        child: ListWheelScrollView.useDelegate(
          childDelegate: ListWheelChildLoopingListDelegate(
            children: List.generate(
              max - min,
              (index) => Center(
                child: Text(
                  (min + index).toString().padLeft(2, '0'),
                  style: style,
                ),
              ),
            ),
          ),
          controller: controller,
          scrollBehavior: ScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse},
            scrollbars: false,
          ),
          itemExtent: 44,
          physics: _isLocked
              ? const NeverScrollableScrollPhysics()
              : const FixedExtentScrollPhysics(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.subtitle2!.copyWith(color: Colors.white);

    return Center(
      child: CardDialog(
        title: Lang.of(context).getValue(Labels.selectDate),
        constraints: BoxConstraints(maxHeight: 190, maxWidth: 280),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 56,
                  child: Text('Date: ', style: style),
                ),
                _selector(year, 2010, 2031, style),
                SizedBox(
                  width: 20,
                  child: Center(child: Text(' - ', style: style)),
                ),
                _selector(month, 1, 13, style),
                SizedBox(
                  width: 20,
                  child: Center(child: Text(' - ', style: style)),
                ),
                _selector(day, 1, 32, style),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 56,
                  child: Text('Hour: ', style: style),
                ),
                _selector(hour, 0, 24, style),
                SizedBox(
                  width: 20,
                  child: Center(child: Text(' : ', style: style)),
                ),
                _selector(minute, 0, 60, style),
                SizedBox(
                  width: 20,
                  child: Center(child: Text(' : ', style: style)),
                ),
                _selector(second, 0, 60, style),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    final date = _getDate();
                    Navigator.of(context).maybePop(date);
                  },
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: GsColors.mainColor3),
                      borderRadius: kMainRadius,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      Lang.of(context).getValue(Labels.ok),
                      style: style,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 30,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints.tightFor(),
                        onPressed: () => setState(() {
                          _savedTime = _isLocked ? null : _getDate();
                        }),
                        iconSize: 24,
                        color: Colors.white.withOpacity(0.5),
                        icon: Icon(
                          _isLocked ? Icons.lock_outline : Icons.lock_open,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DateTime _getDate() {
    int getValue(FixedExtentScrollController ctrl, int min, int max) =>
        (ctrl.selectedItem % (max - min)) + min;

    return DateTime(
      getValue(year, 2010, 2031),
      getValue(month, 1, 13),
      getValue(day, 1, 32),
      getValue(hour, 0, 24),
      getValue(minute, 0, 60),
      getValue(second, 0, 60),
    );
  }
}
