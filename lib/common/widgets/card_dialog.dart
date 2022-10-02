import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';

class CardDialog extends StatelessWidget {
  final String title;
  final Widget? child;
  final BoxConstraints constraints;

  CardDialog({
    required this.title,
    this.child,
    this.constraints = const BoxConstraints.tightFor(width: 350),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      decoration: BoxDecoration(
        color: GsColors.mainColor0,
        boxShadow: mainShadow,
        borderRadius: kMainRadius,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4),
          Text(
            title.toUpperCase(),
            style: context.textTheme.cardDialogTitle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          if (child != null) child!,
        ],
      ),
    );
  }
}
