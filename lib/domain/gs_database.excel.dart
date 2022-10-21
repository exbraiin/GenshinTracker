import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_colors.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GsDatabaseExcel {
  GsDatabaseExcel._();

  static Future<void> jsonToXlsx() async {
    final excel = Excel.createExcel()..sheets.clear();

    _writeJsonData<InfoArtifact>(
      excel,
      GsDatabase.instance.infoArtifacts.name,
      GsDatabase.instance.infoArtifacts
          .getItems()
          .sortedBy((element) => element.rarity)
          .thenBy((element) => element.id),
      [
        'id',
        'name',
        'domain',
        'desc1Pc',
        'desc2Pc',
        'desc4Pc',
        'rarity',
      ],
      (item) => [
        item.id,
        item.name,
        item.domain,
        item.desc1Pc,
        item.desc2Pc,
        item.desc4Pc,
        item.rarity,
      ],
      (item) => GsColors.getRarityColor(item.rarity),
    );
    _writeJsonData<MapEntry<InfoArtifact, InfoArtifactPiece>>(
      excel,
      'artifact_pieces',
      GsDatabase.instance.infoArtifacts
          .getItems()
          .sortedBy((element) => element.rarity)
          .thenBy((element) => element.id)
          .expand((element) {
        return List.generate(
          element.pieces.length,
          (index) => MapEntry(element, element.pieces[index]),
        );
      }).toList(),
      [
        'artifact_id',
        'type',
        'name',
        'icon',
        'desc',
      ],
      (item) => [
        item.key.id,
        GsArtifactPieces.values.toId(item.value.type),
        item.value.name,
        item.value.icon,
        item.value.desc,
      ],
      (item) => GsColors.getRarityColor(item.key.rarity),
    );

    _writeJsonData<InfoBanner>(
      excel,
      GsDatabase.instance.infoBanners.name,
      GsDatabase.instance.infoBanners
          .getItems()
          .sortedBy((element) => element.type.index)
          .thenBy((element) => element.dateStart)
          .thenBy((element) => element.id),
      [
        'id',
        'name',
        'image',
        'date_start',
        'date_end',
        'feature_4',
        'feature_5',
        'type',
      ],
      (item) => [
        item.id,
        item.name,
        item.image,
        item.dateStart.toString().split(' ').first,
        item.dateEnd.toString().split(' ').first,
        item.feature4.join(','),
        item.feature5.join(','),
        item.type.name,
      ],
    );

    _writeJsonData<InfoCharacter>(
      excel,
      GsDatabase.instance.infoCharacters.name,
      GsDatabase.instance.infoCharacters
          .getItems()
          .sortedBy((element) => element.rarity)
          .thenBy((element) => element.id),
      [
        'id',
        'name',
        'title',
        'version',
        'constellation',
        'affiliation',
        'special_dish',
        'description',
        'image',
        'full_image',
        'birthday',
        'release_date',
        'rarity',
        'region',
        'weapon',
        'element',
        'talents',
        'ascension',
        'constellations',
      ],
      (item) => [
        item.id,
        item.name,
        item.title,
        item.version,
        item.constellation,
        item.affiliation,
        item.specialDish,
        item.description,
        item.image,
        item.fullImage,
        item.birthday.toString().split(' ').first,
        item.releaseDate.toString().split(' ').first,
        item.rarity,
        item.region.name,
        item.weapon.name,
        item.element.name,
        'TODO', // item.talents,
        'TODO', // item.ascension,
        'TODO', // item.constellations,
      ],
      (item) => GsColors.getRarityColor(item.rarity),
    );
    _writeJsonData<MapEntry<InfoCharacter, InfoCharacterTalent>>(
      excel,
      'char_talents',
      GsDatabase.instance.infoCharacters
          .getItems()
          .sortedBy((element) => element.rarity)
          .thenBy((element) => element.id)
          .expand(
            (e) => List.generate(
              e.talents.length,
              (index) => MapEntry(e, e.talents[index]),
            ),
          )
          .toList(),
      [
        'char_id',
        'name',
        'type',
        'icon',
        'desc',
      ],
      (item) => [
        item.key.id,
        item.value.name,
        item.value.type,
        item.value.icon,
        item.value.desc,
      ],
      (item) => GsColors.getRarityColor(item.key.rarity),
      (item) => item.key.id,
    );
    _writeJsonData<MapEntry<InfoCharacter, InfoCharacterAscension>>(
      excel,
      'char_ascensions',
      GsDatabase.instance.infoCharacters
          .getItems()
          .sortedBy((element) => element.rarity)
          .thenBy((element) => element.id)
          .expand(
            (element) => Iterable.generate(
              element.ascension.length,
              (index) => MapEntry(element, element.ascension[index]),
            ),
          )
          .toList(),
      [
        'char_id',
        'level',
        'materials',
        'values_before',
        'values_after',
      ],
      (item) => [
        item.key.id,
        item.value.level,
        item.value.materials.entries
            .map((e) => '${e.key}:${e.value}')
            .join(','),
        item.value.valuesBefore.entries
            .map((e) => '${e.key.name}:${e.value}')
            .join(','),
        item.value.valuesAfter.entries
            .map((e) => '${e.key.name}:${e.value}')
            .join(','),
      ],
      (item) => GsColors.getRarityColor(item.key.rarity),
      (item) => item.key.id,
    );
    _writeJsonData<MapEntry<InfoCharacter, InfoCharacterConstellation>>(
      excel,
      'char_constellations',
      GsDatabase.instance.infoCharacters
          .getItems()
          .sortedBy((element) => element.rarity)
          .thenBy((element) => element.id)
          .expand(
            (element) => Iterable.generate(
              element.constellations.length,
              (index) => MapEntry(element, element.constellations[index]),
            ),
          )
          .toList(),
      ['char_id', 'name', 'icon', 'desc'],
      (item) => [
        item.key.id,
        item.value.name,
        item.value.icon,
        item.value.desc,
      ],
      (item) => GsColors.getRarityColor(item.key.rarity),
      (item) => item.key.id,
    );

    _writeJsonData<InfoCity>(
      excel,
      GsDatabase.instance.infoCities.name,
      GsDatabase.instance.infoCities
          .getItems()
          .sortedBy((element) => element.element.index)
          .thenBy((element) => element.id),
      [
        'id',
        'name',
        'image',
        'element',
        'reputation',
      ],
      (item) => [
        item.id,
        item.name,
        item.image,
        item.element.name,
        item.reputation.join(','),
      ],
      (item) => item.element.getColor(),
    );

    _writeJsonData<InfoWeapon>(
      excel,
      GsDatabase.instance.infoWeapons.name,
      GsDatabase.instance.infoWeapons
          .getItems()
          .sortedBy((element) => element.rarity)
          .thenBy((element) => element.id),
      [
        'id',
        'atk',
        'name',
        'image',
        'version',
        'type',
        'rarity',
        'stat_type',
        'stat_value',
      ],
      (item) => [
        item.id,
        item.atk,
        item.name,
        item.image,
        item.version,
        item.type.name,
        item.rarity,
        item.statType.name,
        item.statValue,
      ],
      (item) => GsColors.getRarityColor(item.rarity),
    );

    _writeJsonData<InfoRecipe>(
      excel,
      GsDatabase.instance.infoRecipes.name,
      GsDatabase.instance.infoRecipes
          .getItems()
          .sortedBy((element) => element.rarity)
          .thenBy((element) => element.id),
      ['id', 'name', 'image', 'rarity', 'version', 'effect'],
      (item) => [
        item.id,
        item.name,
        item.image,
        item.rarity,
        item.version,
        item.effect.name,
      ],
      (item) => GsColors.getRarityColor(item.rarity),
    );

    _writeJsonData<InfoSereniteaSet>(
      excel,
      GsDatabase.instance.infoSereniteaSets.name,
      GsDatabase.instance.infoSereniteaSets
          .getItems()
          .sortedBy((element) => element.category.index)
          .thenBy((element) => element.id),
      ['id', 'name', 'image', 'version', 'energy', 'category', 'chars'],
      (item) => [
        item.id,
        item.name,
        item.image,
        item.version,
        item.energy,
        item.category.name,
        item.chars.join(','),
      ],
      (item) => item.category == GsSetCategory.indoor
          ? Color(0xFFAA0000)
          : Color(0xFF0000AA),
    );

    _writeJsonData<InfoSpincrystal>(
      excel,
      GsDatabase.instance.infoSpincrystal.name,
      GsDatabase.instance.infoSpincrystal
          .getItems()
          .sortedBy((element) => element.number),
      ['id', 'name', 'number', 'source', 'version'],
      (item) => [item.id, item.name, item.number, item.source, item.version],
    );

    _writeJsonData<InfoMaterial>(
      excel,
      GsDatabase.instance.infoMaterials.name,
      GsDatabase.instance.infoMaterials
          .getItems()
          .sortedBy((element) => element.group)
          .thenBy((element) => element.subgroup)
          .thenBy((element) => element.rarity)
          .thenBy((element) => element.name),
      [
        'id',
        'name',
        'rarity',
        'version',
        'image',
        'group',
        'subgroup',
      ],
      (item) => [
        item.id,
        item.name,
        item.rarity,
        item.version,
        item.image,
        item.group,
        item.subgroup,
      ],
      (item) => GsColors.getRarityColor(item.rarity),
      (item) => '${item.group}_${item.subgroup}',
    );

    excel.delete('Sheet1');
    final bytes = excel.encode()!;
    await Directory('export').create();
    await File('export/out.xlsx').writeAsBytes(bytes);
    await launchUrlString('file://${Directory('export').absolute.path}');
    print('\x1b[31mCompleted!');
  }

  static Future<void> xlsxToJson() async {
    final excelBytes = await File('export/out.xlsx').readAsBytes();
    final excel = Excel.decodeBytes(excelBytes);

    final artifactsPieces = excel['artifact_pieces'].rows.skip(1);
    final artifacts = excel['artifacts']
        .rows
        .skip(1)
        .map((element) => element.toArtifact(artifactsPieces
            .where((p) => p[0].asString() == element[0].asString())
            .map((e) => e.toArtifactPiece())
            .toList()))
        .toList();

    final banners = excel['banners']
        .rows
        .skip(1)
        .map((element) => element.toBanner())
        .toList();

    final talent = excel['char_talents'].rows.skip(1);
    final ascension = excel['char_ascensions'].rows.skip(1);
    final constellation = excel['char_constellations'].rows.skip(1);
    final characters = excel['characters']
        .rows
        .skip(1)
        .map((element) => element.toCharacter(
              talent
                  .where((p) => p[0].asString() == element[0].asString())
                  .map((e) => e.toTalent())
                  .toList(),
              ascension
                  .where((p) => p[0].asString() == element[0].asString())
                  .map((e) => e.toAscension())
                  .toList(),
              constellation
                  .where((p) => p[0].asString() == element[0].asString())
                  .map((e) => e.toConstellation())
                  .toList(),
            ))
        .toList();

    final cities = excel['cities']
        .rows
        .skip(1)
        .map((element) => element.toCity())
        .toList();

    final weapons = excel['weapons']
        .rows
        .skip(1)
        .map((element) => element.toWeapon())
        .toList();

    final recipes = excel['recipes']
        .rows
        .skip(1)
        .map((element) => element.toRecipe())
        .toList();

    final sets = excel['serenitea_sets']
        .rows
        .skip(1)
        .map((element) => element.toSereniteaSet())
        .toList();

    final crystals = excel['spincrystals']
        .rows
        .skip(1)
        .map((element) => element.toSpincrystal())
        .toList();

    final materials = excel['materials']
        .rows
        .skip(1)
        .map((element) => element.toMaterial())
        .toList();

    final jsonData = jsonEncode({
      'artifacts': artifacts.toMap((e) => e.id, (e) => e.toMap()),
      'characters': characters.toMap((e) => e.id, (e) => e.toMap()),
      'materials': materials.toMap((e) => e.id, (e) => e.toMap()),
      'recipes': recipes.toMap((e) => e.id, (e) => e.toMap()),
      'cities': cities.toMap((e) => e.id, (e) => e.toMap()),
      'weapons': weapons.toMap((e) => e.id, (e) => e.toMap()),
      'banners': banners.toMap((e) => e.id, (e) => e.toMap()),
      'serenitea_sets': sets.toMap((e) => e.id, (e) => e.toMap()),
      'spincrystals': crystals.toMap((e) => e.id, (e) => e.toMap()),
    });
    await File('export/out.json').writeAsString(jsonData);
    await launchUrlString('file://${Directory('export').absolute.path}');
    print('\x1b[31mCompleted!');
  }

  static void _writeJsonData<T>(
    Excel excel,
    String name,
    List<T> items,
    List<String> header,
    List Function(T item) data, [
    Color Function(T item)? color,
    String Function(T item)? id,
  ]) {
    final sheet = excel[name];
    final style = CellStyle(fontFamily: 'Arial', bold: true);
    sheet.appendRow(header);
    sheet.applyStyleToRow(0, style);
    var lastId = '';
    var lerp = 0.0;
    for (var i = 0; i < items.length; ++i) {
      String col = 'none';
      if (color != null) {
        var temp = color.call(items[i]);
        if (id != null) {
          final itemId = id(items[i]);
          if (lastId != itemId) {
            lastId = itemId;
            lerp = lerp == 0 ? 0.2 : 0;
          }
          temp = Color.lerp(temp, Colors.black, lerp)!;
        }
        col = temp.value.toRadixString(16);
      }
      final style = CellStyle(fontFamily: 'Arial', backgroundColorHex: col);
      sheet.appendRow(data(items[i]));
      sheet.applyStyleToRow(i + 1, style);
    }
  }
}

