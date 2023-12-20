import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class MaterialDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final GsMaterial item;

  const MaterialDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    item.weekdays;
    return ItemDetailsCard.single(
      name: item.name,
      image: item.image,
      rarity: item.rarity,
      banner: GsItemBanner.fromVersion(context, item.version),
      info: Text(_getLabel(context)),
      child: _content(context),
    );
  }

  String _getLabel(BuildContext context) {
    late final group = context.fromLabel(item.group.label);
    late final ingredient = context.fromLabel(Labels.ingredients);

    if (item.ingredient) {
      return item.group == GeMaterialType.none
          ? ingredient
          : '$ingredient & $group';
    }
    return group;
  }

  Widget _content(BuildContext context) {
    final mats = GsUtils.materials
        .getGroupMaterials(item)
        .sortedBy((e) => e.rarity)
        .thenBy((element) => element.id == item.id ? 0 : 1)
        .distinctBy((element) => element.rarity);

    return ItemDetailsCardContent.generate(context, [
      if (item.desc.isNotEmpty) ItemDetailsCardContent(description: item.desc),
      if (item.weekdays.isNotEmpty)
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.weeklyTasks),
          description: item.weekdays
              .map((e) => '\u2022 ${e.getLabel(context)}')
              .join('\n'),
        ),
      if (mats.length > 1 && item.group != GeMaterialType.none)
        ItemDetailsCardContent(
          label: context.fromLabel(Labels.materials),
          content: Wrap(
            spacing: kSeparator4,
            runSpacing: kSeparator4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: mats
                .map((e) => ItemGridWidget.material(e, onTap: null))
                .toList(),
          ),
        ),
    ]);
  }
}
