import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class WeaponListItem extends StatelessWidget {
  final bool showExtra;
  final InfoWeapon weapon;

  WeaponListItem({
    required this.showExtra,
    required this.weapon,
  });

  @override
  Widget build(BuildContext context) {
    final owned = GsDatabase.instance.saveWishes.hasWeapon(weapon.id);
    return Opacity(
      opacity: owned ? 1 : kDisableOpacity,
      child: ItemCardButton(
        label: weapon.name,
        rarity: weapon.rarity,
        imageUrlPath: weapon.image,
        child: _getContent(context),
      ),
    );
  }

  Widget _getContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kSeparator2),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: ItemCardLabel(
              asset: weapon.type.assetPath,
            ),
          ),
          if (showExtra)
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ItemCardLabel(
                    label: '${weapon.atk}',
                    asset: GsAttributeStat.atk.assetPath,
                  ),
                  if (weapon.statType != GsAttributeStat.none)
                    Padding(
                      padding: EdgeInsets.only(top: kSeparator2),
                      child: Tooltip(
                        message: weapon.statType.toPrettyString(context),
                        decoration: BoxDecoration(
                          color: GsColors.mainColor0,
                          borderRadius: kMainRadius,
                        ),
                        child: ItemCardLabel(
                          label: weapon.statType
                              .toIntOrPercentage(weapon.statValue),
                          asset: weapon.statType.assetPath,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
