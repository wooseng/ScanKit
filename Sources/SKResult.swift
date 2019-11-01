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

public struct SKResult {
    
    public var codeType: String?
    
    public var stringValue: String?
    
    public var corner = [CGPoint]()
    
    init(_ metaData: AVMetadataObject) {
        guard let data = metaData as? AVMetadataMachineReadableCodeObject else {
            return
        }
        stringValue = data.stringValue
        codeType = data.type.rawValue
        corner = data.corners
    }
    
    public var description: String {
        let data: [String: Any] = [
            "codeType": codeType ?? "",
            "stringValue": stringValue ?? "",
            "corner": corner.map { [ "x": $0.x, "y": $0.y ] }
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
    
}
