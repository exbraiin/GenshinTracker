import 'package:flutter/material.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/gs_item_details_card.dart';
import 'package:tracker/domain/gs_domain.dart';

class ArtifactDetailsCard extends StatelessWidget {
  final InfoArtifact item;

  const ArtifactDetailsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ItemDetailsCard(
      name: item.name,
      info: (c, p) => Text(item.pieces[p].name),
      image: (c, p) => item.pieces[p].icon,
      rarity: item.rarity,
      pages: item.pieces.length,
      child: (c, p) {
        final texts = <InlineSpan>[];

        final labelStyle = TextStyle(
          fontSize: 16,
          color: Color.lerp(Colors.black, Colors.orange, 0.8)!,
          fontWeight: FontWeight.bold,
        );

        if (item.desc1Pc.isNotEmpty) {
          if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
          final label = context.fromLabel(Labels.nPieceBonus, 1);
          texts.add(TextSpan(text: '$label\n', style: labelStyle));
          texts.add(TextSpan(text: '  \u2022  ${item.desc1Pc}'));
        }
        if (item.desc2Pc.isNotEmpty) {
          if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
          final label = context.fromLabel(Labels.nPieceBonus, 2);
          texts.add(TextSpan(text: '$label\n', style: labelStyle));
          texts.add(TextSpan(text: '  \u2022  ${item.desc2Pc}'));
        }
        if (item.desc4Pc.isNotEmpty) {
          if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
          final label = context.fromLabel(Labels.nPieceBonus, 4);
          texts.add(TextSpan(text: '$label\n', style: labelStyle));
          texts.add(TextSpan(text: '  \u2022  ${item.desc4Pc}'));
        }

        if (item.pieces[p].desc.isNotEmpty) {
          if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
          final style = TextStyle(color: Colors.grey[600]);
          texts.add(TextSpan(text: item.pieces[p].desc, style: style));
        }

        if (item.domain.isNotEmpty) {
          if (texts.isNotEmpty) texts.add(const TextSpan(text: '\n\n'));
          final label = context.fromLabel(Labels.source);
          texts.add(TextSpan(text: '$label\n', style: labelStyle));
          texts.add(TextSpan(text: '  \u2022  ${item.domain}'));
        }

        return Text.rich(TextSpan(children: texts));
      },
    );
  }
}
