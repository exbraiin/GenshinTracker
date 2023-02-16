import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';

class GsDataBox extends StatelessWidget {
  final String? title;
  final Decoration? decoration;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final Iterable<Widget> children;
  final CrossAxisAlignment alignment;

  GsDataBox.summary({
    super.key,
    this.title,
    this.child,
    this.children = const [],
  })  : alignment = CrossAxisAlignment.center,
        padding = const EdgeInsets.all(kSeparator8),
        decoration = BoxDecoration(
          color: GsColors.mainColor2,
          borderRadius: kMainRadius,
          boxShadow: kMainShadow,
          border: Border.all(
            color: GsColors.mainColor3.withOpacity(0.4),
            width: 2,
          ),
        );

  GsDataBox.label(
    String label, {
    super.key,
  })  : title = null,
        child = Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        children = const [],
        alignment = CrossAxisAlignment.start,
        padding = const EdgeInsets.symmetric(
          horizontal: kSeparator4,
          vertical: kSeparator2,
        ),
        decoration = BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(kSeparator8),
          border: Border.all(
            color: Colors.black.withOpacity(0.4),
            width: 1,
          ),
        );

  GsDataBox.info({
    super.key,
    this.title,
    this.child,
    this.children = const [],
  })  : alignment = CrossAxisAlignment.start,
        padding = const EdgeInsets.all(kSeparator8),
        decoration = BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(kSeparator8),
          border: Border.all(
            color: Colors.black.withOpacity(0.4),
            width: 2,
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: alignment,
        children: [
          if (title != null) ..._buildTitle(context),
          if (child != null) child!,
          ...children,
        ],
      ),
    );
  }

  Iterable<Widget> _buildTitle(
    BuildContext context,
  ) sync* {
    yield Text(
      title!,
      style: context.textTheme.bigTitle3.copyWith(
        fontSize: 18,
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.bold,
      ),
    );
    yield const Divider(color: GsColors.almostWhite, thickness: 0.5);
  }
}
