import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/theme/theme.dart';

class GsButton extends StatelessWidget {
  final Color? color;
  final Widget child;
  final EdgeInsets padding;
  final BoxBorder? border;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;

  const GsButton({
    super.key,
    required this.child,
    this.color,
    this.border,
    this.onPressed,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(
      vertical: kSeparator4,
      horizontal: kSeparator8,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? context.themeColors.dimWhite,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.white.withOpacity(0.6),
        hoverColor: Colors.white.withOpacity(0.2),
        borderRadius: borderRadius,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}
