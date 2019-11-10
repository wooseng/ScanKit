//
// SKResult.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/10/30.
// Copyright © 2019 残无殇. All rights reserved.
//
//  扫码结果
//


import Foundation
import AVFoundation
import CoreImage

public struct SKResult {
    
    public private(set) var codeType: String?
    
    public private(set) var stringValue: String?
    
    public private(set) var topLeft = CGPoint.zero

    public private(set) var topRight = CGPoint.zero

    public private(set) var bottomLeft = CGPoint.zero

    public private(set) var bottomRight = CGPoint.zero
    
    init(_ metaData: AVMetadataObject, size: CGSize) {
        guard let data = metaData as? AVMetadataMachineReadableCodeObject else {
            return
        }
        stringValue = data.stringValue
        codeType = data.type.rawValue
        guard data.corners.count > 3 else {
            return
        }
        bottomLeft = transform(coordinates: data.corners[0], with: size)
        bottomRight = transform(coordinates: data.corners[1], with: size)
        topRight = transform(coordinates: data.corners[2], with: size)
        topLeft = transform(coordinates: data.corners[3], with: size)
    }
    
    init(_ feature: CIQRCodeFeature) {
        stringValue = feature.messageString
        codeType = feature.type
        topLeft = feature.topLeft
        topRight = feature.topRight
        bottomLeft = feature.bottomLeft
        bottomRight = feature.bottomRight
    }
    
    public var description: String {
        let data: [String: Any] = [
            "codeType": codeType ?? "",
            "stringValue": stringValue ?? "",
            "corners": [
                "topLeft": "x:\(topLeft.x), y:\(topLeft.y)",
                "topRight": "x:\(topRight.x), y:\(topRight.y)",
                "bottomLeft": "x:\(bottomLeft.x), y:\(bottomLeft.y)",
                "bottomRight": "x:\(bottomRight.x), y:\(bottomRight.y)"
            ]
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
    
}

private extension SKResult {
    
    // 将比例坐标转为实际坐标
    func transform(coordinates: CGPoint, with size: CGSize) -> CGPoint {
        let x = size.width * coordinates.x
        let y = size.height * coordinates.y
        return CGPoint(x: x, y: y)
    }
    
}
