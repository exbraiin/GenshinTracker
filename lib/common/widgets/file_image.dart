// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

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

class FileImageWidget extends StatelessWidget {
  final String path;
  final BoxFit fit;

  const FileImageWidget(
    this.path, {
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder(
          key: ValueKey(path),
          future: file.exists(),
          builder: (context, snapshot) {
            if (snapshot.data != true) return SizedBox();
            return Image.file(
              file,
              fit: fit,
              isAntiAlias: true,
              filterQuality: FilterQuality.high,
              cacheWidth: constraints.biggest.toCacheWidth,
              cacheHeight: constraints.biggest.toCacheHeight,
            );
          },
        );
      },
    );
  }
}

class FileImageSafe extends FileImage {
  final int? cacheWidth;
  final int? cacheHeight;
  FileImageSafe(
    File file, {
    this.cacheWidth,
    this.cacheHeight,
  }) : super(file);

  factory FileImageSafe.path(
    String path, {
    int? cacheWidth,
    int? cacheHeight,
  }) =>
      FileImageSafe(
        File(path),
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );

  @override
  ImageStreamCompleter load(FileImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.file.path,
      informationCollector: () => <DiagnosticsNode>[
        ErrorDescription('Path: ${file.path}'),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(FileImage key, DecoderCallback decode) async {
    assert(key == this);

    if (!await file.exists()) {
      const empty = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs'
          '4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAANSURBVBhXY2'
          'BgYGAAAAAFAAGKM+MAAAAAAElFTkSuQmCC';
      return decode(
        base64Decode(empty),
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }

    final Uint8List bytes = await file.readAsBytes();

    if (bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError('$file is empty and cannot be loaded as an image.');
    }

    return decode(bytes);
  }
}

extension on Size {
  int? get toCacheWidth =>
      width.isFinite && width >= height ? width.toInt() : null;

  int? get toCacheHeight =>
      height.isFinite && height >= width ? height.toInt() : null;
}
