//
//  MergeParam.swift
//  widget_shot
//
//  Created by bingo on 2023/5/9.
//

import Flutter
import Foundation

struct MergeParam {
    var color: UIColor?
    var width: Double
    var height: Double
    var format: Int
    var quality: Int
    var imageParams: [ImageParam]
}

struct ImageParam {
    var image: Data
    var dx: Double
    var dy: Double
    var width: Double
    var height: Double
}
