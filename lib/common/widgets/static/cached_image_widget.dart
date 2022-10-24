import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  static String _getScaleUrl(String url, int? w) {
    if (w == null || !url.startsWith('https://static.wikia.')) return url;
    return '$url/revision/latest/scale-to-width-down/$w';
  }

  final BoxFit fit;
  final String? imageUrl;
  final Alignment alignment;

  CachedImageWidget(
    this.imageUrl, {
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return SizedBox();
    }
    return LayoutBuilder(
      builder: (context, layout) {
        return CachedNetworkImage(
          imageUrl: _getScaleUrl(imageUrl!, layout.biggest.toCacheWidth),
          fit: fit,
          alignment: alignment,
          memCacheWidth: layout.biggest.toCacheWidth,
          memCacheHeight: layout.biggest.toCacheHeight,
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
