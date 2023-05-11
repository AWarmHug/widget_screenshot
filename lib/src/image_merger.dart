import 'package:flutter/foundation.dart';

import 'merge_param.dart';
import 'widget_shot_platform_interface.dart';

class ImageMerger {
  static Future<Uint8List?> merge(MergeParam mergeParam) {
    return WidgetShotPlatform.instance.mergeToMemory(mergeParam);
  }
}
