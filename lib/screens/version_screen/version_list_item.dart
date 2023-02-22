import 'package:flutter/widgets.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/version_screen/version_details_card.dart';

class VersionListItem extends StatelessWidget {
  final InfoVersion item;

  const VersionListItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      label: item.id,
      imageUrlPath: item.image,
      banner: GsItemBanner.fromVersion(item.id),
      onTap: () => VersionDetailsCard(item).show(context),
    );
  }
}
