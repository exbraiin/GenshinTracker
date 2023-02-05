import 'package:flutter/material.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_domain.dart';

class ArtifactListItem extends StatelessWidget {
  final InfoArtifact artifact;
  final bool selected;
  final VoidCallback? onTap;

  const ArtifactListItem(
    this.artifact, {
    super.key,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      label: artifact.name,
      rarity: artifact.rarity,
      selected: selected,
      banner: GsItemBanner.fromVersion(artifact.version),
      imageUrlPath: artifact.image,
      onTap: onTap,
    );
  }
}
