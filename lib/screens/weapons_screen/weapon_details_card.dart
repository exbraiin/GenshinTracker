import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/text_style_parser.dart';
import 'package:tracker/common/widgets/value_notifier_builder.dart';
import 'package:tracker/domain/enums/enum_ext.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';
import 'package:tracker/theme/theme.dart';

class WeaponDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final GsWeapon item;

  WeaponDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueNotifierBuilder<bool>(
      value: false,
      builder: (context, nd, child) {
        return ItemDetailsCard.single(
          name: item.name,
          rarity: item.rarity,
          image: !nd.value ? item.image : item.imageAsc,
          info: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.labels.wsAtk()),
              Text(
                item.ascAtkValue.toString(),
                style: TextStyle(
                  color: context.themeColors.almostWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              if (item.statType != GeWeaponAscStatType.none) ...[
                const SizedBox(height: kSeparator4),
                Text(item.statType.label(context)),
                Text(
                  item.statType.toIntOrPercentage(item.ascStatValue),
                  style: TextStyle(
                    color: context.themeColors.almostWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: GsItemCardLabel(
                  label: context.labels.ascension(),
                  onTap: () => nd.value = !nd.value,
                ),
              ),
            ],
          ),
          child: ItemDetailsCardContent.generate(context, [
            ItemDetailsCardContent(description: item.desc),
            if (item.effectName.isNotEmpty) _getInfoEffect(context, item),
            if (item.rarity.between(1, 5)) _getWeaponMats(context, item),
          ]),
        );
      },
    );
  }

  ItemDetailsCardContent _getInfoEffect(
    BuildContext context,
    GsWeapon info,
  ) {
    return ItemDetailsCardContent(
      label: info.effectName,
      content: TextParserWidget(_getEffectTextAll(info.effectDesc)),
    );
  }

  ItemDetailsCardContent _getWeaponMats(
    BuildContext context,
    GsWeapon info,
  ) {
    final im = Database.instance.infoOf<GsMaterial>();
    const iw = GsUtils.weaponMaterials;
    final mats = iw.getAscensionMaterials(info.id);
    return ItemDetailsCardContent(
      label: context.labels.materials(),
      content: Wrap(
        spacing: kGridSeparator,
        runSpacing: kGridSeparator,
        children: mats.entries
            .map((e) => MapEntry(im.getItem(e.key), e.value))
            .where((e) => e.key != null)
            .sortedWith((a, b) => a.key!.compareTo(b.key!))
            .map((e) {
          return ItemGridWidget.material(
            e.key!,
            label: e.value.compact(),
          );
        }).toList(),
      ),
    );
  }

  String _getEffectTextAll(String content) {
    var text = content.toString();
    final matches = RegExp('{.+?}').allMatches(content).reversed;
    for (var match in matches) {
      final temp = content
          .substring(match.start, match.end)
          .removePrefix('{')
          .removeSuffix('}');
      final trimmed = temp.toString().split(',').map((e) => e.trim());
      final single = trimmed.toSet().length == 1;
      var value = single ? trimmed.first : trimmed.join(', ');
      value = '<color=skill>$value</color>';
      text = text.replaceRange(match.start, match.end, value);
    }
    return text;
  }
}
