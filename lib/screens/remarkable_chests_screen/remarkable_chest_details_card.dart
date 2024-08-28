import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';

class RemarkableChestDetailsCard extends StatelessWidget
    with GsDetailedDialogMixin {
  final GsFurnitureChest item;

  const RemarkableChestDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        final db = Database.instance.saveOf<GiFurnitureChest>();
        final owned = db.getItem(item.id)?.obtained ?? false;
        return ItemDetailsCard.single(
          name: item.name,
          image: item.image,
          rarity: item.rarity,
          banner: GsItemBanner.fromVersion(context, item.version),
          info: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          item.type == GeSereniteaSetType.indoor
                              ? imageIndoorSet
                              : imageOutdoorSet,
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: kSeparator4),
                        Text(context.fromLabel(item.type.label)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: kSeparator8),
                      child: Text(
                        context.fromLabel(item.region.label),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
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
                  onPress: () => GsUtils.remarkableChests
                      .update(item.id, obtained: !owned),
                ),
              ),
            ],
          ),
          child: _content(context),
        );
      },
    );
  }

  Widget _content(BuildContext context) {
    return ItemDetailsCardContent.generate(context, [
      ItemDetailsCardContent(
        label: context.fromLabel(item.type.label),
        description: context.fromLabel(Labels.energyN, item.energy.format()),
      ),
    ]);
  }
}
