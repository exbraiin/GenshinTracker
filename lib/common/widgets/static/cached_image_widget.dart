import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';

class CachedImageWidget extends StatelessWidget {
  static String _getScaleUrl(String url, int? w) {
    if (w == null || !url.startsWith('https://static.wikia.')) return url;
    return '$url/revision/latest/scale-to-width-down/$w';
  }

  final BoxFit fit;
  final String? imageUrl;
  final Alignment alignment;

  const CachedImageWidget(
    this.imageUrl, {
    super.key,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Image.asset(
        iconMissing,
        fit: BoxFit.contain,
      );
    }
    return LayoutBuilder(
      builder: (context, layout) {
        return CachedNetworkImage(
          imageUrl: _getScaleUrl(imageUrl!, layout.biggest.toCacheWidth),
          fit: fit,
          alignment: alignment,
          memCacheWidth: layout.biggest.toCacheWidth,
          memCacheHeight: layout.biggest.toCacheHeight,
          placeholder: (context, url) {
            return Image.asset(
              iconMissing,
              fit: BoxFit.contain,
            );
          },
          errorWidget: (context, url, error) {
            return Image.asset(
              iconMissing,
              fit: BoxFit.contain,
            );
          },
        );
      },
    );
  }
}

extension on Size {
  int? get toCacheWidth =>
      width.isFinite && width >= height ? width.toInt() : null;

  int? get toCacheHeight =>
      height.isFinite && height >= width ? height.toInt() : null;
}
