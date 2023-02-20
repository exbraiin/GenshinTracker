import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/weapons_screen/weapon_details_screen.dart';

class WeaponListItem extends StatelessWidget {
  final bool showItem;
  final bool showExtra;
  final InfoWeapon weapon;

  const WeaponListItem({
    super.key,
    this.showItem = false,
    required this.showExtra,
    required this.weapon,
  });

  @override
  Widget build(BuildContext context) {
    final owned = GsDatabase.instance.saveWishes.hasWeapon(weapon.id);
    return Opacity(
      opacity: owned ? 1 : kDisableOpacity,
      child: GsItemCardButton(
        label: weapon.name,
        rarity: weapon.rarity,
        banner: GsItemBanner.fromVersion(weapon.version),
        imageUrlPath: weapon.image,
        child: _getContent(context),
        onTap: () => Navigator.of(context).pushNamed(
          WeaponDetailsScreen.id,
          arguments: weapon,
        ),
      ),
    );
  }

  Widget _getContent(BuildContext context) {
    late final material = GsDatabase.instance.infoWeaponsInfo
        .getAscensionMaterials(weapon.id)
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
              asset: weapon.type.assetPath,
            ),
          ),
          if (showExtra)
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GsItemCardLabel(
                    label: '${weapon.atk}',
                    asset: GsAttributeStat.atk.assetPath,
                  ),
                  if (weapon.statType != GsAttributeStat.none)
                    Padding(
                      padding: const EdgeInsets.only(top: kSeparator2),
                      child: Tooltip(
                        message: context.fromLabel(weapon.statType.label),
                        child: GsItemCardLabel(
                          label: weapon.statType
                              .toIntOrPercentage(weapon.statValue),
                          asset: weapon.statType.assetPath,
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
