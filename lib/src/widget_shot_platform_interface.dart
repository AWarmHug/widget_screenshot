import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'merge_param.dart';
import 'widget_shot_method_channel.dart';

abstract class WidgetShotPlatform extends PlatformInterface {
  /// Constructs a WidgetShotPlatform.
  WidgetShotPlatform() : super(token: _token);

  static final Object _token = Object();

  static WidgetShotPlatform _instance = MethodChannelWidgetShot();

  /// The default instance of [WidgetShotPlatform] to use.
  ///
  /// Defaults to [MethodChannelWidgetShot].
  static WidgetShotPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WidgetShotPlatform] when
  /// they register themselves.
  static set instance(WidgetShotPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Uint8List?> mergeToMemory(MergeParam mergeParam) {
    throw UnimplementedError('mergeToMemory() has not been implemented.');
  }
}
