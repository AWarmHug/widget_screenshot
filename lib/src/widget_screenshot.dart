import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';

import 'image_merger.dart';
import 'merge_param.dart';

enum ShotFormat { png, jpeg }

class WidgetShot extends SingleChildRenderObjectWidget {
  const WidgetShot({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => WidgetShotRenderRepaintBoundary(context);
}

class WidgetShotRenderRepaintBoundary extends RenderRepaintBoundary {
  BuildContext context;

  WidgetShotRenderRepaintBoundary(this.context);

  /// [scrollController] is child's scrollController, if child is [ScrollView]
  /// The resultImage's [pixelRatio] default [View.of(context).devicePixelRatio]
  /// some child has no background, [backgroundColor] to set backgroundColor default [Colors.white
  /// set format by [format] support png or jpeg
  /// set [quality] 0~100, if [format] is png, [quality] is useless
  /// support merge [extraImage], like header, footer or watermark
  Future<Uint8List?> screenshot({
    ScrollController? scrollController,
    List<ImageParam> extraImage = const [],
    int maxHeight = 10000,
    double? pixelRatio,
    Color? backgroundColor,
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

    double sHeight = scrollController?.position.viewportDimension ?? size.height;

    double imageHeight = 0;

    List<ImageParam> imageParams = [];

    extraImage.where((element) => element.offset == const Offset(-1, -1)).toList(growable: false).forEach((element) {
      imageParams.add(ImageParam(
        image: element.image,
        offset: Offset(0, imageHeight),
        size: element.size,
      ));
      imageHeight += element.size.height;
    });

    bool canScroll = scrollController != null && (scrollController.position.maxScrollExtent) > 0;

    if (canScroll) {
      scrollController.jumpTo(0);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    var firstImage = await _screenshot(pixelRatio);

    imageParams.add(ImageParam(
      image: firstImage,
      offset: Offset(0, imageHeight),
      size: size * pixelRatio,
    ));

    imageHeight += sHeight * pixelRatio;

    if (canScroll) {
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

        if (_canScroll(scrollController)) {
          double scrollHeight = scrollController.offset + sHeight / 10;

          if (scrollHeight > sHeight * i) {
            scrollController.jumpTo(sHeight * i);
            await Future.delayed(const Duration(milliseconds: 16));
            i++;

            Uint8List image = await _screenshot(pixelRatio);

            imageParams.add(ImageParam(
              image: image,
              offset: Offset(0, imageHeight),
              size: size * pixelRatio,
            ));
            imageHeight += sHeight * pixelRatio;
          } else if (scrollHeight > scrollController.position.maxScrollExtent) {
            lastImageHeight = scrollController.position.maxScrollExtent + sHeight - sHeight * i;

            scrollController.jumpTo(scrollController.position.maxScrollExtent);
            await Future.delayed(const Duration(milliseconds: 16));

            Uint8List lastImage = await _screenshot(pixelRatio);

            imageParams.add(ImageParam(
              image: lastImage,
              offset: Offset(0, imageHeight - ((size.height - lastImageHeight) * pixelRatio)),
              size: size * pixelRatio,
            ));

            imageHeight += lastImageHeight * pixelRatio;
          } else {
            scrollController.jumpTo(scrollHeight);
            await Future.delayed(const Duration(milliseconds: 16));
          }
        } else {
          break;
        }
      }
    }

    extraImage.where((element) => element.offset == const Offset(-2, -2)).toList(growable: false).forEach((element) {
      imageParams.add(ImageParam(
        image: element.image,
        offset: Offset(0, imageHeight),
        size: element.size,
      ));
      imageHeight += element.size.height;
    });

    extraImage
        .where((element) => (element.offset != const Offset(-1, -1) && element.offset != const Offset(-2, -2)))
        .toList(growable: false)
        .forEach((element) {
      imageParams.add(ImageParam(
        image: element.image,
        offset: element.offset,
        size: element.size,
      ));
    });

    final mergeParam = MergeParam(
        color: backgroundColor,
        size: Size(size.width * pixelRatio, imageHeight),
        format: format,
        quality: quality,
        imageParams: imageParams);

    resultImage = await _merge(canScroll, mergeParam);

    return resultImage;
  }

  Future<Uint8List?> _merge(bool canScroll, MergeParam mergeParam) async {
    if (canScroll) {
      return ImageMerger.merge(mergeParam);
    } else {
      Paint paint = Paint();
      paint
        ..isAntiAlias = false // 是否抗锯齿
        ..color = Colors.white; // 画笔颜色
      PictureRecorder pictureRecorder = PictureRecorder();
      Canvas canvas = Canvas(pictureRecorder);
      if (mergeParam.color != null) {
        canvas.drawColor(mergeParam.color!, BlendMode.color);
        canvas.save();
      }

      for (var element in mergeParam.imageParams) {
        ui.Image img = await decodeImageFromList(element.image);

        canvas.drawImage(img, element.offset, paint);
      }

      Picture picture = pictureRecorder.endRecording();

      ui.Image rImage = await picture.toImage(mergeParam.size.width.ceil(), mergeParam.size.height.ceil());
      ByteData? byteData = await rImage.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    }
  }

  bool _canScroll(ScrollController? scrollController) {
    if (scrollController == null) {
      return false;
    }
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
