import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';

import 'src/image_merger.dart';
import 'src/merge_param.dart';

enum ShotFormat { png, jpeg }

class WidgetShot extends SingleChildRenderObjectWidget {
  const WidgetShot({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => WidgetShotRenderRepaintBoundary();
}

class WidgetShotRenderRepaintBoundary extends RenderRepaintBoundary {
  WidgetShotRenderRepaintBoundary();

  /// [scrollController] is child's scrollController, if child is [ScrollView]
  /// The resultImage's [pixelRatio] default [ window.devicePixelRatio]
  /// some child has no background, [backgroundColor] to set backgroundColor default [Colors.white
  /// set format by [format] support png or jpeg
  /// set [quality] 0~100, if [format] is png, [quality] is useless
  Future<Uint8List?> screenshot({
    ScrollController? scrollController,
    int maxHeight = 10000,
    double? pixelRatio,
    Color backgroundColor = Colors.white,
    ShotFormat format = ShotFormat.png,
    int quality = 100,
  }) async {
    pixelRatio ??= window.devicePixelRatio;
    if (quality > 100) {
      quality = 100;
    }
    if (quality < 0) {
      quality = 10;
    }
    Uint8List? resultImage;

    if (scrollController != null && (scrollController.position.maxScrollExtent) > 0) {
      List<ImageParam> imageParams = [];
      double imageHeight = 0;

      scrollController.jumpTo(0);
      await Future.delayed(const Duration(milliseconds: 200));

      double sHeight = size.height;

      var firstImage = await _screenshot(pixelRatio);

      imageParams.add(ImageParam(
        image: firstImage,
        offset: Offset(0, imageHeight),
        size: size * pixelRatio,
      ));

      imageHeight += sHeight * pixelRatio;

      assert(() {
        scrollController.addListener(() {
          debugPrint(
              "WidgetShot scrollController.offser = ${scrollController.offset} , scrollController.position.maxScrollExtent = ${scrollController.position.maxScrollExtent}");
        });
        return true;
      }());

      int i = 1;

      while (true) {
        if (imageHeight >= maxHeight * pixelRatio) {
          break;
        }

        double lastImageHeight = 0;

        if (canScroll(scrollController)) {
          double scrollHeight = scrollController.offset + sHeight / 10;

          if (scrollHeight > scrollController.position.maxScrollExtent) {
            lastImageHeight = scrollController.position.maxScrollExtent + sHeight - sHeight * i;

            scrollController.jumpTo(scrollController.position.maxScrollExtent);
            await Future.delayed(const Duration(milliseconds: 25));

            Uint8List lastImage = await _screenshot(pixelRatio);

            imageParams.add(ImageParam(
              image: lastImage,
              offset: Offset(0, imageHeight - ((size.height - lastImageHeight) * pixelRatio)),
              size: size * pixelRatio,
            ));

            imageHeight += lastImageHeight * pixelRatio;
          } else if (scrollHeight > sHeight * i) {
            scrollController.jumpTo(sHeight * i);
            await Future.delayed(const Duration(milliseconds: 25));
            i++;

            Uint8List image = await _screenshot(pixelRatio);

            imageParams.add(ImageParam(
              image: image,
              offset: Offset(0, imageHeight),
              size: size * pixelRatio,
            ));
            imageHeight += sHeight * pixelRatio;
          } else {
            scrollController.jumpTo(scrollHeight);
            await Future.delayed(const Duration(milliseconds: 25));
          }
        } else {
          break;
        }
      }

      final mergeParam = MergeParam(
        color: backgroundColor,
        size: Size(size.width * pixelRatio, imageHeight),
        format: format == ShotFormat.png ? MergeParam.formatPng : MergeParam.formatJPEG,
        quality: quality,
        imageParams: imageParams,
      );

      resultImage = await ImageMerger.merge(mergeParam);
    } else {
      resultImage = await _screenshot(pixelRatio);
    }
    return resultImage;
  }

  bool canScroll(ScrollController scrollController) {
    double maxScrollExtent = scrollController.position.maxScrollExtent;
    double offset = scrollController.offset;
    return !nearEqual(maxScrollExtent, offset, scrollController.position.physics.tolerance.distance);
  }

  Future<Uint8List> _screenshot(double pixelRatio) async {
    ui.Image image = await toImage(pixelRatio: pixelRatio);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData!.buffer.asUint8List();
    return Future.value(uint8list);
  }
}
