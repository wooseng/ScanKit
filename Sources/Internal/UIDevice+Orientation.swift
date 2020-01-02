//
// UIDevice+Ext.swift
// Sources
//
// Create by wooseng with company's MackBook Pro on 2019/11/3.
// Copyright © 2019 残无殇. All rights reserved.
//


import UIKit
import AVFoundation

internal extension UIDevice {
    
    var captureVideoOrientation: AVCaptureVideoOrientation? {
        AVCaptureVideoOrientation(rawValue: orientation.rawValue)
    }
    
    // 强制将设备的方向修改为指定方向，如果指定方向与当前方向一致，则不修改
    func forceOrientation(to value: UIDeviceOrientation) {
        guard value != orientation else {
            return
        }
        setValue(value.rawValue, forKey: "orientation")
    }
    
}
