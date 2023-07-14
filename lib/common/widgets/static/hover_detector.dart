import 'package:flutter/material.dart';

class HoverDetector extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final Decoration Function({bool hover}) decoration;

  const HoverDetector({
    super.key,
    this.child,
    this.onTap,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return child ?? const SizedBox();
    var isHover = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          foregroundDecoration: decoration(hover: isHover),
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
