import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class CharacterListItem extends StatelessWidget {
  final InfoCharacter item;
  final VoidCallback? onTap;

  CharacterListItem(this.item, {this.onTap});

  @override
  Widget build(BuildContext context) {
    final chars = GsUtils.characters;
    final friend = chars.getCharFriendship(item.id);
    final ascension = chars.getCharAscension(item.id);
    final charCons = chars.getCharConstellations(item.id);
    final charConsTotal = chars.getTotalCharConstellations(item.id);

    return GsItemCardButton(
      onTap: onTap,
      label: item.name,
      rarity: item.rarity,
      disable: charCons == null,
      banner: GsItemBanner.fromVersion(item.version),
      imageUrlPath: item.image,
      child: _child(context, charCons, charConsTotal, friend, ascension),
    );
  }

  Widget _child(
    BuildContext context,
    int? charCons,
    int? charConsTotal,
    int friend,
    int ascension,
  ) {
    return Padding(
      padding: EdgeInsets.all(kSeparator2),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (charCons != null)
                GsItemCardLabel(
                  asset: imageXp,
                  label: '$friend',
                  onTap: () => GsDatabase.instance.saveCharacters
                      .increaseFriendshipCharacter(item.id),
                ),
              Spacer(),
              GsItemCardLabel(
                asset: item.element.assetPath,
                label: charCons != null ? 'C$charCons' : null,
                onTap: () => GsDatabase.instance.saveCharacters
                    .increaseOwnedCharacter(item.id),
              ),
            ],
          ),
          if (charConsTotal != null && charConsTotal != charCons)
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: kSeparator2),
              child: GsItemCardLabel(
                asset: menuIconWish,
                label: 'C$charConsTotal',
              ),
            ),
        ],
      ),
    );
  }
}
