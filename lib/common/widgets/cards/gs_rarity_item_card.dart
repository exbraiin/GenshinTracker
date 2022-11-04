import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/hover_detector.dart';

class GsRarityItemCard extends StatelessWidget {
  final int rarity;
  final double size;
  final String image;
  final VoidCallback? onTap;
  final Widget? header;
  final Widget? footer;
  final BoxFit fit;

  GsRarityItemCard({
    this.size = 64,
    this.image = '',
    this.rarity = 1,
    this.onTap,
    this.header,
    this.footer,
    this.fit = BoxFit.contain,
  });

  GsRarityItemCard.withLabels({
    this.size = 64,
    this.image = '',
    this.rarity = 1,
    this.onTap,
    this.fit = BoxFit.contain,
    String labelHeader = '',
    String labelFooter = '',
  })  : header = labelHeader.isEmpty
            ? null
            : Text(
                labelHeader,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
        footer = labelFooter.isEmpty
            ? null
            : Text(
                labelFooter,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white, fontSize: 10),
              );

  @override
  Widget build(BuildContext context) {
    final radius = kMainRadius.copyWith(bottomRight: Radius.circular(size / 4));
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(getRarityBgImage(rarity)),
            fit: BoxFit.cover,
          ),
        ),
        child: HoverDetector(
          onTap: onTap,
          child: _getChild(),
          decoration: (h) => BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              width: 1.2,
              color: h ? GsColors.almostWhite : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getChild() {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedImageWidget(image, fit: fit),
        ),
        if (header != null)
          Positioned.fill(
            bottom: null,
            child: Container(
              color: GsColors.mainColor1.withOpacity(0.6),
              padding: EdgeInsets.all(2),
              child: Center(child: header),
            ),
          ),
        if (footer != null)
          Positioned.fill(
            top: null,
            child: Container(
              color: GsColors.mainColor1.withOpacity(0.6),
              padding: EdgeInsets.all(2),
              child: Center(child: footer),
            ),
          ),
      ],
    );
  }
}