extension on Sheet {
  void applyStyleToRow(int index, CellStyle style) {
    final row = this.row(index);
    row.forEachIndexed((_, i) => this
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: index))
        .cellStyle = style);
  }
}

extension<T> on Iterable<T> {
  Map<K, V> toMap<K, V>(K Function(T e) key, V Function(T e) value) =>
      Map.fromEntries(this.map((e) => MapEntry(key(e), value(e))));
}

// === OBJ EXTENSIONS

extension on InfoArtifact {
  Map<String, dynamic> toMap() => {
        'name': name,
        'domain': domain,
        if (desc1Pc.isNotEmpty) '1pc': desc1Pc,
        if (desc2Pc.isNotEmpty) '2pc': desc2Pc,
        if (desc4Pc.isNotEmpty) '4pc': desc4Pc,
        'rarity': rarity,
        'pieces': pieces.toMap(
          (e) => GsArtifactPieces.values.toId(e.type),
          (e) => e.toMap(),
        ),
      };
}

extension on InfoArtifactPiece {
  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon,
        'desc': desc,
      };
}

extension on InfoBanner {
  Map<String, dynamic> toMap() => {
        'name': name,
        'image': image,
        'date_start': dateStart.toString().split(' ').first,
        'date_end': dateEnd.toString().split(' ').first,
        'feature_4': feature4,
        'feature_5': feature5,
        'type': type.name,
      };
}

