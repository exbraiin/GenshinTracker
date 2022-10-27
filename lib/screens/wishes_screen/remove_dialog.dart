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

  RemoveDialog._(this.name);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: GsColors.mainColor0,
          boxShadow: kMainShadow,
          borderRadius: kMainRadius,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Lang.of(context).getValue(Labels.youSure),
              style: context.textTheme.headline5!.copyWith(color: Colors.white),
            ),
            Divider(color: GsColors.almostWhite),
            Text(
              Lang.of(context)
                  .getValue(Labels.removeWish, nargs: {'name': name}),
              textAlign: TextAlign.center,
              style: context.textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(true),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: kMainRadius,
                ),
                child: Text(
                  Lang.of(context).getValue(Labels.remove).toUpperCase(),
                  style: context.textTheme.subtitle2!
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
