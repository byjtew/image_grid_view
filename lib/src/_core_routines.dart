import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as imglib;

abstract class CoreRoutines {
  static imglib.Image decodeImage(Uint8List bytes) {
    var img = imglib.decodeImage(bytes);
    if (img == null) throw Exception('Failed to decode image');
    return img;
  }

  static List<Uint8List> scaleAndCropTaskWorkflow(
      ScaleAndCropTaskParameters params) {
    List<Uint8List> crops = [];
    late final imglib.Image resizedImage;

    // Resize the image to the desired size if necessary
    if (params.source.width < params.width &&
        params.source.height < params.height) {
      resizedImage = params.source;
    } else {
      resizedImage = imglib.copyResize(params.source,
          width: params.width.round(), height: params.height.round());
    }

    List<int> widthsPerColumn = List.filled(params.horizontalCount, 0);
    List<int> heightsPerRow = List.filled(params.verticalCount, 0);
    int widthRest = resizedImage.width % params.horizontalCount;
    int heightRest = resizedImage.height % params.verticalCount;
    for (int i = 0; i < params.horizontalCount; i++) {
      widthsPerColumn[i] = resizedImage.width ~/ params.horizontalCount +
          (i < widthRest ? 1 : 0);
    }
    for (int i = 0; i < params.verticalCount; i++) {
      heightsPerRow[i] = resizedImage.height ~/ params.verticalCount +
          (i < heightRest ? 1 : 0);
    }

    for (int y = 0; y < params.verticalCount; y++) {
      int height = heightsPerRow[y];
      int yOffset = y * height;
      for (int x = 0; x < params.horizontalCount; x++) {
        int width = widthsPerColumn[x];
        int xOffset = x * width;
        imglib.Image image =
            imglib.copyCrop(resizedImage, xOffset, yOffset, width, height);
        crops.add(Uint8List.fromList(
            imglib.encodeJpg(image, quality: params.quality)));
      }
    }

    return crops;
  }
}

@immutable
class ScaleAndCropTaskParameters {
  final imglib.Image source;
  final double width, height;
  final int horizontalCount, verticalCount;
  final int quality;

  const ScaleAndCropTaskParameters(this.source, this.width, this.height,
      this.horizontalCount, this.verticalCount, this.quality);
}
