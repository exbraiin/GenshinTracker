import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/theme/theme.dart';

abstract class GsDatabaseExporter {
  static Future<void> export() async {
    final excel = Excel.createExcel();

    writeWishes(excel, 'Character Event', GsBanner.character);
    writeWishes(excel, 'Weapon Event', GsBanner.weapon);
    writeWishes(excel, 'Standard', GsBanner.standard);
    writeWishes(excel, 'Beginners\' Wish', GsBanner.beginner);

    writeBanners(excel, 'Banner List');

    writePaimonMoeInformation(excel, 'Information');

    excel.delete('Sheet1');
    final bytes = excel.encode()!;
    final date = DateTime.now().format().replaceAll(':', '-');
    await Directory('export').create();
    await File('export/$date.xlsx').writeAsBytes(bytes);
    if (Platform.isWindows) await Process.run('explorer', ['.']);
    if (kDebugMode) print('\x1b[31mComplete!');
  }

  static void writeWishes(Excel excel, String sheetName, GsBanner bannerType) {
    final db = GsDatabase.instance;
    final list = GsUtils.wishes.getSaveWishesByBannerType(bannerType);
    final sheet = excel[sheetName];

    final rows = <_Row>[];
    final wishes = list.sortedDescending();

    for (var i = 0; i < wishes.length; ++i) {
      final wish = wishes[i];
      final item = GsUtils.items.getItemData(wish.itemId);
      final banner = db.infoBanners.getItem(wish.bannerId);

      final row = _Row(
        type: item.type.name.capitalize(),
        name: item.name,
        date: wish.date.format(),
        rarity: item.rarity,
        pity: wish.pity,
        roll: wish.number,
        banner: banner.name,
      );
      rows.add(row);
    }

    sheet.appendRow([
      'Type',
      'Name',
      'Time',
      '⭐',
      'Pity',
      '#Roll',
      'Group',
      'Banner',
    ]);
    sheet.applyStyleToRow(
      sheet.maxRows - 1,
      CellStyle(
        bold: true,
        fontSize: 10,
        fontFamily: defaultFontFamily,
        verticalAlign: VerticalAlign.Center,
        horizontalAlign: HorizontalAlign.Center,
      ),
    );

    final st = CellStyle(
      fontSize: 10,
      fontFamily: defaultFontFamily,
      verticalAlign: VerticalAlign.Center,
    );

    var group = 0;
    var bg = false;
    final reversed = rows.reversed.toList();
    for (var i = 0; i < reversed.length; ++i) {
      final last = i > 0 ? reversed[i - 1] : null;
      final item = reversed[i];
      if (last == null || last.banner != item.banner) group = 0;
      if (last == null || last.date != item.date) {
        group++;
        bg = !bg;
      }
      final s = st.copyWith(
        fontColorHexVal: item.rarity == 5
            ? 'FFCC9832'
            : item.rarity == 4
                ? 'FF8A6995'
                : 'FF000000',
        boldVal: item.rarity > 3,
        backgroundColorHexVal: bg ? 'FFEEEEEE' : 'none',
      );
      item.addToSheet(sheet, group, s);
    }
  }

  static void writeBanners(Excel excel, String sheetName) {
    final db = GsDatabase.instance;
    final list = db.infoBanners
        .getItems()
        .sortedBy((e) => _bannerType(e.type))
        .thenBy((e) => e.dateStart);
    final sheet = excel[sheetName];
    sheet.appendRow(['Name', 'Start', 'End']);
    for (var banner in list) {
      sheet.appendRow([
        banner.name,
        banner.dateStart.format(showHour: false),
        banner.dateEnd.format(showHour: false),
      ]);
    }
  }

  static void writePaimonMoeInformation(Excel excel, String sheetName) {
    final sheet = excel[sheetName];

    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('B1'));
    sheet.appendRow(['Paimon.moe Wish History Export']);
    sheet.appendRow(['Version', 3]);
    sheet.appendRow(['Export Date', DateTime.now().format()]);
  }
}

class _Row {
  final String type;
  final String name;
  final String date;
  final int rarity;
  final int pity;
  final int roll;
  final String banner;

  _Row({
    required this.type,
    required this.name,
    required this.date,
    required this.rarity,
    required this.pity,
    required this.roll,
    required this.banner,
  });

  void addToSheet(Sheet sheet, int group, CellStyle style) {
    final rows = sheet.maxRows;
    final data = [type, name, date, rarity, pity, roll, group, banner];
    final cStyle = style.copyWith(horizontalAlignVal: HorizontalAlign.Center);
    for (var i = 0; i < data.length; ++i) {
      final idx = CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rows);
      final stl = data[i] is int ? cStyle : style;
      sheet.updateCell(idx, data[i], cellStyle: stl);
    }
  }
}

int _bannerType(GsBanner banner) {
  return [
    GsBanner.beginner,
    GsBanner.standard,
    GsBanner.character,
    GsBanner.weapon,
  ].indexOf(banner);
}

extension on Sheet {
  void applyStyleToRow(int index, CellStyle style) {
    final row = this.row(index);
    row.forEachIndexed(
      (_, i) =>
          cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: index))
              .cellStyle = style,
    );
  }
}
