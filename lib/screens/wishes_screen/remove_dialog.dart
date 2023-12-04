import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';

class RemoveDialog extends StatelessWidget {
  static Future<bool> show(BuildContext context, String name) async {
    return await showDialog(
          context: context,
          builder: (context) => RemoveDialog._(name),
        ) ??
        false;
  }

  final String name;

  const RemoveDialog._(this.name);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: context.themeColors.mainColor0,
          boxShadow: kMainShadow,
          borderRadius: kGridRadius,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.fromLabel(Labels.youSure),
              style: context.textTheme.headlineSmall!
                  .copyWith(color: Colors.white),
            ),
            Divider(color: context.themeColors.almostWhite),
            Text(
              Lang.of(context)
                  .getValue(Labels.removeWish, nargs: {'name': name}),
              textAlign: TextAlign.center,
              style:
                  context.textTheme.titleMedium!.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(true),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: kGridRadius,
                ),
                child: Text(
                  context.fromLabel(Labels.remove).toUpperCase(),
                  style: context.textTheme.titleSmall!
                      .copyWith(color: Colors.red, letterSpacing: -1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
