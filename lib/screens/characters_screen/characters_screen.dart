import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/domain/gs_domain.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/screens/characters_screen/character_list_item.dart';
import 'package:tracker/screens/screen_filters/screen_filter.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class CharactersScreen extends StatelessWidget {
  static const id = 'characters_screen';

  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<InfoCharacter>(
      icon: menuIconCharacters,
      title: context.fromLabel(Labels.characters),
      actions: (extras, toggle) => [
        Tooltip(
          message: context.fromLabel(Labels.showExtraInfo),
          child: IconButton(
            icon: Icon(
              extras.contains('info')
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: () => toggle('info'),
          ),
        ),
      ],
      filter: ScreenFilters.infoCharacterFilter,
      items: (db) => db.infoCharacters.getItems(),
      itemBuilder: (context, state) => CharacterListItem(
        state.item,
        showItem: !state.filter!.isSectionEmpty('weekdays'),
        showExtra: state.filter!.hasExtra('info'),
        onTap: () => _onCharacterTap(context, state.item),
      ),
    );
  }

  void _onCharacterTap(BuildContext context, InfoCharacter character) {
    Navigator.of(context).pushNamed(
      CharacterDetailsScreen.id,
      arguments: character,
    );
  }
}
