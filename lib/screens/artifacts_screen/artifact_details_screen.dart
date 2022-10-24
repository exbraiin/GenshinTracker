import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/widgets/gs_info_container.dart';
import 'package:tracker/common/widgets/cards/gs_rarity_item_card.dart';
import 'package:tracker/common/extensions/extensions.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/labels.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/domain/gs_domain.dart';

class ArtifactDetailsScreen extends StatelessWidget {
  static const id = 'artifact_details_screen';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final details = args as InfoArtifact;

    return DefaultTabController(
      length: GsArtifactPieces.values.length,
      child: Scaffold(
        appBar: GsAppBar(
          label: details.name,
        ),
        body: Padding(
          padding: EdgeInsets.all(kSeparator4),
          child: ListView(
            children: [
              GsInfoContainer(
                title: context.fromLabel(Labels.artifactSet),
                children: [
                  if (details.desc1Pc.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.fromLabel(Labels.nPieceBonus, 1),
                          style: context.textTheme.subtitle2!
                              .copyWith(color: Colors.orange),
                        ),
                        SizedBox(width: kSeparator4),
                        Expanded(
                          child: Text(
                            details.desc1Pc,
                            style: context.textTheme.subtitle2!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: kSeparator4),
                      ],
                    ),
                  if (details.desc2Pc.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.fromLabel(Labels.nPieceBonus, 2),
                          style: context.textTheme.subtitle2!
                              .copyWith(color: Colors.orange),
                        ),
                        SizedBox(width: kSeparator4),
                        Expanded(
                          child: Text(
                            details.desc2Pc,
                            style: context.textTheme.subtitle2!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: kSeparator4),
                      ],
                    ),
                  if (details.desc4Pc.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.fromLabel(Labels.nPieceBonus, 4),
                          style: context.textTheme.subtitle2!
                              .copyWith(color: Colors.orange),
                        ),
                        SizedBox(width: kSeparator4),
                        Expanded(
                          child: Text(
                            details.desc4Pc,
                            style: context.textTheme.subtitle2!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: kSeparator8),
              GsInfoContainer(
                title: context.fromLabel(Labels.artifactPieces),
                children: details.pieces
                    .sortedBy((e) => e.type.index)
                    .map<Widget>((e) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GsRarityItemCard(
                              rarity: details.rarity,
                              image: e.icon,
                            ),
                            SizedBox(width: kSeparator8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.name,
                                    style: context.textTheme.infoLabel,
                                  ),
                                  SizedBox(height: kSeparator4),
                                  Text(
                                    e.desc,
                                    style: context.textTheme.description
                                        .copyWith(fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                    .separate(Divider(
                      color: GsColors.dimWhite,
                      thickness: 0.4,
                    ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
