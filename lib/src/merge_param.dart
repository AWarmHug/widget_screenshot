import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'widget_screenshot.dart';

class MergeParam {
  final Color? color;
  final Size size;
  final ShotFormat format;
  final int quality;
  final List<ImageParam> imageParams;

  MergeParam({this.color, required this.size, required this.format, required this.quality, required this.imageParams});

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
  final Rect rect;

  ImageParam({required this.image, required this.offset, required this.rect});

  ImageParam.start(Uint8List image, Rect rect) : this(image: image, offset: const Offset(-1, -1), rect: rect);

  ImageParam.end(Uint8List image, Rect rect) : this(image: image, offset: const Offset(-2, -2), rect: rect);


  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["image"] = image;
    map["dx"] = offset.dx;
    map["dy"] = offset.dy;
    map["rect"] = [rect.left, rect.top, rect.right, rect.bottom];
    return map;
  }
}
