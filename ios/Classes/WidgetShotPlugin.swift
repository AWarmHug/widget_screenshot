import Flutter
import UIKit

public class WidgetShotPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        // https://github.com/flutter/flutter/issues/118832
//        let taskQueue = registrar.messenger.makeBackgroundTaskQueue()
//        let channel = FlutterMethodChannel(name: "widget_shot",
//                                           binaryMessenger: registrar.messenger(),
//                                           codec: FlutterStandardMethodCodec.sharedInstance(),
//                                           taskQueue: taskQueue)
        let channel = FlutterMethodChannel(name: "widget_shot", binaryMessenger: registrar.messenger())
        let instance = WidgetShotPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "merge" {
            let arguments = call.arguments
            if arguments != nil {
                result(Merger(param: arguments! as! [String: Any]).merge())
            } else {
                result(nil)
            }
        }
        result(FlutterMethodNotImplemented)
    }
}
