//
//  Merger.swift
//  widget_shot
//
//  Created by bingo on 2023/5/9.
//

import Flutter
import Foundation

class Merger {
    let FormatPng = 0
    let FormatJPEG = 1

    var mergeParam: MergeParam
    init(param: [String: Any]) {
        let color = param["color"] as! String

        let width = (param["width"] as! NSNumber).doubleValue
        let height = (param["height"] as! NSNumber).doubleValue
        let format = (param["format"] as! NSNumber).intValue
        let quality = (param["quality"] as! NSNumber).intValue
        let imageParams = (param["imageParams"] as! [[String: Any]]).map { it in

            let image = (it["image"] as! FlutterStandardTypedData).data
            let dx = (it["dx"] as! NSNumber).doubleValue
            let dy = (it["dy"] as! NSNumber).doubleValue
            let width = (it["width"] as! NSNumber).doubleValue
            let height = (it["height"] as! NSNumber).doubleValue

            return ImageParam(image: image, dx: dx, dy: dy, width: width, height: height)
        }

        self.mergeParam = MergeParam(color: color, width: width, height: height, format: format, quality: quality, imageParams: imageParams)
    }

    func mergeToMemory() -> FlutterStandardTypedData? {
        let size = CGSizeMake(mergeParam.width, mergeParam.height)

        UIGraphicsBeginImageContext(size)

        mergeParam.imageParams.forEach { it in
            UIImage(data: it.image)?.draw(in: CGRect(x: it.dx, y: it.dy, width: it.width, height: it.height))
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        var imageData: Data?

        if mergeParam.format == FormatPng {
            imageData = image.pngData()
        } else {
            imageData = image.jpegData(compressionQuality: CGFloat(Float(mergeParam.quality) / 100.0))
        }
        UIGraphicsEndImageContext()

        guard let imageData = imageData else {
            return nil
        }

        return FlutterStandardTypedData(bytes: imageData)
    }
}
