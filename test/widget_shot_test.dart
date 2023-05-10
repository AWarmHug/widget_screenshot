import 'package:flutter_test/flutter_test.dart';
import 'package:widget_shot/widget_shot.dart';
import 'package:widget_shot/widget_shot_platform_interface.dart';
import 'package:widget_shot/widget_shot_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWidgetShotPlatform
    with MockPlatformInterfaceMixin
    implements WidgetShotPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WidgetShotPlatform initialPlatform = WidgetShotPlatform.instance;

  test('$MethodChannelWidgetShot is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWidgetShot>());
  });

  test('getPlatformVersion', () async {
    WidgetShot widgetShotPlugin = WidgetShot();
    MockWidgetShotPlatform fakePlatform = MockWidgetShotPlatform();
    WidgetShotPlatform.instance = fakePlatform;

    expect(await widgetShotPlugin.getPlatformVersion(), '42');
  });
}
