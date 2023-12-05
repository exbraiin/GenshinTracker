import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class GsTimeDialog extends StatefulWidget {
  final DateTime? date;

  const GsTimeDialog._(this.date);

  static Future<DateTime?> show(BuildContext context, [DateTime? date]) {
    return showDialog<DateTime?>(
      context: context,
      builder: (_) => GsTimeDialog._(date),
    );
  }

  @override
  State<GsTimeDialog> createState() => _GsTimeDialogState();
}

class _GsTimeDialogState extends State<GsTimeDialog>
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
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    final controllers = [year, month, day, hour, minute, second];
    for (var element in controllers) {
      element.dispose();
    }
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.titleSmall!.copyWith(color: Colors.white);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: kListPadding,
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
          decoration: BoxDecoration(
            color: context.themeColors.mainColor0,
            borderRadius: kGridRadius,
          ),
          child: Column(
            children: [
              InventoryBox(
                child: Center(
                  child: Text(
                    context.fromLabel(Labels.selectDate),
                    style: context.themeStyles.title18n,
                  ),
                ),
              ),
              const SizedBox(height: kGridSeparator),
              Expanded(
                child: InventoryBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: kSeparator4),
                            constraints: const BoxConstraints(minWidth: 56),
                            child: Text(
                              context.fromLabel(Labels.dateDialogDate),
                              style: style,
                            ),
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
                      const SizedBox(height: kGridSeparator),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: kSeparator4),
                            constraints: const BoxConstraints(minWidth: 56),
                            child: Text(
                              context.fromLabel(Labels.dateDialogHour),
                              style: style,
                            ),
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
                      const SizedBox(height: kGridSeparator * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              final date = _getDate();
                              Navigator.of(context).maybePop(date);
                            },
                            child: Container(
                              width: 100,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: kGridRadius,
                                color: context.themeColors.mainColor0,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                context.fromLabel(Labels.ok),
                                style: style,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 30,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints.tightFor(),
                                onPressed: () => setState(() {
                                  _savedTime = _isLocked ? null : _getDate();
                                }),
                                iconSize: 24,
                                color: Colors.white.withOpacity(0.5),
                                icon: Icon(
                                  _isLocked
                                      ? Icons.lock_outline
                                      : Icons.lock_open,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          color: context.themeColors.mainColor0,
          borderRadius: kGridRadius,
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: kGridRadius,
          gradient: LinearGradient(
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.2),
            ],
            stops: const [0, 0.2, 0.8, 1],
          ),
        ),
        child: ListWheelScrollView.useDelegate(
          childDelegate: ListWheelChildLoopingListDelegate(
            children: List.generate(
              max - min,
              (index) => Center(
                child: Text(
                  (min + index).toString().padLeft(2, '0'),
                  style: style,
                  strutStyle: style.toStrut(),
                ),
              ),
            ),
          ),
          controller: controller,
          scrollBehavior: const ScrollBehavior().copyWith(
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
