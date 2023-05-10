import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_shot/widget_shot_method_channel.dart';

void main() {
  MethodChannelWidgetShot platform = MethodChannelWidgetShot();
  const MethodChannel channel = MethodChannel('widget_shot');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
