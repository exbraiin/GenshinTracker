import 'package:flutter/material.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class ArtifactDetailsScreen extends StatelessWidget {
  static const id = 'artifact_details_screen';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final info = args as InfoArtifact;

    final details = GsDatabase.instance.infoDetails.getArtfItemOrNull(info.id);

    return Scaffold(
      appBar: GsAppBar(
        label: info.name,
      ),
      body: ListView(
        children: [
          Text(details?.name ?? 'None'),
          Text(details?.desc2Pc ?? 'None'),
          Text(details?.desc4Pc ?? 'None'),
          Text(details?.rarity.toString() ?? 'None'),
          Text(details?.domain ?? 'None'),
          ...details?.pieces.map((e) => Text(e.name)) ?? [],
        ],
      ),
    );
  }
}
