//
// SKView.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/9/18.
// Copyright © 2019 残无殇. All rights reserved.
//
//  扫描框架主控件，展示捕获的图像，以及绘制扫描区域，控制扫描区域的动画等
//


import UIKit
import AVFoundation

public class SKView: UIView {
    
    // 扫描结果的回调
    public var scanCallback: (([AVMetadataObject]) -> Void)?
    public var scanArea = SKScanArea()

    public override init(frame: CGRect) {
        _wrapper = SKScanWrapper()
        super.init(frame: frame)
        _wrapper.setContainer(self)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let _wrapper: SKScanWrapper
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _wrapper.resize(self.bounds)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let area = scanAreaRect
        
        // 绘制区域边框
        drawBox(CGRect(x: area.minX, y: area.minY, width: area.width, height: area.height))
        
        // 绘制四个角
        drawAreaCorner(CGPoint(x: area.minX, y: area.minY + scanArea.cornerRadius),
                       CGPoint(x: area.minX, y: area.minY),
                       CGPoint(x: area.minX + scanArea.cornerRadius, y: area.minY))
        drawAreaCorner(CGPoint(x: area.maxX - scanArea.cornerRadius, y: area.minY),
                       CGPoint(x: area.maxX, y: area.minY),
                       CGPoint(x: area.maxX, y: area.minY + scanArea.cornerRadius))
        drawAreaCorner(CGPoint(x: area.maxX, y: area.maxY - scanArea.cornerRadius),
                       CGPoint(x: area.maxX, y: area.maxY),
                       CGPoint(x: area.maxX - scanArea.cornerRadius, y: area.maxY))
        drawAreaCorner(CGPoint(x: area.minX + scanArea.cornerRadius, y: area.maxY),
                       CGPoint(x: area.minX, y: area.maxY),
                       CGPoint(x: area.minX, y: area.maxY - scanArea.cornerRadius))
        
    }
    
}

public extension SKView {
    
    // 开始运行扫描器
    func startRunning() {
        _wrapper.scanCallback = scanCallback
        _wrapper.startRunning()
    }
    
    // 停止运行扫描器
    func stopRunning() {
        _wrapper.stopRunning()
    }
    
    /// 扫描区域
    var scanAreaRect: CGRect {
        let areaCenter = CGPoint(x: center.x, y: center.y + scanArea.offsetY)
        let width = scanArea.width
        let height = scanArea.height
        let minX = areaCenter.x - width / 2
        let minY = areaCenter.y - height / 2
        return CGRect(x: minX, y: minY, width: width, height: height)
    }
    
}

private extension SKView {
    
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
    
}
