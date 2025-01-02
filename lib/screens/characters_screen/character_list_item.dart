import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/widgets/item_info_widget.dart';

class CharacterListItem extends StatelessWidget {
  final bool showItem;
  final GsCharacter item;
  final bool selected;
  final VoidCallback? onTap;

  const CharacterListItem(
    this.item, {
    super.key,
    this.selected = false,
    this.showItem = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const chars = GsUtils.characters;
    final friend = chars.getCharFriendship(item.id);
    final ascension = chars.getCharAscension(item.id);
    final charConsTotal = chars.getTotalCharConstellations(item.id);

    return GsItemCardButton(
      onTap: onTap,
      label: item.name,
      rarity: item.rarity,
      disable: charConsTotal == null,
      selected: selected,
      banner: GsItemBanner.fromVersion(context, item.version),
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
        .map((e) => Database.instance.infoOf<GsMaterial>().getItem(e.key))
        .firstOrNullWhere((e) => e?.weekdays.isNotEmpty ?? false);

    return Padding(
      padding: const EdgeInsets.all(kSeparator2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemCircleWidget.element(item.element),
          const Spacer(),
          if (showItem && material != null)
            Align(
              alignment: Alignment.bottomRight,
              child: ItemCircleWidget.material(material),
            ),
        ],
      ),
    );
  }
}
