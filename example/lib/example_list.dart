import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widget_screenshot/widget_screenshot.dart';

class ExampleListPage extends StatefulWidget {
  const ExampleListPage({Key? key}) : super(key: key);

  @override
  State<ExampleListPage> createState() => _ExampleListPageState();
}

class _ExampleListPageState extends State<ExampleListPage> {
  GlobalKey _shotKey = GlobalKey();

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
                WidgetShotRenderRepaintBoundary repaintBoundary =
                    _shotKey.currentContext!.findRenderObject() as WidgetShotRenderRepaintBoundary;
                var resultImage = await repaintBoundary.screenshot(
                    scrollController: _scrollController,
                    backgroundColor: Colors.white,
                    format: ShotFormat.png,
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
              },
              child: const Text(
                "Shot",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: WidgetShot(
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
            itemCount: 100),
      ),
    );
  }
}
