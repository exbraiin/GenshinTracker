import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/enums/enum_ext.dart';

class AscensionStatus extends StatelessWidget {
  final Map<String, String> Function(BuildContext context) _data;

  AscensionStatus.character(GsCharacter item, {super.key})
      : _data = ((context) => _getCharData(context, item));

  @override
  Widget build(BuildContext context) {
    final data = _data(context);
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
      },
      border: TableBorder(
        horizontalInside: BorderSide(
          color: context.themeColors.divider,
          width: 0.4,
        ),
      ),
      children: data.entries.map((entry) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 16, 4),
              child: Text(entry.key),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
              child: Text(
                entry.value,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  static Map<String, String> _getCharData(
    BuildContext context,
    GsCharacter item,
  ) {
    return {
      context.labels.wsHp(): item.ascHpValue.toString(),
      context.labels.wsAtk(): item.ascAtkValue.toString(),
      context.labels.wsDef(): item.ascDefValue.toString(),
      item.ascStatType.label(context):
          item.ascStatType.toIntOrPercentage(item.ascStatValue),
    };
  }
}
