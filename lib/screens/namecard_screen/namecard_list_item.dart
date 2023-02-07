import 'package:flutter/widgets.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_domain.dart';

class NamecardListItem extends StatelessWidget {
  final InfoNamecard item;
  final VoidCallback? onTap;

  const NamecardListItem(this.item, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      label: item.name,
      rarity: item.rarity,
      imageUrlPath: item.image,
      banner: GsItemBanner.fromVersion(item.version),
      onTap: onTap,
    );
  }
}
