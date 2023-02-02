import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/widgets/gs_number_field.dart';
import 'package:tracker/domain/gs_database.dart';

class CharacterAscensionMaterial extends StatelessWidget {
  final String id;
  final int amount;

  const CharacterAscensionMaterial(this.id, this.amount, {super.key});

  @override
  Widget build(BuildContext context) {
    final im = GsDatabase.instance.infoMaterials;
    final material = im.getItemOrNull(id);
    final db = GsDatabase.instance.saveMaterials;
    final owned = db.getItemOrNull(id)?.amount ?? 0;
    final craftable = db.getCraftableAmount(id);

    return GsRarityItemCard(
      size: 64,
      image: material?.image ?? '',
      rarity: material?.rarity ?? 1,
      header: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: amount.format(),
              style: context.textTheme.infoLabel.copyWith(
                fontSize: 10,
                color: owned + craftable >= amount
                    ? Colors.lightGreen
                    : GsColors.missing,
              ),
            ),
            if (owned < amount && craftable > 0)
              TextSpan(
                text: ' -${(amount - owned).clamp(0, craftable)}',
                style: context.textTheme.infoLabel
                    .copyWith(fontSize: 10, color: Colors.white),
              ),
          ],
        ),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
      footer: GsNumberField.fromMaterial(material),
    );
  }
}
