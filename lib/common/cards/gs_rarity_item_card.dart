import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/file_image.dart';

class GsRarityItemCard extends StatelessWidget {
  final int rarity;
  final double size;
  final String image;

  GsRarityItemCard({
    this.size = 64,
    this.image = '',
    this.rarity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: kMainRadius.copyWith(
          bottomRight: Radius.circular(size / 4),
        ),
        image: DecorationImage(
          image: AssetImage(getRarityBgImage(rarity)),
          fit: BoxFit.contain,
        ),
      ),
      child: ClipRRect(
        borderRadius: kMainRadius.copyWith(
          bottomRight: Radius.circular(size / 4),
        ),
        child: CachedImageWidget(image),
      ),
    );
  }
}
