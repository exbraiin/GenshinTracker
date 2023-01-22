import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/cards/gs_data_box.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class TestWidgets {
  TestWidgets._();

  static Widget _container(
    BuildContext context,
    Iterable<String> header,
    Iterable<Iterable<String>> items,
  ) {
    if (items.isEmpty) return SizedBox();
    final style = context.textTheme.subtitle2!.copyWith(color: Colors.white);
    return GsDataBox.info(
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.white, width: 0.4),
        ),
        children: [
          TableRow(
            children: header
                .map((e) => Padding(
                      padding: EdgeInsets.all(kSeparator4),
                      child: Text(e, style: style),
                    ))
                .toList(),
          ),
          ...items.map((iitems) => TableRow(
                children: iitems
                    .map((e) => Padding(
                          padding: EdgeInsets.all(kSeparator4),
                          child: Text(e, style: style),
                        ))
                    .toList(),
              )),
        ],
      ),
    );
  }

  static Widget getBannerListItem(BuildContext context) {
    final iw = GsDatabase.instance.infoWeapons;
    final ic = GsDatabase.instance.infoCharacters;
    bool _exists(String id) => iw.exists(id) || ic.exists(id);
    bool _valid(InfoBanner banner) {
      return (banner.feature4.isEmpty && banner.feature5.isEmpty) ||
          banner.feature4.every((e) => _exists(e)) &&
              banner.feature5.every((e) => _exists(e));
    }

    return _container(
      context,
      ['Banner Id', 'Missing 4*', 'Missing 5*'],
      GsDatabase.instance.infoBanners
          .getItems()
          .where((e) => !_valid(e))
          .sortedBy((e) => e.dateStart)
          .map((e) {
        final f4 = e.feature4.where((e) => !_exists(e));
        final f5 = e.feature5.where((e) => !_exists(e));
        return [e.id, f4.join(','), f5.join(',')];
      }),
    );
  }

  static Widget getCharacterListItem(BuildContext context) {
    final items = GsDatabase.instance.infoCharacters.getItems();
    final detailed = GsDatabase.instance.infoCharactersInfo;

    return _container(
      context,
      ['Character Id', 'Missing info'],
      items.map((e) {
        final details = detailed.getItemOrNull(e.id);
        final temp = <String, bool>{
          'title': e.title.isEmpty,
          'constellation': e.constellation.isEmpty,
          'affiliation': e.affiliation.isEmpty,
          'specialDish': e.specialDish.isEmpty,
          'description': e.description.isEmpty,
          'fullImage': e.fullImage.isEmpty,
          'birthday': e.birthday == DateTime(0),
          'releaseDate': e.releaseDate == DateTime(0),
          'talents': (details?.talents ?? []).any(
              (e) => [e.name, e.icon, e.desc, e.type].any((l) => l.isEmpty)),
          'constellations': (details?.constellations ?? [])
              .any((e) => [e.name, e.desc, e.icon].any((l) => l.isEmpty)),
        };
        final noDtls = temp.entries.firstOrNullWhere((e) => e.value)?.key;
        return [e.id, noDtls ?? ''];
      }).where((e) => e[1].isNotEmpty),
    );
  }

  static Widget getMaterialGroups(BuildContext context) {
    final using = GsDatabase.instance.infoMaterials
        .getItems()
        .map((e) => e.group)
        .toSet();
    return _container(context, [
      'Group'
    ], [
      ...GsMaterialGroup.values
          .where((e) => !using.contains(e))
          .map((e) => ['Unused Filter: $e']),
      ...using
          .where((e) => !GsMaterialGroup.values.contains(e))
          .map((e) => ['No Filter: $e']),
    ]);
  }

  static Widget getBannerFeature(BuildContext context) {
    final iw = GsDatabase.instance.infoWeapons;
    final ic = GsDatabase.instance.infoCharacters;
    bool _exists(String id) => iw.exists(id) || ic.exists(id);
    bool _valid(InfoBanner banner) {
      return (banner.feature4.isEmpty && banner.feature5.isEmpty) ||
          banner.feature4.every((e) => _exists(e)) &&
              banner.feature5.every((e) => _exists(e));
    }

    final items = GsDatabase.instance.infoBanners
        .getItems()
        .where((e) => !_valid(e))
        .sortedBy((e) => e.dateStart);
    if (items.isEmpty) return SizedBox();

    return _container(
      context,
      ['id', '4*', '5*'],
      items.map((e) {
        final f5 = e.feature5.where((e) => !_exists(e));
        final f4 = e.feature4.where((e) => !_exists(e));
        return [e.id, f4.join(','), f5.join(',')];
      }),
    );
  }

  static Widget getMissingVersions(BuildContext context) {
    final characters = GsDatabase.instance.infoCharacters
        .getItems()
        .where((e) => e.version.isEmpty)
        .map((e) => e.id);
    final materials = GsDatabase.instance.infoMaterials
        .getItems()
        .where((e) => e.version.isEmpty)
        .map((e) => e.id);
    final recipes = GsDatabase.instance.infoRecipes
        .getItems()
        .where((e) => e.version.isEmpty)
        .map((e) => e.id);
    final serenitea = GsDatabase.instance.infoSereniteaSets
        .getItems()
        .where((e) => e.version.isEmpty)
        .map((e) => e.id);
    final spincrystals = GsDatabase.instance.infoSpincrystal
        .getItems()
        .where((e) => e.version.isEmpty)
        .map((e) => e.id);
    final weapons = GsDatabase.instance.infoWeapons
        .getItems()
        .where((e) => e.version.isEmpty)
        .map((e) => e.id);
    final ingredients = GsDatabase.instance.infoIngredients
        .getItems()
        .where((e) => e.version.isEmpty)
        .map((e) => e.id);

    return _container(
      context,
      ['type', 'ids'],
      [
        if (characters.isNotEmpty) ['Characters', characters.join(', ')],
        if (materials.isNotEmpty) ['Materials', materials.join(', ')],
        if (recipes.isNotEmpty) ['Recipes', recipes.join(', ')],
        if (serenitea.isNotEmpty) ['Serenitea', serenitea.join(', ')],
        if (spincrystals.isNotEmpty) ['Spincrystals', spincrystals.join(', ')],
        if (weapons.isNotEmpty) ['Weapons', weapons.join(', ')],
        if (ingredients.isNotEmpty) ['Ingredients', ingredients.join(', ')],
      ],
    );
  }

  static Widget getMissinIngredients(BuildContext context) {
    final rc = GsDatabase.instance.infoRecipes
        .getItems()
        .expand((e) => e.ingredients.keys)
        .toSet();
    final ig = GsDatabase.instance.infoIngredients
        .getItems()
        .map((element) => element.id)
        .toSet();

    final missingInIg = rc.except(ig);

    if (missingInIg.isEmpty) return SizedBox();

    return _container(
      context,
      ['Missing in ingredients'],
      [
        [missingInIg.join(', ')],
      ],
    );
  }

  static Widget getMissingSpecialDish(BuildContext context) {
    final recipes = GsDatabase.instance.infoRecipes.getItems();
    final missing = recipes
        .where((e) => e.baseRecipe.isNotEmpty)
        .where((e) => !recipes.any((r) => r.id == e.id));

    if (missing.isEmpty) return SizedBox();
    return _container(
      context,
      ['Recipe', 'Base Recipe'],
      missing.map((e) => [e.id, e.baseRecipe]),
    );
  }
}
