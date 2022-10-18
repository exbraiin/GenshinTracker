import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/gs_icon_button.dart';
import 'package:tracker/common/widgets/item_card_button.dart';
import 'package:tracker/domain/gs_database.dart';
import 'package:tracker/domain/gs_domain.dart';

class MaterialListItem extends StatefulWidget {
  final InfoMaterial item;

  MaterialListItem(this.item);

  @override
  State<MaterialListItem> createState() => _MaterialListItemState();
}

class _MaterialListItemState extends State<MaterialListItem> {
  late final TextEditingController _controller;
  late final StreamSubscription _sub;
  late final FocusNode _node;

  @override
  void initState() {
    super.initState();
    _node = FocusNode();
    _controller = TextEditingController(text: '0');
    _sub = GsDatabase.instance.loaded.listen((e) {
      final db = GsDatabase.instance.saveMaterials;
      final amount = db.getItemOrNull(widget.item.id)?.amount;
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
    final saved = table.getItemOrNull(widget.item.id);
    final amount = saved?.amount ?? 0;
    return ItemCardButton(
      label: widget.item.name,
      rarity: widget.item.rarity,
      imageUrlPath: widget.item.image,
      subChild: Padding(
        padding: EdgeInsets.all(2),
        child: Row(
          children: [
            GsIconButtonHold(
              icon: Icons.remove,
              size: 20,
              onPress: amount > 0
                  ? (i) => table.changeAmount(
                        widget.item.id,
                        (amount - i).clamp(0, amount),
                      )
                  : null,
            ),
            Expanded(
              child: TextFormField(
                controller: _controller,
                focusNode: _node,
                onEditingComplete: () {
                  _node.unfocus();
                  final amount = int.tryParse(_controller.text) ?? 0;
                  GsDatabase.instance.saveMaterials
                      .changeAmount(widget.item.id, amount);
                },
                style: context.textTheme.infoLabel.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                    widget.item.maxAmount.toString().length,
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
              onPress: amount < widget.item.maxAmount
                  ? (i) => table.changeAmount(
                        widget.item.id,
                        (amount + i).clamp(amount, widget.item.maxAmount),
                      )
                  : null,
              icon: Icons.add,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
