import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_assets.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';

class SettingsScreen extends StatelessWidget {
  static const id = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: Database.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();
        return Scaffold(
          appBar: GsAppBar(
            label: context.fromLabel(Labels.settings),
          ),
          body: Container(
            decoration: kMainBgDecoration,
            child: const SizedBox(),
          ),
        );
      },
    );
  }
}
