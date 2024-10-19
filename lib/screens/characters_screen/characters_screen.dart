import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/characters_screen/character_details_screen.dart';
import 'package:tracker/screens/characters_screen/character_list_item.dart';
import 'package:tracker/screens/characters_screen/characters_table.dart';
import 'package:tracker/screens/widgets/inventory_page.dart';

class CharactersScreen extends StatelessWidget {
  static const id = 'characters_screen';

  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryListPage<GsCharacter>(
      icon: menuIconCharacters,
      title: context.labels.characters(),
      actions: (hasExtra, toggle) => [
        Tooltip(
          message: context.labels.showExtraInfo(),
          child: IconButton(
            icon: Icon(
              hasExtra('info')
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: () => toggle('info'),
          ),
        ),
      ],
      items: (db) => db.infoOf<GsCharacter>().items,
      itemBuilder: (context, state) => CharacterListItem(
        state.item,
        showItem: !state.filter!.isSectionEmpty('weekdays'),
        showExtra: state.filter!.hasExtra('info'),
        onTap: () => _onCharacterTap(context, state.item),
      ),
      tableBuilder: (context, list, hasExtra) => CharactersTable(
        characters: list,
        showTodo: hasExtra('info'),
      ),
    );
  }

  void _onCharacterTap(BuildContext context, GsCharacter character) {
    Navigator.of(context).pushNamed(
      CharacterDetailsScreen.id,
      arguments: character,
    );
  }
}
