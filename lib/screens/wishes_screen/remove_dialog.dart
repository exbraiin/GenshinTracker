import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/widgets/button.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

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
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: kListPadding,
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
          decoration: BoxDecoration(
            color: context.themeColors.mainColor0,
            borderRadius: kGridRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InventoryBox(
                child: Center(
                  child: Text(
                    context.labels.youSure(),
                    style: context.themeStyles.title18n,
                  ),
                ),
              ),
              const SizedBox(height: kGridSeparator),
              InventoryBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.labels.removeWish(name),
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: kGridSeparator * 2),
                    MainButton(
                      color: context.themeColors.setIndoor,
                      label: context.labels.remove().toUpperCase(),
                      onPress: () => Navigator.of(context).maybePop(true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
