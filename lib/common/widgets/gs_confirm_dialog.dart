import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_card_dialog.dart';

class GsConfirmDialog extends StatelessWidget {
  static Future<bool?> show(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return showDialog<bool?>(
      context: context,
      builder: (_) => GsConfirmDialog._(title, subtitle),
    );
  }

  final String title;
  final String subtitle;

  const GsConfirmDialog._(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.titleSmall!.copyWith(color: Colors.white);
    return Center(
      child: GsCardDialog(
        title: title,
        child: Column(
          children: [
            Text(
              subtitle,
              style: style,
            ),
            const SizedBox(height: kSeparator8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(false),
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.themeColors.dimWhite),
                      borderRadius: kMainRadius,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      context.fromLabel(Labels.buttonNo),
                      style: style,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(true),
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.themeColors.dimWhite),
                      borderRadius: kMainRadius,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      context.fromLabel(Labels.buttonYes),
                      style: style,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
