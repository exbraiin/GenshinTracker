import 'package:flutter/material.dart';

class SwapWidgets extends StatefulWidget {
  final Widget child0;
  final Widget child1;

  const SwapWidgets({
    super.key,
    required this.child0,
    required this.child1,
  });

  @override
  State<SwapWidgets> createState() => _SwapWidgetsState();
}

class _SwapWidgetsState extends State<SwapWidgets>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    animation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1), weight: 1),
      TweenSequenceItem(
        tween: CurveTween(curve: Curves.easeOut)
            .chain(Tween(begin: 1.0, end: 0.0)),
        weight: 1,
      ),
      TweenSequenceItem(tween: ConstantTween(0), weight: 1),
      TweenSequenceItem(
        tween: CurveTween(curve: Curves.easeOut)
            .chain(Tween(begin: 0.0, end: 1.0)),
        weight: 1,
      ),
    ]).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: animation.value,
                child: widget.child0,
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 1 - animation.value,
                child: widget.child1,
              ),
            ),
          ],
        );
      },
    );
  }
}
