import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/graphics/gs_colors.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_domain.dart';

class SereniteaSetListItem extends StatelessWidget {
  final InfoSereniteaSet set;
  final VoidCallback? onTap;

  const SereniteaSetListItem(this.set, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      label: set.name,
      banner: GsItemBanner.fromVersion(set.version),
      imageUrlPath: set.image,
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            top: kSeparator2,
            left: kSeparator2,
            child: GsItemCardLabel(
              bgColor: set.category == GsSetCategory.indoor
                  ? GsColors.setIndoor
                  : GsColors.setOutdoor,
              asset: set.category == GsSetCategory.indoor
                  ? imageIndoorSet
                  : imageOutdoorSet,
            ),
          ),
        ],
      ),
    );
  }
}
