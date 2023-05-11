import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widget_screenshot/widget_screenshot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                    backgroundColor: Colors.blue,
                    format: ShotFormat.png,
                    quality: 10,
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
            itemCount: 30),
      ),
    );
  }
}
