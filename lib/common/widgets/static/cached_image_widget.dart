import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tracker/common/graphics/gs_style.dart';

class CachedImageWidget extends StatelessWidget {
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
    late final placeholder = _placeholderImageWidget();
    if (imageUrl == null || imageUrl!.isEmpty) {
      return showPlaceholder ? placeholder : const SizedBox();
    }
    return LayoutBuilder(
      builder: (context, layout) {
        return CachedNetworkImage(
          imageUrl: _getScaleUrl(layout.biggest),
          fit: fit,
          alignment: alignment,
          // memCacheWidth: layout.biggest.toCacheWidth,
          // memCacheHeight: layout.biggest.toCacheHeight,
          placeholder: showPlaceholder ? (ctx, url) => placeholder : null,
          errorWidget: showPlaceholder ? (ctx, url, err) => placeholder : null,
        );
      },
    );
  }

  String _getScaleUrl(Size size) {
    final url = imageUrl ?? '';
    if (!scaleToSize) return url;
    if (!url.startsWith('https://static.wikia.')) return url;
    final s = size.toCacheScale;
    if (s == null) return url;
    final ratio = imageAspectRatio ?? 0;
    final ns = (ratio > 0 ? s * ratio : s).toInt();
    return '$url/revision/latest/scale-to-width-down/$ns';
  }

  Widget _placeholderImageWidget() {
    return Image.asset(
      iconMissing,
      fit: BoxFit.contain,
    );
  }
}

extension on Size {
  int? get toCacheScale => toCacheWidth ?? toCacheHeight;
  int? get toCacheWidth => useW ? width.toInt() : null;
  int? get toCacheHeight => useH ? height.toInt() : null;
  bool get useW => width.isFinite && (width >= height || height.isInfinite);
  bool get useH => height.isFinite && (height >= width || width.isInfinite);
}
