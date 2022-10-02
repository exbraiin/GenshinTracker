import 'package:flutter/material.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class MaterialListItem extends StatelessWidget {
  final InfoMaterial item;

  MaterialListItem(this.item);

  @override
  Widget build(BuildContext context) {
    final table = GsDatabase.instance.saveMaterials;
    final saved = table.getItemOrNull(item.id);
    final amount = saved?.amount ?? 0;
    return ItemCardButton(
      label: item.name,
      rarity: item.rarity,
      imageUrlPath: item.image,
      subChild: Padding(
        padding: EdgeInsets.all(2),
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
              child: Center(
                child: Text(
                  '$amount',
                  style: context.textTheme.subtitle2!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            GsIconButtonHold(
              onPress: amount < 9999
                  ? (i) => table.changeAmount(
                        item.id,
                        (amount + i).clamp(amount, 9999),
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
