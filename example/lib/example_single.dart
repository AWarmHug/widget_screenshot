import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widget_screenshot/widget_screenshot.dart';

class ExampleSinglePage extends StatefulWidget {
  const ExampleSinglePage({Key? key}) : super(key: key);

  @override
  State<ExampleSinglePage> createState() => _ExampleSinglePageState();
}

class _ExampleSinglePageState extends State<ExampleSinglePage> {
  GlobalKey _shotKey = GlobalKey();

  bool _visiable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ExampleSinglePage",
        ),
        actions: [
          TextButton(
              onPressed: () async {
                  WidgetShotRenderRepaintBoundary repaintBoundary =
                      _shotKey.currentContext!.findRenderObject()
                          as WidgetShotRenderRepaintBoundary;
                  var resultImage = await repaintBoundary.screenshot(
                      // backgroundColor: Colors.amberAccent,
                      format: ShotFormat.png,
                      pixelRatio: 1);

                  try {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
                visible: _visiable,
                child: const SizedBox(
                  height: 160,
                  child: Center(
                    child: Text(
                      "I am Header",
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                )),
            SizedBox(
              height: 160,
              child: Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _visiable = !_visiable;
                    });
                  },
                  child: const Text(
                    "Click",
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: _visiable,
                child: const SizedBox(
                  height: 160,
                  child: Center(
                    child: Text(
                      "I am Footer",
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
