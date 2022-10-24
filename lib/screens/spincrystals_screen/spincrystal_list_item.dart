import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/domain/gs_database.dart';

class SpincrystalListItem extends StatelessWidget {
  final InfoSpincrystal spincrystal;

  SpincrystalListItem({required this.spincrystal});

  @override
  Widget build(BuildContext context) {
    final table = GsDatabase.instance.saveSpincrystals;
    final save = table.getItemOrNull(spincrystal.id);
    final owned = save?.obtained ?? false;
    return Opacity(
      opacity: owned ? 1 : kDisableOpacity,
      child: GsItemCardButton(
        label: spincrystal.name,
        imageAssetPath: spincrystalAsset,
        child: Stack(
          children: [
            Positioned(
              left: 2,
              right: 2,
              bottom: 2,
              child: Center(
                child: GsItemCardLabel(
                  label: spincrystal.number.toString(),
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 3,
              child: GsIconButton(
                size: 20,
                color: owned ? Colors.green : Colors.deepOrange,
                icon: owned ? Icons.check : Icons.close,
                onPress: () => table.updateSpincrystal(
                  spincrystal.number,
                  obtained: !owned,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
