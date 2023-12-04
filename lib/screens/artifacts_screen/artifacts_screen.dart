import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/artifacts_screen/artifact_details_card.dart';
import 'package:tracker/screens/artifacts_screen/artifact_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class ArtifactsScreen extends StatelessWidget {
  static const id = 'artifacts_screen';

  const ArtifactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<InfoArtifact>(
      icon: menuIconArtifacts,
      title: context.fromLabel(Labels.artifacts),
      filter: ScreenFilters.infoArtifactFilter,
      items: (db) => db.infoArtifacts.getItems(),
      itemBuilder: (context, state) => ArtifactListItem(
        state.item,
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => ArtifactDetailsCard(item),
    );
  }
}
