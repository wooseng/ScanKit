//
// SKPermission.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/9/18.
// Copyright © 2019 残无殇. All rights reserved.
//
//  相机/相册 权限管理，非公开
//


import UIKit
import AVFoundation
import Photos

internal struct SKPermission {
    
    // 相机权限
    static func authorizeCamera(_ complete: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            complete(true)
        case .denied, .restricted:
            complete(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { result in
                DispatchQueue.main.async {
                    complete(result)
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    // 相册权限
    static func authorizePhoto(_ complete: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case PHAuthorizationStatus.authorized:
            complete(true)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            complete(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization { (result) in
                DispatchQueue.main.async {
                    complete(result == .authorized)
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    // 打开系统设置页
    static func openSystemSeting() {
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
