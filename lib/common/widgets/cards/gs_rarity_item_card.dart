import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/common/widgets/static/hover_detector.dart';
import 'package:tracker/theme/theme.dart';

class GsRarityItemCard extends StatelessWidget {
  final int rarity;
  final double size;
  final String asset;
  final String image;
  final VoidCallback? onTap;
  final Widget? header;
  final Widget? footer;
  final BoxFit fit;

  const GsRarityItemCard({
    super.key,
    this.size = 64,
    this.asset = '',
    this.image = '',
    this.rarity = 1,
    this.onTap,
    this.header,
    this.footer,
    this.fit = BoxFit.contain,
  });

  GsRarityItemCard.withLabels({
    super.key,
    this.size = 64,
    this.asset = '',
    this.image = '',
    this.rarity = 1,
    this.onTap,
    this.fit = BoxFit.contain,
    String labelHeader = '',
    String labelFooter = '',
  })  : header = labelHeader.isEmpty ? null : Text(labelHeader),
        footer = labelFooter.isEmpty ? null : Text(labelFooter);

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
          child: _getChild(context),
          decoration: ({bool hover = false}) => BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              width: 1.2,
              color:
                  hover ? context.themeColors.almostWhite : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getChild(BuildContext context) {
    return Stack(
      children: [
        if (asset.isNotEmpty)
          Positioned.fill(
            child: Image.asset(asset, fit: fit),
          ),
        if (image.isNotEmpty)
          Positioned.fill(
            child: CachedImageWidget(image, fit: fit),
          ),
        if (header != null)
          Positioned.fill(
            bottom: null,
            child: Container(
              color: context.themeColors.mainColor1.withOpacity(0.6),
              padding: const EdgeInsets.all(2),
              child: DefaultTextStyle(
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: const TextStyle(fontSize: 10, color: Colors.white),
                child: Center(child: header),
              ),
            ),
          ),
        if (footer != null)
          Positioned.fill(
            top: null,
            child: Container(
              color: context.themeColors.mainColor1.withOpacity(0.6),
              padding: const EdgeInsets.all(2),
              child: DefaultTextStyle(
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: const TextStyle(fontSize: 10, color: Colors.white),
                child: Center(child: footer),
              ),
            ),
          ),
      ],
    );
  }
}
