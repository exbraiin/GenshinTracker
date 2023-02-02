import 'dart:async';

import 'package:flutter/material.dart';

class GsIncrementer extends StatefulWidget {
  final Widget? child;
  final void Function()? onTap;
  final void Function(int ticks)? onHold;

  const GsIncrementer({super.key, this.onTap, this.onHold, this.child});

  @override
  State<GsIncrementer> createState() => _GsIncrementerState();
}

class _GsIncrementerState extends State<GsIncrementer> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap?.call(),
      onLongPressStart: (e) => _timer = Timer.periodic(
        const Duration(milliseconds: 100),
        (e) => widget.onHold?.call(e.tick),
      ),
      onLongPressEnd: (e) => _timer?.cancel(),
      child: widget.child,
    );
  }
}
