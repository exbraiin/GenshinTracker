import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_app_bar.dart';
import 'package:tracker/common/widgets/gs_grid_view.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/common/widgets/value_stream_builder.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/screens/character_ascension_screen/character_ascension_screen.dart';

class CharacterAscensionMaterialsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GsAppBar(label: 'Character Materials'),
      body: ValueStreamBuilder(
        stream: GsDatabase.instance.loaded,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox();

          final mats = _getMaterials();
          return GsGridView.builder(
            itemCount: mats.length,
            itemBuilder: (context, index) => _MaterialItem(mats[index]),
          );
        },
      ),
    );
  }

  List<AscendMaterial> _getMaterials() {
    final savedMats = GsDatabase.instance.saveMaterials;
    final wishes = GsDatabase.instance.saveWishes;
    final saved = GsDatabase.instance.saveCharacters;
    final items = GsDatabase.instance.infoCharacters.getItems();
    final characters = items
        .where((e) => wishes.hasCaracter(e.id))
        .sortedBy((e) => saved.getCharAscension(e.id))
        .thenByDescending((e) => e.rarity)
        .thenBy((e) => e.name)
        .toList();
    return characters
        .expand(
            (e) => getAscendMaterials(e.id, saved.getCharAscension(e.id) + 1))
        .where((e) => e.material != null)
        .groupBy((e) => e.material!.id)
        .entries
        .map((e) {
      final material = e.value.first.material;
      final owned = e.value.first.owned;
      final required = e.value.sumBy((e) => e.required).toInt();
      final craftable =
          owned < required ? savedMats.getCraftableAmount(material!.id) : 0;
      return AscendMaterial(owned, required, craftable, material);
    }).toList();
  }
}

class _MaterialItem extends StatefulWidget {
  final AscendMaterial material;

  _MaterialItem(this.material);

  @override
  State<_MaterialItem> createState() => _MaterialItemState();
}

class _MaterialItemState extends State<_MaterialItem> {
  late final TextEditingController _controller;
  late final StreamSubscription _sub;
  late final FocusNode _node;

  @override
  void initState() {
    super.initState();
    _node = FocusNode();
    _controller = TextEditingController(text: '0');
    _sub = GsDatabase.instance.loaded.listen((e) {
      if (widget.material.material == null) return;
      final db = GsDatabase.instance.saveMaterials;
      final amount = db.getItemOrNull(widget.material.material!.id)?.amount;
      _controller.text = amount?.toString() ?? '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _node.dispose();
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final table = GsDatabase.instance.saveMaterials;
    final mat = widget.material.material;
    final own = widget.material.owned;
    final req = widget.material.required;
    final cft = widget.material.craftable;

    const radius = BorderRadius.all(Radius.circular(6));
    return ItemCardButton(
      label: '',
      rarity: mat?.rarity ?? 1,
      imageUrlPath: mat?.image,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: radius,
                color: GsColors.mainColor0.withOpacity(0.6),
              ),
              padding: EdgeInsets.all(kSeparator4),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: req.format(),
                      style: context.textTheme.infoLabel.copyWith(
                        fontSize: 12,
                        color: own + cft >= req
                            ? Colors.lightGreen
                            : Colors.deepOrange,
                      ),
                    ),
                    if (own < req && cft > 0)
                      TextSpan(
                        text: '\n+${(req - own).clamp(0, cft)}',
                        style: context.textTheme.infoLabel
                            .copyWith(fontSize: 12, color: Colors.orange),
                      ),
                  ],
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
      subChild: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GsIconButtonHold(
            icon: Icons.remove,
            size: 16,
            onPress: own > 0 && mat != null
                ? (i) => table.changeAmount(
                      mat.id,
                      (own - i).clamp(0, own),
                    )
                : null,
          ),
          Expanded(
            child: TextFormField(
              controller: _controller,
              enabled: mat != null,
              focusNode: _node,
              onEditingComplete: mat != null
                  ? () {
                      _node.unfocus();
                      final amount = int.tryParse(_controller.text) ?? 0;
                      GsDatabase.instance.saveMaterials
                          .changeAmount(mat.id, amount);
                    }
                  : null,
              style: context.textTheme.infoLabel.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(
                  (mat?.maxAmount ?? 0).toString().length,
                ),
              ],
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '0',
                hintStyle: context.textTheme.infoLabel.copyWith(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
          GsIconButtonHold(
            icon: Icons.add,
            size: 16,
            onPress: own < (mat?.maxAmount ?? 0) && mat != null
                ? (i) => table.changeAmount(
                      mat.id,
                      (own + i).clamp(own, mat.maxAmount),
                    )
                : null,
          ),
        ],
      ),
    );
  }
}
