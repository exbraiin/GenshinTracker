import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';

class GsDataBox extends StatelessWidget {
  final Widget? title;
  final Decoration Function(BuildContext ctx)? decoration;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final Iterable<Widget> children;
  final CrossAxisAlignment alignment;

  GsDataBox.info_({
    super.key,
    this.title,
    this.child,
    Color? bgColor,
    this.children = const [],
  })  : alignment = CrossAxisAlignment.start,
        padding = const EdgeInsets.all(kSeparator8),
        decoration = ((context) {
          final color = bgColor ?? context.themeColors.mainColor0;
          return BoxDecoration(
            color: color.withOpacity(0.5),
            borderRadius: BorderRadius.circular(kSeparator8),
            border: Border.all(
              color: color.withOpacity(0.8),
              width: 2,
            ),
          );
        });

  GsDataBox.info({
    super.key,
    this.title,
    this.child,
    Color? bgColor,
    this.children = const [],
  })  : alignment = CrossAxisAlignment.start,
        padding = const EdgeInsets.all(kSeparator8),
        decoration = ((ctx) {
          final color = bgColor?.withOpacity(0.5) ??
              ctx.themeColors.mainColor1.withOpacity(0.6);
          return BoxDecoration(
            color: color,
            borderRadius: kMainRadius,
            boxShadow: [
              if (color.opacity > 0.55)
                BoxShadow(
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                  color: Colors.black.withOpacity(0.6),
                ),
            ],
          );
        });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: decoration?.call(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: alignment,
        children: [
          ..._buildTitle(context),
          if (child != null) child!,
          ...children,
        ],
      ),
    );
  }

  Iterable<Widget> _buildTitle(
    BuildContext context,
  ) sync* {
    final title = this.title;
    if (title == null) return;
    yield DefaultTextStyle(
      style: context.textTheme.bigTitle3.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      child: title,
    );
    yield Divider(color: context.themeColors.almostWhite, thickness: 0.5);
  }
}
