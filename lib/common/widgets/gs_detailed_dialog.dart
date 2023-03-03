import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';

mixin GsDetailedDialogMixin on Widget {
  Future<void> show(BuildContext context) => showDialog(
        context: context,
        builder: (context) => GsDetailedDialog(card: this),
      );
}

/// A detailed item dialog.
class GsDetailedDialog extends StatelessWidget {
  final double cardWidth;
  final Widget? card;

  const GsDetailedDialog({
    super.key,
    required this.card,
    this.cardWidth = 500,
  });

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width / 20;
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(pad),
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(boxShadow: kMainShadow),
          width: cardWidth,
          child: Material(
            color: Colors.transparent,
            child: card,
          ),
        ),
      ),
    );
  }
}
