import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/file_image.dart';
import 'package:tracker/domain/gs_database.dart';

class CharacterAscensionMaterial extends StatefulWidget {
  final String id;
  final int amount;

  CharacterAscensionMaterial(this.id, this.amount);

  @override
  State<CharacterAscensionMaterial> createState() =>
      _CharacterAscensionMaterialState();
}

class _CharacterAscensionMaterialState
    extends State<CharacterAscensionMaterial> {
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
      final amount = db.getItemOrNull(widget.id)?.amount;
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
    const radius = BorderRadius.all(Radius.circular(6));
    final im = GsDatabase.instance.infoMaterials;
    final material = im.getItemOrNull(widget.id);
    final db = GsDatabase.instance.saveMaterials;
    final owned = db.getItemOrNull(widget.id)?.amount ?? 0;
    final craftable = db.getCraftableAmount(widget.id);
    return Container(
      width: 64,
      height: 64 + 24,
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: GsColors.mainColor0, width: 2),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: GsColors.mainColor0,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(getRarityBgImage(material?.rarity ?? 1)),
                ),
              ),
            ),
            Container(
              width: 64,
              height: 64,
              child: CachedImageWidget(
                material?.image,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 24,
                color: GsColors.mainColor0,
                child: Center(
                  child: TextFormField(
                    controller: _controller,
                    enabled: material != null,
                    focusNode: _node,
                    onEditingComplete: material != null
                        ? () {
                            _node.unfocus();
                            final amount = int.tryParse(_controller.text) ?? 0;
                            GsDatabase.instance.saveMaterials
                                .changeAmount(widget.id, amount);
                          }
                        : null,
                    style: context.textTheme.infoLabel.copyWith(fontSize: 14),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                        (material?.maxAmount ?? 0).toString().length,
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
              ),
            ),
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
                        text: widget.amount.format(),
                        style: context.textTheme.infoLabel.copyWith(
                          fontSize: 12,
                          color: owned + craftable >= widget.amount
                              ? Colors.lightGreen
                              : Colors.deepOrange,
                        ),
                      ),
                      if (owned < widget.amount && craftable > 0)
                        TextSpan(
                          text:
                              '\n+${(widget.amount - owned).clamp(0, craftable)}',
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
      ),
    );
  }
}
