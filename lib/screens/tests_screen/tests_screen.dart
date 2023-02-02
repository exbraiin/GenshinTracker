import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/screens/tests_screen/tests_list_items.dart';

class TestsScreen extends StatelessWidget {
  static const id = 'tests_screen';

  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GsAppBar(label: 'Tests'),
      body: ListView(
        padding: const EdgeInsets.all(kSeparator4),
        children: [
          TestWidgets.getBannerListItem(context),
          TestWidgets.getCharacterListItem(context),
          TestWidgets.getMaterialGroups(context),
          TestWidgets.getBannerFeature(context),
          TestWidgets.getMissingVersions(context),
          TestWidgets.getMissinIngredients(context),
          TestWidgets.getMissingSpecialDish(context),
        ]
            .where((e) => e is! SizedBox)
            .separate(const SizedBox(height: kSeparator4))
            .toList(),
      ),
    );
  }
}
