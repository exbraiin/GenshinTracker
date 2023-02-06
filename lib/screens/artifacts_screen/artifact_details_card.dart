import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_domain.dart';

class ArtifactDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final InfoArtifact item;

  const ArtifactDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ItemDetailsCard.paged(
      name: item.name,
      info: (ctx, piece) => Text(item.pieces[piece].name),
      image: (ctx, piece) => item.pieces[piece].icon,
      rarity: item.rarity,
      pages: item.pieces.length,
      banner: GsItemBanner.fromVersion(item.version),
      child: (ctx, piece) => ItemDetailsCardContent.generate(context, [
        if (item.desc1Pc.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.nPieceBonus, 1),
            description: item.desc1Pc,
          ),
        if (item.desc2Pc.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.nPieceBonus, 2),
            description: item.desc2Pc,
          ),
        if (item.desc4Pc.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.nPieceBonus, 4),
            description: item.desc4Pc,
          ),
        if (item.pieces[piece].desc.isNotEmpty)
          ItemDetailsCardContent(
            description: item.pieces[piece].desc,
          ),
        if (item.domain.isNotEmpty)
          ItemDetailsCardContent(
            label: context.fromLabel(Labels.source),
            description: item.domain,
          ),
      ]),
    );
  }
}
