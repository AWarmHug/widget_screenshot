import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'widget_screenshot.dart';

class MergeParam {
  final Color? color;
  final Size size;
  final ShotFormat format;
  final int quality;
  final List<ImageParam> imageParams;

  MergeParam(
      {this.color,
      required this.size,
      required this.format,
      required this.quality,
      required this.imageParams});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (color != null) {
      map["color"] = [color!.alpha, color!.red, color!.green, color!.blue];
    }
    map["width"] = size.width;
    map["height"] = size.height;
    map["format"] = format == ShotFormat.png ? 0 : 1;
    map["quality"] = quality;
    map["imageParams"] = imageParams.map((e) => e.toJson()).toList();
    return map;
  }
}

class ImageParam {
  final Uint8List image;
  final Offset offset;
  final Size size;

  ImageParam({required this.image, required this.offset, required this.size});

  ImageParam.start(Uint8List image, Size size)
      : this(image: image, offset: const Offset(-1, -1), size: size);

  ImageParam.end(Uint8List image, Size size)
      : this(image: image, offset: const Offset(-2, -2), size: size);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["image"] = image;
    map["dx"] = offset.dx;
    map["dy"] = offset.dy;
    map["width"] = size.width;
    map["height"] = size.height;
    return map;
  }
}
