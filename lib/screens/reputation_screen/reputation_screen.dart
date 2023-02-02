import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/reputation_screen/reputation_list_item.dart';

class ReputationScreen extends StatelessWidget {
  static const id = 'reputation_screen';

  const ReputationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GsAppBar(label: Lang.of(context).getValue(Labels.reputation)),
      body: Padding(
        padding: const EdgeInsets.all(kSeparator4),
        child: ValueStreamBuilder<bool>(
          stream: GsDatabase.instance.loaded,
          builder: (context, snapshot) {
            if (snapshot.data != true) return const SizedBox();
            return ListView(
              children: [
                Wrap(
                  spacing: kSeparator4,
                  runSpacing: kSeparator4,
                  children: GsDatabase.instance.infoCities
                      .getItems()
                      .map((c) => ReputationListItem(c))
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
