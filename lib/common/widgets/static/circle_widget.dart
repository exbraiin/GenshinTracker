import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  final Color color;
  final double? size;
  final Widget? child;
  final Color? borderColor;
  final double? borderSize;

  const CircleWidget({
    super.key,
    this.size,
    this.color = Colors.white,
    this.child,
    this.borderSize,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? double.infinity,
      height: size ?? double.infinity,
      child: CustomPaint(
        painter: _Painter(this),
        child: child,
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final CircleWidget circle;

  _Painter(this.circle);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width.clamp(0, size.height) / 2;

    if (circle.borderSize != null && circle.borderColor != null) {
      canvas.drawCircle(
        size.center(Offset.zero),
        radius,
        Paint()..color = circle.borderColor!,
      );
      canvas.drawCircle(
        size.center(Offset.zero),
        radius - (circle.borderSize ?? 0),
        Paint()..color = circle.color,
      );
    } else {
      canvas.drawCircle(
        size.center(Offset.zero),
        radius,
        Paint()..color = circle.color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
