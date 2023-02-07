import 'package:flutter/widgets.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_domain.dart';

class SpincrystalDetailsCard extends StatelessWidget
    with GsDetailedDialogMixin {
  final InfoSpincrystal item;

  const SpincrystalDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ItemDetailsCard.single(
      info: Text(item.name),
      name: 'Radiant Spincrystal ${item.number}',
      rarity: item.rarity,
      asset: spincrystalAsset,
      banner: GsItemBanner.fromVersion(item.version),
      child: ItemDetailsCardContent.generate(context, [
        if (item.desc.isNotEmpty)
          ItemDetailsCardContent(
            description: item.desc,
          ),
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.source),
          description: item.source,
        ),
      ]),
    );
  }
}
