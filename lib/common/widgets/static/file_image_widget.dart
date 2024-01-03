// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FileImageWidget extends StatelessWidget {
  final String path;
  final BoxFit fit;

  const FileImageWidget(
    this.path, {
    super.key,
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
            if (snapshot.data != true) return const SizedBox();
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

  const FileImageSafe(
    super.file, {
    this.cacheWidth,
    this.cacheHeight,
  });

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
  ImageStreamCompleter loadBuffer(FileImage key, DecoderBufferCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.file.path,
      informationCollector: () => <DiagnosticsNode>[
        ErrorDescription('Path: ${file.path}'),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    FileImage key,
    DecoderBufferCallback decode,
  ) async {
    assert(key == this);

    if (!await file.exists()) {
      const empty = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs'
          '4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAANSURBVBhXY2'
          'BgYGAAAAAFAAGKM+MAAAAAAElFTkSuQmCC';
      final buffer = await ImmutableBuffer.fromUint8List(base64Decode(empty));
      return decode(
        buffer,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }

    final bytes = await file.readAsBytes();

    if (bytes.lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError('$file is empty and cannot be loaded as an image.');
    }

    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }
}

extension on Size {
  int? get toCacheWidth =>
      width.isFinite && width >= height ? width.toInt() : null;

  int? get toCacheHeight =>
      height.isFinite && height >= width ? height.toInt() : null;
}
