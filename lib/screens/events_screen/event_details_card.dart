import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/enums/enum_ext.dart';

class EventDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final GsEvent item;

  EventDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ItemDetailsCard.single(
      name: item.name,
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.fromLabel(item.type.label),
            style: context.themeStyles.title18n,
          ),
        ],
      ),
      rarity: item.type == GeEventType.flagship ? 5 : 4,
      fgImage: item.image,
      banner: GsItemBanner.fromVersion(context, item.version),
      child: ItemDetailsCardContent.generate(context, [
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.duration),
          description:
              '${DateTimeUtils.format(context, item.dateStart, item.dateEnd)} '
              '(${item.dateEnd.difference(item.dateStart).toShortTime(context)})',
        ),
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.version),
          description: item.version,
        ),
      ]),
    );
  }
}
