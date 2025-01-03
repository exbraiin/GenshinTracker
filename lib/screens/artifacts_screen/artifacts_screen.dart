import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/artifacts_screen/artifact_details_card.dart';
import 'package:tracker/screens/artifacts_screen/artifact_list_item.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class ArtifactsScreen extends StatelessWidget {
  static const id = 'artifacts_screen';

  const ArtifactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<GsArtifact>(
      icon: GsAssets.menuArtifacts,
      title: context.labels.artifacts(),
      items: (db) => db.infoOf<GsArtifact>().items,
      itemBuilder: (context, state) => ArtifactListItem(
        state.item,
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => ArtifactDetailsCard(
        item,
        key: ValueKey(item.id),
      ),
    );
  }
}
