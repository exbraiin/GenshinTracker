import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class TestWidgets {
  TestWidgets._();

  static Widget _container(
    BuildContext context,
    Iterable<String> header,
    Iterable<Iterable<String>> items,
  ) {
    final style = context.textTheme.subtitle2!.copyWith(color: Colors.white);
    return Container(
      decoration: BoxDecoration(
        borderRadius: kMainRadius,
        color: Colors.black.withOpacity(0.4),
        border: Border.all(color: Colors.white),
      ),
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
    final info = GsDatabase.instance.infoCharacters;
    final items = GsDatabase.instance.infoCharacters.getItems();

    return _container(
      context,
      ['Character Id', 'Missing info'],
      items.map((e) {
        final details = info.getItemOrNull(e.id);
        final temp = <String, bool>{
          'title': details?.title.isEmpty ?? true,
          'constellation': details?.constellation.isEmpty ?? true,
          'affiliation': details?.affiliation.isEmpty ?? true,
          'specialDish': details?.specialDish.isEmpty ?? true,
          'description': details?.description.isEmpty ?? true,
          'fullImage': details?.fullImage.isEmpty ?? true,
          'birthday': details?.birthday == DateTime(0),
          'releaseDate': details?.releaseDate == DateTime(0),
          'talents': details?.talents.any((e) =>
                  [e.name, e.icon, e.desc, e.type].any((l) => l.isEmpty)) ??
              true,
          'constellations': details?.constellations
                  .any((e) => [e.name, e.desc, e.icon].any((l) => l.isEmpty)) ??
              true,
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
      ...InfoMaterialGroups.groups
          .where((e) => !using.contains(e))
          .map((e) => ['Unused Filter: $e']),
      ...using
          .where((e) => !InfoMaterialGroups.groups.contains(e))
          .map((e) => ['No Filter: $e']),
    ]);
  }
}
