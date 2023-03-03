import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/weapons_screen/weapon_details_card.dart';

class WeaponListItem extends StatelessWidget {
  final bool showItem;
  final bool showExtra;
  final InfoWeapon item;

  const WeaponListItem({
    super.key,
    this.showItem = false,
    required this.showExtra,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final owned = GsDatabase.instance.saveWishes.hasWeapon(item.id);
    return Opacity(
      opacity: owned ? 1 : kDisableOpacity,
      child: GsItemCardButton(
        label: item.name,
        rarity: item.rarity,
        banner: GsItemBanner.fromVersion(item.version),
        imageUrlPath: item.image,
        child: _getContent(context),
        onTap: () => WeaponDetailsCard(item).show(context),
      ),
    );
  }

  Widget _getContent(BuildContext context) {
    late final material = GsDatabase.instance.infoWeaponsInfo
        .getAscensionMaterials(item.id)
        .entries
        .map((e) => GsDatabase.instance.infoMaterials.getItemOrNull(e.key))
        .firstOrNullWhere((e) => e?.weekdays.isNotEmpty ?? false);

    return Padding(
      padding: const EdgeInsets.all(kSeparator2),
      child: Stack(
        children: [
          Positioned(
            top: kSeparator2,
            left: kSeparator2,
            child: ItemRarityBubble(
              size: 30,
              asset: item.type.assetPath,
            ),
          ),
          if (showExtra)
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GsItemCardLabel(
                    label: '${item.atk}',
                    asset: GsAttributeStat.atk.assetPath,
                  ),
                  if (item.statType != GsAttributeStat.none)
                    Padding(
                      padding: const EdgeInsets.only(top: kSeparator2),
                      child: Tooltip(
                        message: context.fromLabel(item.statType.label),
                        child: GsItemCardLabel(
                          label:
                              item.statType.toIntOrPercentage(item.statValue),
                          asset: item.statType.assetPath,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (showItem && material != null)
            Positioned(
              right: kSeparator2,
              bottom: kSeparator2,
              child: ItemRarityBubble(
                image: material.image,
                tooltip: material.name,
                rarity: material.rarity,
              ),
            ),
        ],
      ),
    );
  }
}
