import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/theme/theme.dart';

class SpincrystalDetailsCard extends StatelessWidget
    with GsDetailedDialogMixin {
  final InfoSpincrystal item;

  const SpincrystalDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final region = GsDatabase.instance.infoCities.getItemOrNull(item.region.id);
    return ValueStreamBuilder(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        final db = GsDatabase.instance.saveSpincrystals;
        final owned = db.getItemOrNull(item.id)?.obtained ?? false;
        return ItemDetailsCard.single(
          name: 'Radiant Spincrystal ${item.number}',
          rarity: item.rarity,
          asset: spincrystalAsset,
          banner: GsItemBanner.fromVersion(item.version),
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
                  onPress: () => db.updateSpincrystal(
                    item.number,
                    obtained: !owned,
                  ),
                ),
              )
            ],
          ),
          child: ItemDetailsCardContent.generate(context, [
            if (item.desc.isNotEmpty)
              ItemDetailsCardContent(
                description: item.desc,
              ),
            if (region != null)
              ItemDetailsCardContent(
                label: context.fromLabel(Labels.region),
                description: region.name,
              ),
            ItemDetailsCardContent(
              label: context.fromLabel(Labels.source),
              description: item.source,
            ),
          ]),
        );
      },
    );
  }
}
