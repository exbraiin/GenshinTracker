import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';
import 'package:tracker/common/lang/lang.dart';
import 'package:tracker/common/widgets/static/cached_image_widget.dart';
import 'package:tracker/domain/gs_database.dart';

const radius = BorderRadius.all(Radius.circular(6));

class GsItemBanner {
  final String text;
  final Color color;
  final BannerLocation location;

  const GsItemBanner({
    required this.text,
    this.color = Colors.cyan,
    this.location = BannerLocation.topEnd,
  });

  factory GsItemBanner.fromVersion(BuildContext context, String version) {
    if (GsUtils.versions.isUpcomingVersion(version)) {
      return GsItemBanner(
        text: context.labels.itemUpcoming(),
        color: Colors.orange,
      );
    }
    if (GsUtils.versions.isCurrentVersion(version)) {
      return GsItemBanner(
        text: context.labels.itemNew(),
        color: Colors.lightBlue,
      );
    }
    return const GsItemBanner(text: '');
  }
}

class GsItemCardButton extends StatelessWidget {
  final int? rarity;
  final String label;
  final Color? imageColor;
  final GsItemBanner banner;
  final bool shadow;
  final bool disable;
  final bool selected;
  final int? maxLines;
  final double? width;
  final double? height;
  final Widget? subChild;
  final Widget? child;
  final String? imageUrlPath;
  final String? imageAssetPath;
  final double? imageAspectRatio;
  final VoidCallback? onTap;

  const GsItemCardButton({
    super.key,
    this.onTap,
    this.imageColor,
    this.rarity,
    this.child,
    this.width,
    this.height,
    this.banner = const GsItemBanner(text: ''),
    this.subChild,
    this.maxLines = 1,
    this.imageUrlPath,
    this.imageAssetPath,
    this.imageAspectRatio,
    this.shadow = false,
    this.disable = false,
    this.selected = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final child = Opacity(
      opacity: disable ? kDisableOpacity : 1,
      child: _getContent(context),
    );
    if (onTap == null) return child;

    return InkWell(
      onTap: onTap,
      child: MouseHoverBuilder(
        builder: (context, value, child) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          foregroundDecoration: BoxDecoration(
            borderRadius: radius,
            border: value || selected
                ? Border.all(
                    color: context.themeColors.almostWhite,
                    width: 2,
                  )
                : null,
          ),
          child: child,
        ),
        child: child,
      ),
    );
  }

  Widget _getContent(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        boxShadow: shadow ? kMainShadow : null,
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: context.themeColors.mainColor0,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(24),
                ),
                image: rarity != null
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: imageColor != null
                            ? ColorFilter.mode(imageColor!, BlendMode.modulate)
                            : null,
                        image: AssetImage(
                          GsAssets.getRarityBgImage(rarity!),
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
                        imageAspectRatio: imageAspectRatio,
                      ),
                    ),
                  if (imageAssetPath != null && imageAssetPath!.isNotEmpty)
                    Positioned.fill(
                      child: Image.asset(
                        imageAssetPath!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (banner.text.isNotEmpty)
                    Positioned.fill(
                      child: Banner(
                        color: banner.color,
                        message: banner.text,
                        location: banner.location,
                      ),
                    ),
                  if (child != null) Positioned.fill(child: child!),
                ],
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 24),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Center(
              child: Column(
                children: [
                  if (label.isNotEmpty)
                    Text(
                      label,
                      maxLines: subChild != null ? 1 : (maxLines ?? 2),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: context.themeStyles.fgLabel12b,
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

class GsItemCardLabel extends StatelessWidget {
  final String? asset;
  final String? label;
  final Widget? child;
  final IconData? icon;
  final Color Function(BuildContext c)? fgColor;
  final Color Function(BuildContext c)? bgColor;
  final VoidCallback? onTap;

  const GsItemCardLabel({
    super.key,
    this.asset,
    this.label,
    this.child,
    this.icon,
    this.onTap,
    this.fgColor,
    this.bgColor,
  });

  GsItemCardLabel.chip({
    super.key,
    this.asset,
    this.label,
    this.child,
    this.icon,
    this.onTap,
    Color? fgColor,
    Color? bgColor,
  })  : fgColor = ((c) => fgColor ?? c.themeColors.almostWhite),
        bgColor = ((c) => bgColor ?? c.themeColors.mainColor1);

  @override
  Widget build(BuildContext context) {
    late final dBgColor = context.themeColors.mainColor0.withOpacity(0.6);
    final fgColor = this.fgColor?.call(context) ?? Colors.white;
    final bgColor = this.bgColor?.call(context) ?? dBgColor;
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSeparator4),
            child: Text(
              label!,
              maxLines: 1,
              style: context.themeStyles.label12n.copyWith(color: fgColor),
            ),
          ),
        if (this.child != null) this.child!,
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
            padding: const EdgeInsets.all(1),
            child: Icon(
              icon!,
              color: fgColor,
              size: 14,
            ),
          ),
      ],
    );

    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(kSeparator4),
      child: onTap != null ? InkWell(onTap: onTap, child: child) : child,
    );
  }
}

class MouseHoverBuilder extends StatefulWidget {
  final Widget? child;
  final ValueWidgetBuilder<bool> builder;

  const MouseHoverBuilder({
    super.key,
    this.child,
    required this.builder,
  });

  @override
  State<MouseHoverBuilder> createState() => _MouseHoverBuilderState();
}

class _MouseHoverBuilderState extends State<MouseHoverBuilder> {
  var _animate = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _animate = true),
      onExit: (event) => setState(() => _animate = false),
      child: widget.builder(context, _animate, widget.child),
    );
  }
}
