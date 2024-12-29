import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/theme/theme.dart';

class EnvisagedEchoDetailsCard extends StatelessWidget {
  final GsEnvisagedEcho item;

  const EnvisagedEchoDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final db = Database.instance;
    final owned = GsUtils.echos.hasItem(item.id);
    final char = db.infoOf<GsCharacter>().getItem(item.character);
    return ItemDetailsCard.single(
      name: item.name,
      image: item.icon,
      rarity: item.rarity,
      banner: GsItemBanner.fromVersion(context, item.version),
      info: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(char?.name ?? ''),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: GsIconButton(
              size: 26,
              color: owned
                  ? context.themeColors.goodValue
                  : context.themeColors.badValue,
              icon: owned ? Icons.check : Icons.close,
              onPress: () => GsUtils.echos.update(item.id, !owned),
            ),
          ),
        ],
      ),
      child: ItemDetailsCardContent.generate(context, [
        ItemDetailsCardContent(description: item.description),
      ]),
    );
  }
}
