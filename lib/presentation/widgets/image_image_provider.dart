import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class ImageImageProvider extends ImageProvider<ImageImageProvider> {
  ImageImageProvider({required this.image});

  final ui.Image image;

  @override
  Future<ImageImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<ImageImageProvider>(this);

  @override
  ImageStreamCompleter load(ImageImageProvider key, DecoderCallback decode) =>
      OneFrameImageStreamCompleter(
        Future.value(ImageInfo(image: image.clone())),
      );

  @override
  ImageStreamCompleter loadBuffer(
    ImageImageProvider key,
    DecoderBufferCallback decode,
  ) =>
      OneFrameImageStreamCompleter(
        Future.value(ImageInfo(image: image.clone())),
      );

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ImageImageProvider && other.image == image;
  }

  @override
  int get hashCode => image.hashCode;
}
