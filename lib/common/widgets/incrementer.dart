import 'dart:async';

import 'package:flutter/material.dart';

class Incrementer extends StatefulWidget {
  final Widget? child;
  final void Function()? onTap;
  final void Function(int ticks)? onHold;

  Incrementer({this.onTap, this.onHold, this.child});

  @override
  State<Incrementer> createState() => _IncrementerState();
}

class _IncrementerState extends State<Incrementer> {
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
        Duration(milliseconds: 100),
        (e) => widget.onHold?.call(e.tick),
      ),
      onLongPressEnd: (e) => _timer?.cancel(),
      child: widget.child,
    );
  }
}
