import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_domain.dart';

class NamecardDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final InfoNamecard item;

  const NamecardDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ItemDetailsCard.single(
      name: item.name,
      rarity: item.rarity,
      fgImage: item.fullImage,
      banner: GsItemBanner.fromVersion(item.version),
      info: Align(
        alignment: Alignment.topLeft,
        child: Text(context.fromLabel(item.type.label)),
      ),
      child: ItemDetailsCardContent.generate(context, [
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.obtainable),
          description: item.obtain,
        ),
        ItemDetailsCardContent(description: item.desc),
      ]),
    );
  }
}
