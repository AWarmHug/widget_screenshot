import 'dart:typed_data';

import 'package:flutter/material.dart';


class MergeParam {
  static const int formatPng = 0;
  static const int formatJPEG = 1;

  final Color color;
  final Size size;
  final int format;
  final int quality;
  final List<ImageParam> imageParams;

  MergeParam(
      {this.color = Colors.white,
      required this.size,
      this.format = formatJPEG,
      this.quality = 90,
      required this.imageParams});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["color"] = color.toHex();
    map["width"] = size.width;
    map["height"] = size.height;
    map["format"] = format;
    map["quality"] = quality;
    map["imageParams"] = imageParams.map((e) => e.toJson()).toList();
    return map;
  }
}

class ImageParam {
  final Uint8List image;
  final Offset offset;
  final Size size;

  ImageParam({required this.image, required this.offset,required this.size});

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

extension _HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
