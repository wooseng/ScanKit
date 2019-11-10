//
//  SKDetector.swift
//  Sources
//
//  Created by 稍息 on 2019/11/10.
//  Copyright © 2019 残无殇. All rights reserved.
//
//  图片探测器，基于 CoreImage 封装，使用 CIDetector 获取图片中的二维码
//

import UIKit
import CoreImage
import AVFoundation

internal protocol SKDetectorDelete {
    
    // 经过滤镜处理后的图片会通过此代理方法回调
    func detector(_ detector: SKDetector, didOutput output: UIImage)
    
}

internal class SKDetector {
    
    init(_ options: [CIContextOption: Any]? = nil) {
        self.context = CIContext(options: options)
    }
    
    internal var delete: SKDetectorDelete?
    
    private(set) var context: CIContext
    private(set) lazy var detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [
        CIDetectorAccuracy: CIDetectorAccuracyHigh
    ])
    
    // 对指定 CMSampleBuffer 进行处理，并识别其中的二维码内容
    func detect(from sampleBuffer: CMSampleBuffer) throws -> [SKResult] {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return []
        }
        do {
            return try detect(from: CIImage(cvImageBuffer: buffer))
        }
    }
    
    // 对指定 CIImage 进行处理，并识别其中的二维码内容
    func detect(from ciImage: CIImage) throws -> [SKResult] {
        do {
            let ciImg = try filterImage(from: ciImage)
            let temp = detector?.features(in: ciImg).filter {
                $0 is CIQRCodeFeature
            }.map {
                $0 as! CIQRCodeFeature
            }.map {
                SKResult($0)
            }
            if let img = context.createCGImage(ciImg, from: ciImg.extent) {
                DispatchQueue.main.async {
                    self.delete?.detector(self, didOutput: UIImage(cgImage: img))
                }
            }
            if let results = temp {
                return results
            }
            throw SKError("CIDetector初始化失败")
        }
    }
    
}

//MARK: - 滤镜链
private extension SKDetector {
    
    func filterImage(from ciImage: CIImage) throws -> CIImage {
        do {
            let falseColorImage = try falseColorFilter(from: ciImage)
            let colorControlsImage = try colorControlsFilter(from: falseColorImage)
            return colorControlsImage
        }
    }
    
    // CIFalseColor 滤镜
    func falseColorFilter(from ciImage: CIImage) throws -> CIImage {
        let color0 = CIColor(color: UIColor.white)
        let color1 = CIColor(color: UIColor.black)
        let filter = CIFilter(name: "CIFalseColor", parameters: [
            "inputImage": ciImage,
            "inputColor0": color0, // 底色
            "inputColor1": color1 // 前景色
        ])
        if let result = filter?.outputImage {
            return result
        } else {
            throw SKError("滤镜出错")
        }
    }
    
    // CIColorControls 滤镜
    func colorControlsFilter(from ciImage: CIImage) throws -> CIImage {
        let filter = CIFilter(name: "CIColorControls", parameters: [
            "inputImage": ciImage,
            "inputSaturation": 1, // 饱和度
            "inputBrightness": 0, // 亮度
            "inputContrast": 1 // 对比度
        ])
        if let result = filter?.outputImage {
            return result
        } else {
            throw SKError("滤镜出错")
        }
    }
    
}
