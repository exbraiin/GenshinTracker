import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/theme/theme.dart';

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
        borderRadius: kMainRadius,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text(
            title.toUpperCase(),
            style: context.textTheme.cardDialogTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (child != null) child!,
        ],
      ),
    );
  }
}
