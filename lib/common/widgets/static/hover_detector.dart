import 'package:flutter/material.dart';

class HoverDetector extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final Decoration Function(bool) decoration;

  HoverDetector({
    this.child,
    this.onTap,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return child ?? SizedBox();
    var isHover = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          foregroundDecoration: decoration(isHover),
          child: InkWell(
            onTap: onTap,
            onHover: (h) => setState(() => isHover = h),
            child: child,
          ),
        );
      },
    );
  }
}
