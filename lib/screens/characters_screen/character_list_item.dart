import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class CharacterListItem extends StatelessWidget {
  final bool showItem;
  final bool showExtra;
  final InfoCharacter item;
  final VoidCallback? onTap;

  const CharacterListItem(
    this.item, {
    super.key,
    this.showItem = false,
    this.showExtra = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chars = GsUtils.characters;
    final friend = chars.getCharFriendship(item.id);
    final ascension = chars.getCharAscension(item.id);
    final charConsTotal = chars.getTotalCharConstellations(item.id);

    return GsItemCardButton(
      onTap: onTap,
      label: item.name,
      rarity: item.rarity,
      disable: charConsTotal == null,
      banner: GsItemBanner.fromVersion(item.version),
      imageUrlPath: GsUtils.characters.getImage(item.id),
      child: _child(context, charConsTotal, friend, ascension),
    );
  }

  Widget _child(
    BuildContext context,
    int? charConsTotal,
    int friend,
    int ascension,
  ) {
    late final material = GsUtils.characterMaterials
        .getTalentMaterials(item.id)
        .entries
        .map((e) => GsDatabase.instance.infoMaterials.getItemOrNull(e.key))
        .firstOrNullWhere((e) => e?.weekdays.isNotEmpty ?? false);

    return Padding(
      padding: const EdgeInsets.all(kSeparator2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showExtra && charConsTotal != null
              ? ItemRarityBubble.withLabel(
                  size: 30,
                  asset: item.element.assetPath,
                  label: 'C${charConsTotal.compact()}',
                )
              : ItemRarityBubble(size: 30, asset: item.element.assetPath),
          const Spacer(),
          Column(
            children: [
              if (showExtra && charConsTotal != null)
                GsItemCardLabel(
                  asset: imageXp,
                  label: '$friend',
                ),
              const Spacer(),
              if (showItem && material != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: ItemRarityBubble(
                    image: material.image,
                    tooltip: material.name,
                    rarity: material.rarity,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
