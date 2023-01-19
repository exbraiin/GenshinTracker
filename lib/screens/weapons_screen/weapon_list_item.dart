import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/weapons_screen/weapon_details_screen.dart';

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
    return Padding(
      padding: EdgeInsets.all(kSeparator2),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: GsItemCardLabel(
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
                      padding: EdgeInsets.only(top: kSeparator2),
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
        ],
      ),
    );
  }
}
