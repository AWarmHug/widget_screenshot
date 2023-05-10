import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';

import 'image_merger.dart';
import 'merge_param.dart';

class WidgetShot extends SingleChildRenderObjectWidget {
  const WidgetShot({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      WidgetShotRenderRepaintBoundary();
}

class WidgetShotRenderRepaintBoundary extends RenderRepaintBoundary {
  WidgetShotRenderRepaintBoundary();

  Future<Uint8List?> screenshot(
      {ScrollController? scrollController,
      int maxHeight = 10000,
      bool animate = false,
      double? pixelRatio,
      bool resetOffset = false}) async {
    pixelRatio ??= window.devicePixelRatio;

    Uint8List? resultImage;

    if (scrollController != null &&
        (scrollController.position.maxScrollExtent) > 0) {
      double scrollOffset = scrollController.offset;

      List<ImageParam> imageParams = [];

      int imageWidth = 0;
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
            lastImageHeight = scrollController.position.maxScrollExtent +
                sHeight -
                sHeight * i;

            if (!animate) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
              await Future.delayed(const Duration(milliseconds: 25));
            } else {
              await scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            }

            Uint8List lastimage = await _screenshot(pixelRatio);

            imageParams.add(ImageParam(
              image: lastimage,
              offset: Offset(0,
                  imageHeight - ((size.height - lastImageHeight) * pixelRatio)),
              size: size * pixelRatio,
            ));

            imageHeight += lastImageHeight * pixelRatio;
          } else if (scrollHeight > sHeight * i) {
            if (!animate) {
              scrollController.jumpTo(sHeight * i);
              await Future.delayed(const Duration(milliseconds: 25));
            } else {
              await scrollController.animateTo(sHeight * i,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            }
            i++;

            Uint8List image = await _screenshot(pixelRatio);

            imageParams.add(ImageParam(
              image: image,
              offset: Offset(0, imageHeight),
              size: size * pixelRatio,
            ));
            imageHeight += sHeight * pixelRatio;
          } else {
            if (!animate) {
              scrollController.jumpTo(scrollHeight);
              await Future.delayed(const Duration(milliseconds: 25));
            } else {
              await scrollController.animateTo(scrollHeight,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            }
          }
        } else {
          break;
        }
      }

      final mergeParam = MergeParam(
        size: Size(size.width * pixelRatio, imageHeight),
        imageParams: imageParams,
      );

      resultImage = await ImageMerger.merge(mergeParam);

      if (resetOffset) {
        scrollController.jumpTo(scrollOffset);
      }
    } else {
      resultImage = await _screenshot(pixelRatio);
    }
    return resultImage;
  }

  bool canScroll(ScrollController scrollController) {
    double maxScrollExtent = scrollController.position.maxScrollExtent;
    double offset = scrollController.offset;
    return !nearEqual(maxScrollExtent, offset,
        scrollController.position.physics.tolerance.distance);
  }

  Future<Uint8List> _screenshot(double pixelRatio) async {
    ui.Image image = await toImage(pixelRatio: pixelRatio);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData!.buffer.asUint8List();
    return Future.value(uint8list);
  }
}
