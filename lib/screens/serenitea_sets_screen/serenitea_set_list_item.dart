import 'package:flutter/material.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/serenitea_sets_screen/serenitea_character_button.dart';

class SereniteaSetListItem extends StatelessWidget {
  final InfoSereniteaSet set;
  final SaveSereniteaSet? saved;

  SereniteaSetListItem(this.set, this.saved);

  bool _isCharacterOwned(String id) => saved?.chars.contains(id) ?? false;

  bool _hasCharacterFromWishes(String id) =>
      GsDatabase.instance.saveWishes.hasCaracter(id);

  String get _setImage => set.category == GsSetCategory.indoor
      ? imageIndoorSet
      : set.category == GsSetCategory.outdoor
          ? imageOutdoorSet
          : '';

  void _onCharacterTap(String id) {
    GsDatabase.instance.saveSereniteaSets
        .setSetCharacter(set.id, id, !_isCharacterOwned(id));
  }

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      label: set.name,
      banner: GsItemBanner.fromVersion(set.version),
      imageUrlPath: set.image,
      child: Stack(
        children: [
          Positioned(
            top: 2,
            left: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: set.category == GsSetCategory.indoor
                    ? GsColors.setIndoor
                    : set.category == GsSetCategory.outdoor
                        ? GsColors.setOutdoor
                        : GsColors.mainColor1,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: _setImage.isNotEmpty ? Image.asset(_setImage) : null,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${set.energy.format()}',
                    style: context.textTheme.subtitle2!.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: kSeparator2,
                horizontal: kSeparator2,
              ),
              child: Wrap(
                alignment: WrapAlignment.end,
                verticalDirection: VerticalDirection.up,
                spacing: kSeparator2,
                runSpacing: kSeparator2,
                children: set.chars
                    .map((id) => SereniteaCharacterButton(
                          key: ValueKey('${set.name} - $id'),
                          id: id,
                          owned: _hasCharacterFromWishes(id),
                          collected: _isCharacterOwned(id),
                          onTap: () => _onCharacterTap(id),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
