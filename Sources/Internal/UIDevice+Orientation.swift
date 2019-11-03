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
    
}
