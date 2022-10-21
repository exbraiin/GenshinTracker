import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/utils.dart';
import 'package:tracker/common/widgets/file_image.dart';

const radius = BorderRadius.all(Radius.circular(6));

class ItemCardButton extends StatelessWidget {
  final int? rarity;
  final String label;
  final bool disable;
  final int? maxLines;
  final double? width;
  final double? height;
  final Widget? subChild;
  final Widget? child;
  final String? imageUrlPath;
  final String? imageFilePath;
  final String? imageAssetPath;
  final VoidCallback? onTap;

  ItemCardButton({
    this.onTap,
    this.rarity,
    this.child,
    this.width,
    this.height,
    this.subChild,
    this.maxLines,
    this.imageUrlPath,
    this.imageFilePath,
    this.imageAssetPath,
    this.disable = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap == null) {
      return Opacity(
        opacity: disable ? kDisableOpacity : 1,
        child: _getContent(context, false),
      );
    }

    var animate = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Opacity(
          opacity: disable ? kDisableOpacity : 1,
          child: InkWell(
            onTap: onTap,
            child: MouseRegion(
              onEnter: (event) => setState(() => animate = true),
              onExit: (event) => setState(() => animate = false),
              child: _getContent(context, animate),
            ),
          ),
        );
      },
    );
  }

  Widget _getContent(BuildContext context, bool animate) {
    return AnimatedContainer(
      width: width,
      height: height,
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: GsColors.mainColor2,
        borderRadius: radius,
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: animate
            ? Border.all(
                color: GsColors.almostWhite,
                width: 2,
              )
            : null,
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: radius.copyWith(
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(24),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: GsColors.mainColor0,
                  image: rarity != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            getRarityBgImage(rarity!),
                          ),
                        )
                      : null,
                ),
                child: Stack(
                  children: [
                    if (imageUrlPath != null)
                      Positioned.fill(
                        child: CachedImageWidget(
                          imageUrlPath!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (imageFilePath != null)
                      Positioned.fill(
                        child: FileImageWidget(
                          imageFilePath!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (imageAssetPath != null && imageAssetPath!.isNotEmpty)
                      Positioned.fill(
                        child: Image.asset(
                          imageAssetPath!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (child != null) Positioned.fill(child: child!),
                  ],
                ),
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(minHeight: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(4),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Center(
              child: Column(
                children: [
                  if (label.isNotEmpty)
                    Text(
                      label,
                      maxLines: subChild != null ? 1 : (maxLines ?? 2),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.cardLabel,
                    ),
                  if (subChild != null) subChild!,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCardLabel extends StatelessWidget {
  final String? asset;
  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;

  ItemCardLabel({this.asset, this.label, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: GsColors.mainColor0.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.all(kSeparator4),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kSeparator4),
                child: Text(
                  label!,
                  style: context.textTheme.cardLabel,
                ),
              ),
            if (asset != null && asset!.isNotEmpty)
              Image.asset(
                asset!,
                width: 16,
                height: 16,
                fit: BoxFit.contain,
                cacheHeight: 16,
              ),
            if (icon != null)
              Padding(
                padding: EdgeInsets.all(1),
                child: Icon(
                  icon!,
                  color: Colors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
