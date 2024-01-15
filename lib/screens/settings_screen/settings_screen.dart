import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class SettingsScreen extends StatelessWidget {
  static const id = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryPage(
      appBar: InventoryAppBar(label: context.fromLabel(Labels.settings)),
      child: const InventoryBox(width: double.infinity, child: SizedBox()),
    );
  }
}
