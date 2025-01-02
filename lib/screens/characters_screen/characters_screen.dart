import 'package:flutter/material.dart';
import 'package:gsdatabase/gsdatabase.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/screens/characters_screen/character_details_card.dart';
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
      items: (db) => db.infoOf<GsCharacter>().items,
      itemBuilder: (context, state) => CharacterListItem(
        state.item,
        showItem: !state.filter!.isSectionEmpty('weekdays'),
        onTap: state.onSelect,
        selected: state.selected,
      ),
      itemCardBuilder: (context, item) => CharacterDetailsCard(item),
      tableBuilder: (context, list, hasExtra) => CharactersTable(
        characters: list,
        showTodo: hasExtra('info'),
      ),
    );
  }
}
