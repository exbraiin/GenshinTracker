import 'package:flutter/material.dart';
import 'package:tracker/common/cards/gs_info_container.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/domain/gs_database.excel.dart';
import 'package:tracker/screens/tests_screen/tests_list_items.dart';

class TestsScreen extends StatelessWidget {
  static const id = 'tests_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GsAppBar(label: 'Tests'),
      body: ListView(
        padding: EdgeInsets.all(kSeparator4),
        children: [
          TestWidgets.getBannerListItem(context),
          TestWidgets.getCharacterListItem(context),
          TestWidgets.getMaterialGroups(context),
          GsInfoContainer(
            title: 'Data export',
            children: [
              Row(
                children: [
                  ItemCardButton(
                    width: 100,
                    height: 80,
                    label: 'JSON → XLSX',
                    child: Icon(Icons.import_export, color: Colors.white),
                    onTap: () => GsDatabaseExcel.jsonToXlsx(),
                  ),
                  SizedBox(width: kSeparator4),
                  ItemCardButton(
                    width: 100,
                    height: 80,
                    label: 'XLSX → JSON',
                    child: Icon(Icons.import_export, color: Colors.white),
                    onTap: () => GsDatabaseExcel.xlsxToJson(),
                  ),
                ],
              ),
            ],
          ),
        ].separate(SizedBox(height: kSeparator4)).toList(),
      ),
    );
  }
}
