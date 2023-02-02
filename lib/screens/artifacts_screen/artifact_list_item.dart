import 'package:flutter/material.dart';
import 'package:tracker/common/widgets/gs_item_card_button.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/artifacts_screen/artifact_details_screen.dart';

class ArtifactListItem extends StatelessWidget {
  final InfoArtifact artifact;

  const ArtifactListItem(this.artifact, {super.key});

  @override
  Widget build(BuildContext context) {
    return GsItemCardButton(
      label: artifact.name,
      rarity: artifact.rarity,
      banner: GsItemBanner.fromVersion(artifact.version),
      imageUrlPath: artifact.image,
      onTap: () => Navigator.of(context).pushNamed(
        ArtifactDetailsScreen.id,
        arguments: artifact,
      ),
    );
  }
}
