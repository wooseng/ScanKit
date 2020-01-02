//
//  Extensions.swift
//  Sources
//
//  Created by 稍息 on 2020/1/2.
//  Copyright © 2020 残无殇. All rights reserved.
//
//  内部扩展文件
//

import UIKit
import AVFoundation

internal extension UIViewController {
    
    /// 回到上一级页面
    ///
    /// - 如果当前页面没有被 UINavigationController 管理，直接使用 dismiss 回到上一级页面
    /// - 如果当前页面是 UINavigationController 的根视图控制器，使用导航栏的 dismiss 回到上级页面
    /// - 如果当前页面是受 UINavigationController 管理的非根视图控制器，使用 pop 回到上一级页面
    func back(animated: Bool) {
        guard let nav = navigationController,
            nav.viewControllers.first != self else {
            dismiss(animated: animated, completion: nil)
            return
        }
        nav.popViewController(animated: animated)
    }
    
}

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
