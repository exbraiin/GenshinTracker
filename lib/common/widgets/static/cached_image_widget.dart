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
  final bool scaleToWidth;
  final bool showPlaceholder;

  const CachedImageWidget(
    this.imageUrl, {
    super.key,
    this.scaleToWidth = true,
    this.showPlaceholder = true,
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
          imageUrl: scaleToWidth
              ? _getScaleUrl(imageUrl!, layout.biggest.toCacheWidth)
              : imageUrl!,
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
  int? get toCacheWidth =>
      width.isFinite && width >= height ? width.toInt() : null;

  int? get toCacheHeight =>
      height.isFinite && height >= width ? height.toInt() : null;
}
