import 'package:flutter/material.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/artifacts_screen/artifact_details_screen.dart';

class ArtifactListItem extends StatelessWidget {
  final InfoArtifact artifact;

  ArtifactListItem(this.artifact);

  @override
  Widget build(BuildContext context) {
    return ItemCardButton(
      label: artifact.name,
      rarity: artifact.rarity,
      imageUrlPath: artifact.image,
      onTap: () => Navigator.of(context).pushNamed(
        ArtifactDetailsScreen.id,
        arguments: artifact,
      ),
    );
  }
}
