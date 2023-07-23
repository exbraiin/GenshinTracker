import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_no_results_state.dart';
import 'package:tracker/common/widgets/static/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/screens/characters_screen/character_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_builder.dart';

class CharactersScreen extends StatelessWidget {
  static const id = 'characters_screen';

  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox();
        return ScreenFilterBuilder<InfoCharacter>(
          filter: ScreenFilters.infoCharacterFilter,
          builder: (context, filter, button, toggle) {
            final items = GsDatabase.instance.infoCharacters.getItems();
            final characters = filter.match(items);
            final showItem = !filter.isSectionEmpty('weekdays');
            final child = characters.isEmpty
                ? const GsNoResultsState()
                : GsGridView.builder(
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final item = characters[index];
                      return CharacterListItem(
                        item,
                        showItem: showItem,
                        showExtra: filter.hasExtra('info'),
                        onTap: () => _onCharacterTap(context, item),
                      );
                    },
                  );
            return Scaffold(
              appBar: GsAppBar(
                label: context.fromLabel(Labels.characters),
                actions: [
                  Tooltip(
                    message: context.fromLabel(Labels.showExtraInfo),
                    child: IconButton(
                      icon: Icon(
                        filter.hasExtra('info')
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      onPressed: () => toggle('info'),
                    ),
                  ),
                  const SizedBox(width: kSeparator2),
                  button,
                ],
              ),
              body: Container(
                decoration: kMainBgDecoration,
                child: child,
              ),
            );
          },
        );
      },
    );
  }

  void _onCharacterTap(BuildContext context, InfoCharacter character) {
    Navigator.of(context).pushNamed(
      CharacterDetailsScreen.id,
      arguments: character,
    );
  }
}