extension on InfoCity {
  Map<String, dynamic> toMap() => {
        'name': name,
        'image': image,
        'element': element.name,
        'reputation': reputation,
      };
}

extension on InfoWeapon {
  Map<String, dynamic> toMap() => {
        'atk': atk,
        'name': name,
        'image': image,
        'version': version,
        'type': type.name,
        'rarity': rarity,
        'stat_type': statType.name,
        'stat_value': statValue,
      };
}

extension on InfoRecipe {
  Map<String, dynamic> toMap() => {
        'name': name,
        'image': image,
        'rarity': rarity,
        'version': version,
        'effect': effect.name,
      };
}

extension on InfoSereniteaSet {
  Map<String, dynamic> toMap() => {
        'name': name,
        'image': image,
        'version': version,
        'energy': energy,
        'category': category.name,
        'chars': chars,
      };
}

extension on InfoSpincrystal {
  Map<String, dynamic> toMap() => {
        'name': name,
        'number': number,
        'source': source,
        'version': version,
      };
}

extension on InfoMaterial {
  Map<String, dynamic> toMap() => {
        'name': name,
        'image': image,
        'version': version,
        'group': group,
        'rarity': rarity,
        'subgroup': subgroup,
      };
}

extension on InfoCharacter {
  Map<String, dynamic> toMap() => {
        'name': name,
        'title': title,
        'version': version,
        'constellation': constellation,
        'affiliation': affiliation,
        'special_dish': specialDish,
        'description': description,
        'image': image,
        'full_image': fullImage,
        'birthday': birthday.toString().split(' ').first,
        'release_date': releaseDate.toString().split(' ').first,
        'rarity': rarity,
        'region': region.name,
        'weapon': weapon.name,
        'element': element.name,
        'talents': talents.map((e) => e.toMap()).toList(),
        'ascension': ascension.map((e) => e.toMap()).toList(),
        'constellations': constellations.map((e) => e.toMap()).toList(),
      };
}

