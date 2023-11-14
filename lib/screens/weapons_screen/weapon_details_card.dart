import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_spacing.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_detailed_dialog.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/common/widgets/text_style_parser.dart';
import 'package:tracker/common/widgets/value_notifier_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/widgets/ascension_table.dart';
import 'package:tracker/theme/theme.dart';

class WeaponDetailsCard extends StatelessWidget with GsDetailedDialogMixin {
  final InfoWeapon item;

  WeaponDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final info = GsDatabase.instance.infoWeaponsInfo.getItemOrNull(item.id);
    return ValueNotifierBuilder<bool>(
      value: false,
      builder: (context, nd, child) {
        return ItemDetailsCard.single(
          name: item.name,
          rarity: item.rarity,
          image: !nd.value ? item.image : item.imageAscension,
          info: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.fromLabel(GsAttributeStat.atk.label)),
              Text(
                item.atk.toString(),
                style: TextStyle(
                  color: context.themeColors.almostWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              if (item.statType != GsAttributeStat.none) ...[
                const SizedBox(height: kSeparator4),
                Text(context.fromLabel(item.statType.label)),
                Text(
                  item.statType.toIntOrPercentage(item.statValue),
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
                  label: context.fromLabel(Labels.ascension),
                  onTap: () => nd.value = !nd.value,
                ),
              ),
            ],
          ),
          child: info != null
              ? ItemDetailsCardContent.generate(context, [
                  if (info.effectName.isNotEmpty) _getInfoEffect(context, info),
                  ItemDetailsCardContent(description: item.description),
                  _getInfoAscension(context, info),
                  _getWeaponMats(context, info),
                ])
              : null,
        );
      },
    );
  }

  ItemDetailsCardContent _getInfoEffect(
    BuildContext context,
    InfoWeaponInfo info,
  ) {
    return ItemDetailsCardContent(
      label: info.effectName,
      content: TextParserWidget(_getEffectTextAll(info.effectDesc)),
    );
  }

  ItemDetailsCardContent _getInfoAscension(
    BuildContext context,
    InfoWeaponInfo info,
  ) {
    return ItemDetailsCardContent(
      label: context.fromLabel(Labels.ascension),
      content: AscensionTable.weapon(item, info),
    );
  }

  ItemDetailsCardContent _getWeaponMats(
    BuildContext context,
    InfoWeaponInfo info,
  ) {
    final im = GsDatabase.instance.infoMaterials;
    final iw = GsUtils.weaponMaterials;
    final mats = iw.getAscensionMaterials(info.id);
    return ItemDetailsCardContent(
      label: context.fromLabel(Labels.materials),
      content: Wrap(
        spacing: kSeparator4,
        runSpacing: kSeparator4,
        children: mats.entries
            .map((e) => MapEntry(im.getItemOrNull(e.key), e.value))
            .where((e) => e.key != null)
            .sortedBy((e) => e.key!)
            .map((e) {
          return ItemRarityBubble.withLabel(
            rarity: e.key!.rarity,
            image: e.key!.image,
            tooltip: e.key!.name,
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
