import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class CharacterListItem extends StatelessWidget {
  final InfoCharacter item;
  final VoidCallback? onTap;

  CharacterListItem(this.item, {this.onTap});

  @override
  Widget build(BuildContext context) {
    final db = GsDatabase.instance;
    final owned = db.saveWishes.getOwnedCharacter(item.id);
    final friend = db.saveCharacters.getCharFriendship(item.id);
    final ascension = db.saveCharacters.getCharAscension(item.id);

    return ItemCardButton(
      onTap: onTap,
      label: item.name,
      rarity: item.rarity,
      disable: owned == 0,
      imageUrlPath: item.image,
      child: _child(context, owned, friend, ascension),
    );
  }

  Widget _child(BuildContext context, int owned, int friend, int ascension) {
    return Padding(
      padding: EdgeInsets.all(kSeparator2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (owned > 0)
            ItemCardLabel(
              asset: imageXp,
              label: '$friend',
              onTap: () => GsDatabase.instance.saveCharacters
                  .increaseFriendshipCharacter(item.id),
            ),
          Spacer(),
          ItemCardLabel(
            asset: item.element.assetPath,
            label: owned > 0 ? 'C${(owned - 1).clamp(0, 6)}' : null,
            onTap: () => GsDatabase.instance.saveCharacters
                .increaseOwnedCharacter(item.id),
          ),
        ],
      ),
    );
  }
}
