import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/widgets/button.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

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
                    title,
                    style: context.themeStyles.title18n,
                    strutStyle: context.themeStyles.title18n.toStrut(),
                  ),
                ),
              ),
              const SizedBox(height: kGridSeparator),
              InventoryBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      subtitle,
                      style: style,
                      strutStyle: style.toStrut(),
                    ),
                    const SizedBox(height: kGridSeparator * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MainButton(
                          color: context.themeColors.setIndoor,
                          label: context.labels.buttonNo(),
                          onPress: () => Navigator.of(context).maybePop(false),
                        ),
                        const SizedBox(width: kGridSeparator),
                        MainButton(
                          color: context.themeColors.goodValue,
                          label: context.labels.buttonYes(),
                          onPress: () => Navigator.of(context).maybePop(true),
                        ),
                      ],
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
