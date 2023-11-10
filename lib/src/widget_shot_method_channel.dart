import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'merge_param.dart';
import 'widget_shot_platform_interface.dart';

/// An implementation of [WidgetShotPlatform] that uses method channels.
class MethodChannelWidgetShot extends WidgetShotPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('widget_shot');

  @override
  Future<Uint8List?> mergeToMemory(MergeParam mergeParam) async {
    final image = await methodChannel.invokeMethod<Uint8List>(
        "merge", mergeParam.toJson());
    return image;
  }
}
