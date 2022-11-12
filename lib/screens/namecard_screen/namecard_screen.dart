import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class NamecardScreen extends StatelessWidget {
  static const id = 'namecards_screen';

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final items = GsDatabase.instance.infoNamecards.getItems();
        final groups = items.groupBy((e) => e.type);

        return Scaffold(
          appBar: GsAppBar(
            label: context.fromLabel(Labels.namecards),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(kSeparator4),
            child: Column(
              children: groups.entries
                  .map((e) => _getSection(context, e.key, e.value))
                  .separate(SizedBox(height: kSeparator4))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _getSection(
    BuildContext context,
    String title,
    List<InfoNamecard> namecards,
  ) {
    final titleStyle = context.textTheme.infoLabel;
    final style = context.textTheme.description2;
    return GsDataBox.info(
      title: title,
      child: Table(
        columnWidths: {
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: GsColors.almostWhite),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
              children: [
            Center(child: Text('Image', style: titleStyle)),
            Center(child: Text('Name', style: titleStyle)),
            Center(child: Text('Description', style: titleStyle)),
            Center(child: Text('Obtain', style: titleStyle)),
          ]
                  .map((e) => Padding(
                        padding: EdgeInsets.all(kSeparator4),
                        child: e,
                      ))
                  .toList()),
          ...namecards.map(
            (e) => TableRow(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CachedImageWidget(e.image),
                ),
                Text(e.name, textAlign: TextAlign.center, style: style),
                Text(e.desc, textAlign: TextAlign.center, style: style),
                Text(e.obtain, textAlign: TextAlign.center, style: style),
              ]
                  .map((e) => Padding(
                        padding: EdgeInsets.all(kSeparator8),
                        child: e,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