extension on InfoCharacterTalent {
  Map<String, dynamic> toMap() => {
        'name': name,
        'type': type,
        'icon': icon,
        'desc': desc,
      };
}

extension on InfoCharacterAscension {
  Map<String, dynamic> toMap() => {
        'level': level,
        'materials': materials,
        'values_after': valuesAfter.entries.toMap(
          (e) => e.key.name,
          (e) => e.value,
        ),
        'values_before': valuesBefore.entries.toMap(
          (e) => e.key.name,
          (e) => e.value,
        ),
      };
}

extension on InfoCharacterConstellation {
  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon,
        'desc': desc,
      };
}

// === DATA EXTENSIUONS

extension on Data? {
  int asInt() => this?.value as int? ?? 0;
  double asDouble() => this?.value as double? ?? 0;
  String asString() => this?.value as String? ?? '';
  DateTime asDateTime() => DateTime.tryParse(asString()) ?? DateTime(0);
  List<String> asStringList() {
    final str = asString();
    return str.isEmpty ? [] : str.split(',').toList();
  }

  List<T> asList<T>(T Function(String e) map) {
    final str = asString();
    if (str.isEmpty) return [];
    return str.split(',').map(map).toList();
  }

  Map<K, V> asMap<K, V>(K Function(String e) key, V Function(String e) value) {
    final str = asString();
    if (str.isEmpty) return {};
    return str
        .split(',')
        .map((e) => e.split(':'))
        .toMap((e) => key(e.first), (e) => value(e.last));
  }
}

