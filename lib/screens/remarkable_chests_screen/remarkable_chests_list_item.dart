import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class RemarkableChestListItem extends StatelessWidget {
  final InfoRemarkableChest item;

  String get _setImage => item.type == GsSetCategory.indoor
      ? imageIndoorSet
      : item.type == GsSetCategory.outdoor
          ? imageOutdoorSet
          : '';

  const RemarkableChestListItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final db = GsDatabase.instance;
    final owned = db.saveRemarkableChests.exists(item.id);

    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      disable: !owned,
      banner: GsItemBanner.fromVersion(item.version),
      imageUrlPath: item.image,
      child: Stack(
        children: [
          Positioned(
            top: kSeparator2,
            left: kSeparator2,
            child: Container(
              width: 20,
              height: 20,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: item.type == GsSetCategory.indoor
                    ? GsColors.setIndoor
                    : item.type == GsSetCategory.outdoor
                        ? GsColors.setOutdoor
                        : GsColors.mainColor1,
                borderRadius: BorderRadius.circular(100),
              ),
              child: _setImage.isNotEmpty ? Image.asset(_setImage) : null,
            ),
          ),
          Positioned(
            top: kSeparator2,
            right: kSeparator2,
            child: GsIconButton(
              size: 20,
              color: owned ? Colors.green : GsColors.missing,
              icon: owned ? Icons.check : Icons.close,
              onPress: () => db.saveRemarkableChests
                  .updateRemarkableChest(item.id, obtained: !owned),
            ),
          ),
        ],
      ),
    );
  }
}
