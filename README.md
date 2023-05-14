# widget_screenshot

Widget截屏，支持长截图，如：ListView  

Screenshot for widget，support long screenshot like ListView,   

## Support 
* backgroundColor
* format (png, jpeg)
* quality (0~100)
* extraImage (like header, footer or watermark)

## Usage 

```yaml
dependencies:
  widget_screenshot:x.y.z
```

```dart
// Like RepaintBoundary
WidgetShot(
        key: _shotKey,
        child: ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, index) {
              return Container(
                color: Color.fromARGB(
                    Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)),
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
      )
```

```dart
WidgetShotRenderRepaintBoundary repaintBoundary =
    _shotKey.currentContext!.findRenderObject() as WidgetShotRenderRepaintBoundary;
//
var resultImage = await repaintBoundary.screenshot(scrollController: _scrollController,pixelRatio: 1);
```

## Display

<div align="center">
<img src="https://raw.githubusercontent.com/AWarmHug/widget_screenshot/main/display/shot.webp" width="20%" align="top">
shoting->
<img src="https://raw.githubusercontent.com/AWarmHug/widget_screenshot/main/display/shoting.gif" width="20%" align="top">
result->
<img src="https://raw.githubusercontent.com/AWarmHug/widget_screenshot/main/display/shoted.webp" width="20%" align="top">

</div>
