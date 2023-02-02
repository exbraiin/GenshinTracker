import 'package:flutter/material.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class MaterialListItem extends StatelessWidget {
  final InfoMaterial item;

  const MaterialListItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final table = GsDatabase.instance.saveMaterials;
    final saved = table.getItemOrNull(item.id);
    final amount = saved?.amount ?? 0;
    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      banner: GsItemBanner.fromVersion(item.version),
      imageUrlPath: item.image,
      subChild: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            GsIconButtonHold(
              icon: Icons.remove,
              size: 20,
              onPress: amount > 0
                  ? (i) => table.changeAmount(
                        item.id,
                        (amount - i).clamp(0, amount),
                      )
                  : null,
            ),
            Expanded(
              child: GsNumberField.fromMaterial(item),
            ),
            GsIconButtonHold(
              onPress: amount < item.maxAmount
                  ? (i) => table.changeAmount(
                        item.id,
                        (amount + i).clamp(amount, item.maxAmount),
                      )
                  : null,
              icon: Icons.add,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
