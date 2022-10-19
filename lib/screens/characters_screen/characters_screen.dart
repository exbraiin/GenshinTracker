import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/no_results.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/character_ascension_screen/character_ascension_screen.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/screens/characters_screen/character_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/screen_filters/screen_filter_drawer.dart';

class CharactersScreen extends StatelessWidget {
  static const id = 'characters_screen';

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<bool>(
      stream: GsDatabase.instance.loaded,
      builder: (context, snapshot) {
        if (snapshot.data != true) return SizedBox();
        return ScreenDrawerBuilder<InfoCharacter>(
          filter: () => ScreenFilters.infoCharacterFilter,
          builder: (context, filter, drawer) {
            final items = GsDatabase.instance.infoCharacters.getItems();
            final characters = filter.match(items);
            final child = characters.isEmpty
                ? NoResultsState()
                : GsGridView.builder(
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final item = characters[index];
                      return CharacterListItem(
                        item,
                        onTap: () => _onCharacterTap(context, item),
                      );
                    },
                  );
            return Scaffold(
              key: _key,
              appBar: GsAppBar(
                label: Lang.of(context).getValue(Labels.characters),
                actions: [
                  Tooltip(
                    message: 'Character Ascension',
                    decoration: BoxDecoration(
                      color: GsColors.mainColor0,
                      borderRadius: kMainRadius,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(CharacterAscensionScreen.id),
                      icon: Text(
                        '✦',
                        style: context.textTheme.bigTitle2
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: kSeparator2),
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => _key.currentState?.openEndDrawer(),
                  ),
                ],
              ),
              body: child,
              endDrawer: drawer,
              endDrawerEnableOpenDragGesture: false,
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
