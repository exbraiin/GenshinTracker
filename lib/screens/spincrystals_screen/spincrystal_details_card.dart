import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';

class SpincrystalDetailsCard extends StatelessWidget
    with GsDetailedDialogMixin {
  final GsSpincrystal item;

  const SpincrystalDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        final db = Database.instance.saveOf<GiSpincrystal>();
        final owned = db.exists(item.id);
        return ItemDetailsCard.single(
          name: context.labels.radiantSpincrystal(item.number),
          rarity: 4,
          asset: GsAssets.spincrystal,
          banner: GsItemBanner.fromVersion(context, item.version),
          info: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(item.name),
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
                  onPress: () => GsUtils.spincrystals
                      .update(item.number, obtained: !owned),
                ),
              ),
            ],
          ),
          child: ItemDetailsCardContent.generate(context, [
            ItemDetailsCardContent(
              label: context.labels.region(),
              description: item.region.label(context),
            ),
            ItemDetailsCardContent(
              label: context.labels.source(),
              description: item.source,
            ),
          ]),
        );
      },
    );
  }
}
