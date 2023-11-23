import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';

class CachedImageWidget extends StatelessWidget {
  static String _getScaleUrl(String url, Size size, bool scale, double? ratio) {
    late final w = size.toCacheWidth;
    late final h = size.toCacheHeight;
    if (!scale) return url;
    if (!url.startsWith('https://static.wikia.')) return url;
    if (w != null) {
      final nw = ((ratio ?? 0) > 0 ? w * ratio! : w).toInt();
      return '$url/revision/latest/scale-to-width-down/$nw';
    }
    if (h != null) {
      final nh = ((ratio ?? 0) > 0 ? h * ratio! : h).toInt();
      return '$url/revision/latest/scale-to-width-down/$nh';
    }
    // TODO: Fandom return weird image if scaled to height...
    // if (h != null) return '$url/revision/latest/scale-to-height-down/$h';
    return url;
  }

  final BoxFit fit;
  final String? imageUrl;
  final Alignment alignment;
  final bool scaleToSize;
  final bool showPlaceholder;
  final double? imageAspectRatio;

  const CachedImageWidget(
    this.imageUrl, {
    super.key,
    this.scaleToSize = true,
    this.showPlaceholder = true,
    this.imageAspectRatio,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return showPlaceholder ? _placeholderImageWidget() : const SizedBox();
    }
    return LayoutBuilder(
      builder: (context, layout) {
        return CachedNetworkImage(
          imageUrl: _getScaleUrl(
            imageUrl!,
            layout.biggest,
            scaleToSize,
            imageAspectRatio,
          ),
          fit: fit,
          alignment: alignment,
          memCacheWidth: layout.biggest.toCacheWidth,
          memCacheHeight: layout.biggest.toCacheHeight,
          placeholder: showPlaceholder
              ? (context, url) => _placeholderImageWidget()
              : null,
          errorWidget: showPlaceholder
              ? (context, url, error) => _placeholderImageWidget()
              : null,
        );
      },
    );
  }

  Widget _placeholderImageWidget() {
    return Image.asset(
      iconMissing,
      fit: BoxFit.contain,
    );
  }
}

extension on Size {
  int? get toCacheWidth => useW ? width.toInt() : null;
  int? get toCacheHeight => useH ? height.toInt() : null;
  bool get useW => width.isFinite && (width >= height || height.isInfinite);
  bool get useH => height.isFinite && (height >= width || width.isInfinite);
}
