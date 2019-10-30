//
// SKAnimationView.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/10/29.
// Copyright © 2019 残无殇. All rights reserved.
//
//  动画视图基类
//

import UIKit

public class SKAnimationView: UIView {

    public var scanArea = SKScanArea() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        
        // 绘制区域边框
        drawBox(bounds)
        
        // 绘制四个角
        let radius = scanArea.cornerRadius
        drawAreaCorner(CGPoint(x: 0, y: radius),
                       CGPoint(x: 0, y: 0),
                       CGPoint(x: radius, y: 0))
        drawAreaCorner(CGPoint(x: rect.width - radius, y: 0),
                       CGPoint(x: rect.width, y: 0),
                       CGPoint(x: rect.width, y: radius))
        drawAreaCorner(CGPoint(x: rect.width, y: rect.height - radius),
                       CGPoint(x: rect.width, y: rect.height),
                       CGPoint(x: rect.width - radius, y: rect.height))
        drawAreaCorner(CGPoint(x: radius, y: rect.height),
                       CGPoint(x: 0, y: rect.height),
                       CGPoint(x: 0, y: rect.height - radius))
        
    }
    
    // 绘制扫描边框
    private func drawBox(_ rect: CGRect) {
        guard let borderCorlor = scanArea.borderColor else {
            return
        }
        let path = UIBezierPath(rect: rect)
        path.lineWidth = scanArea.borderWidth
        path.lineCapStyle = .round
        borderCorlor.set()
        path.stroke()
    }
    
    // 绘制四个角
    private func drawAreaCorner(_ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) {
        guard let cornerColor = scanArea.cornerColor else {
            return
        }
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.lineWidth = scanArea.cornerWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        cornerColor.set()
        path.stroke()
    }
    
    deinit {
        SKLogWarn("deinit:", self.classForCoder)
    }
    
}