extension on List<Data?> {
  InfoArtifact toArtifact(List<InfoArtifactPiece> pieces) {
    final id = this[0].asString();
    return InfoArtifact(
      id: id,
      name: this[1].asString(),
      domain: this[2].asString(),
      desc1Pc: this[3].asString(),
      desc2Pc: this[4].asString(),
      desc4Pc: this[5].asString(),
      rarity: this[6].asInt(),
      pieces: pieces,
    );
  }

  InfoArtifactPiece toArtifactPiece() {
    return InfoArtifactPiece(
      type: GsArtifactPieces.values.fromId(this[1].asString()),
      name: this[2].asString(),
      icon: this[3].asString(),
      desc: this[4].asString(),
    );
  }

  InfoBanner toBanner() {
    return InfoBanner(
      id: this[0].asString(),
      name: this[1].asString(),
      image: this[2].asString(),
      dateStart: this[3].asDateTime(),
      dateEnd: this[4].asDateTime(),
      feature4: this[5].asStringList(),
      feature5: this[6].asStringList(),
      type: GsBanner.values.fromName(this[7].asString()),
    );
  }

  InfoCity toCity() {
    return InfoCity(
      id: this[0].asString(),
      name: this[1].asString(),
      image: this[2].asString(),
      element: GsElement.values.fromName(this[3].asString()),
      reputation: this[4].asList((e) => int.parse(e)),
    );
  }

