import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widget_screenshot/widget_screenshot.dart';

class ExampleListExtraPage extends StatefulWidget {
  const ExampleListExtraPage({Key? key}) : super(key: key);

  @override
  State<ExampleListExtraPage> createState() => _ExampleListExtraPageState();
}

class _ExampleListExtraPageState extends State<ExampleListExtraPage> {
  GlobalKey _shotHeaderKey = GlobalKey();
  GlobalKey _shotKey = GlobalKey();
  GlobalKey _shotFooterKey = GlobalKey();

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "截图",
        ),
        actions: [
          TextButton(
              onPressed: () async {
                WidgetShotRenderRepaintBoundary headerBoundary =
                    _shotHeaderKey.currentContext!.findRenderObject()
                        as WidgetShotRenderRepaintBoundary;
                var headerImage = await headerBoundary.screenshot(
                    format: ShotFormat.png, pixelRatio: 1);

                if(context.mounted) {
                  WidgetShotRenderRepaintBoundary footerBoundary =
                  _shotFooterKey.currentContext!.findRenderObject()
                          as WidgetShotRenderRepaintBoundary;
                  var footerImage = await footerBoundary.screenshot(
                      format: ShotFormat.png, pixelRatio: 1);

                  var watermark = await loadAssetImage("images/watermark.png");

                  if (context.mounted) {

                    WidgetShotRenderRepaintBoundary repaintBoundary =
                    _shotKey.currentContext!.findRenderObject()
                    as WidgetShotRenderRepaintBoundary;
                    var resultImage = await repaintBoundary.screenshot(
                        scrollController: _scrollController,
                        extraImage: [
                          if (headerImage != null)
                            ImageParam.start(
                                headerImage,
                                _shotHeaderKey.currentContext!.size!),
                          if (footerImage != null)
                            ImageParam.end(
                                footerImage,
                                _shotFooterKey.currentContext!.size!),
                          ImageParam(image: watermark, offset: const Offset(100, 100), size: const Size(200, 80))
                        ],
                        format: ShotFormat.png,
                        backgroundColor: Colors.white,
                        pixelRatio: 1);

                    try {
                      // Map<dynamic, dynamic> result =
                      //     await ImageGallerySaver.saveImage(resultImage!);
                      //
                      // debugPrint("result = ${result}");

                      /// 存储的文件的路径
                      String path = (await getTemporaryDirectory()).path;
                      path += '/${DateTime.now().toString()}.png';
                      File file = File(path);
                      if (!file.existsSync()) {
                        file.createSync();
                      }
                      await file.writeAsBytes(resultImage!);
                      debugPrint("result = ${file.path}");
                    } catch (error) {
                      /// flutter保存图片到App内存文件夹出错
                      debugPrint("error = ${error}");
                    }
                  }
                }
              },
              child: const Text(
                "Shot",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Column(
        children: [
          WidgetShot(
            key: _shotHeaderKey,
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("TestHeader"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("TestHeader"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("TestHeader"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("TestHeader"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: WidgetShot(
              key: _shotKey,
              child: ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Container(
                      // color: Color.fromARGB(
                      //     Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)),
                      height: 160,
                      child: Center(
                        child: Text(
                          "测试文案测试文案测试文案测试文案 ${index}",
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1,
                      color: Colors.grey,
                    );
                  },
                  itemCount: 6),
            ),
          ),
          WidgetShot(
            key: _shotFooterKey,
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("TestFooter"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("TestFooter"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("TestFooter"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("TestFooter"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<Uint8List> loadAssetImage(String filePath) async {
    final ByteData data = await rootBundle.load(filePath);
    return data.buffer.asUint8List();
  }
}
