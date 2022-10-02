import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/domain/gs_database.dart';

// ignore: unused_element
Widget checkBannerFeature(BuildContext context) {
  final iw = GsDatabase.instance.infoWeapons;
  final ic = GsDatabase.instance.infoCharacters;
  bool _exists(String id) => iw.exists(id) || ic.exists(id);
  bool _valid(InfoBanner banner) {
    return (banner.feature4.isEmpty && banner.feature5.isEmpty) ||
        banner.feature4.every((e) => _exists(e)) &&
            banner.feature5.every((e) => _exists(e));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: GsDatabase.instance.infoBanners
        .getItems()
        .where((e) => !_valid(e))
        .sortedBy((e) => e.dateStart)
        .map((e) {
      final f5 = e.feature5.where((e) => !_exists(e));
      final f4 = e.feature4.where((e) => !_exists(e));
      return Text(
        '${e.id} ||| ${f4.join(',')} ||| ${f5.join(',')}',
        style: context.textTheme.infoLabel,
      );
    }).toList(),
  );
}

// ignore: unused_element
Widget getEnumValues<T>(
  List<T> list,
  String Function(T i) name,
  String Function(T i) asset,
  IconData? Function(T i)? icon,
) {
  return GsGridView.builder(
    itemCount: list.length,
    itemBuilder: (c, i) {
      final ii = icon?.call(list[i]);
      return ItemCardButton(
        label: name(list[i]),
        rarity: 1,
        imageAssetPath: asset(list[i]),
        child: Stack(
          children: [
            if (ii != null) Positioned.fill(child: Icon(ii)),
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.topLeft,
                child: ItemCardLabel(
                  label: i.toString(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