  InfoWeapon toWeapon() {
    return InfoWeapon(
      id: this[0].asString(),
      atk: this[1].asInt(),
      name: this[2].asString(),
      image: this[3].asString(),
      version: this[4].asString(),
      type: GsWeapon.values.fromName(this[5].asString()),
      rarity: this[6].asInt(),
      statType: GsAttributeStat.values.fromName(this[7].asString()),
      statValue: this[8].asDouble(),
    );
  }

  InfoRecipe toRecipe() {
    return InfoRecipe(
      id: this[0].asString(),
      name: this[1].asString(),
      image: this[2].asString(),
      rarity: this[3].asInt(),
      version: this[4].asString(),
      effect: GsRecipeBuff.values.fromName(this[5].asString()),
    );
  }

  InfoSereniteaSet toSereniteaSet() {
    return InfoSereniteaSet(
      id: this[0].asString(),
      name: this[1].asString(),
      image: this[2].asString(),
      version: this[3].asString(),
      energy: this[4].asInt(),
      category: GsSetCategory.values.fromName(this[5].asString()),
      chars: this[6].asStringList(),
    );
  }

  InfoSpincrystal toSpincrystal() {
    return InfoSpincrystal(
      id: this[0].asString(),
      name: this[1].asString(),
      number: this[2].asInt(),
      source: this[3].asString(),
      version: this[4].asString(),
    );
  }

  InfoMaterial toMaterial() {
    return InfoMaterial(
      id: this[0].asString(),
      name: this[1].asString(),
      rarity: this[2].asInt(),
      version: this[3].asString(),
      image: this[4].asString(),
      group: this[5].asString(),
      subgroup: this[6].asInt(),
    );
  }

  InfoCharacter toCharacter(
    List<InfoCharacterTalent> talents,
    List<InfoCharacterAscension> ascensions,
    List<InfoCharacterConstellation> constellations,
  ) {
    return InfoCharacter(
      id: this[0].asString(),
      name: this[1].asString(),
      title: this[2].asString(),
      version: this[3].asString(),
      constellation: this[4].asString(),
      affiliation: this[5].asString(),
      specialDish: this[6].asString(),
      description: this[7].asString(),
      image: this[8].asString(),
      fullImage: this[9].asString(),
      birthday: this[10].asDateTime(),
      releaseDate: this[11].asDateTime(),
      rarity: this[12].asInt(),
      region: GsRegion.values.fromName(this[13].asString()),
      weapon: GsWeapon.values.fromName(this[14].asString()),
      element: GsElement.values.fromName(this[15].asString()),
      talents: talents,
      ascension: ascensions,
      constellations: constellations,
    );
  }

  InfoCharacterTalent toTalent() {
    return InfoCharacterTalent(
      name: this[1].asString(),
      type: this[2].asString(),
      icon: this[3].asString(),
      desc: this[4].asString(),
    );
  }

  InfoCharacterAscension toAscension() {
    return InfoCharacterAscension(
      level: this[1].asInt(),
      materials: this[2].asMap((e) => e, (e) => int.parse(e)),
      valuesBefore: this[3].asMap(
        (e) => GsAttributeStat.values.fromName(e),
        (e) => double.parse(e),
      ),
      valuesAfter: this[4].asMap(
        (e) => GsAttributeStat.values.fromName(e),
        (e) => double.parse(e),
      ),
    );
  }

  InfoCharacterConstellation toConstellation() {
    return InfoCharacterConstellation(
      name: this[1].asString(),
      icon: this[2].asString(),
      desc: this[3].asString(),
    );
  }
}
