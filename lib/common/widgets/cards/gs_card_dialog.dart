import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';

class GsCardDialog extends StatelessWidget {
  final String title;
  final Widget? child;
  final BoxConstraints constraints;

  const GsCardDialog({
    super.key,
    required this.title,
    this.child,
    this.constraints = const BoxConstraints.tightFor(width: 350),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      decoration: BoxDecoration(
        color: context.themeColors.mainColor0,
        boxShadow: kMainShadow,
        borderRadius: kGridRadius,
      ),
      padding: kListPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text(
            title.toUpperCase(),
            style: context.themeStyles.title20n,
            textAlign: TextAlign.center,
            strutStyle: context.themeStyles.title20n.toStrut(),
          ),
          const SizedBox(height: 16),
          if (child != null) child!,
        ],
      ),
    );
  }
}
