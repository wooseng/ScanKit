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
    
    /// 扫描结果的回调
    public var scanCallback: (([SKResult]) -> Void)?
    public var animateView = SKAnimationView()
    public var scanArea = SKScanArea() {
        didSet {
            animateView.scanArea = scanArea
            setNeedsLayout()
        }
    }

    public override init(frame: CGRect) {
        _wrapper = SKScanWrapper()
        super.init(frame: frame)
        _wrapper.setContainer(self)
        animateView.backgroundColor = UIColor.clear
        animateView.scanArea = scanArea
        addSubview(animateView)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let _wrapper: SKScanWrapper
    private let _animateLayer = CALayer()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _wrapper.resize(self.bounds)
        animateView.frame = scanAreaRect
    }
    
    deinit {
        SKLogWarn("deinit:", self.classForCoder)
    }
    
}

public extension SKView {
    
    /// 开始运行扫描器
    func startRunning() {
        _wrapper.scanCallback = scanCallback
        _wrapper.startRunning()
    }
    
    /// 停止运行扫描器
    func stopRunning() {
        _wrapper.stopRunning()
    }
    
}

public extension SKView {
    
    /// 手电筒是否可用
    var isTorchEnable: Bool { _wrapper.isTorchEnable }
    
    /// 手电筒是否处于关闭状态
    var isTorchClosed: Bool { _wrapper.isTorchClosed }
    
    /// 打开手电筒
    func openTorch() {
        _wrapper.openTorch()
    }
    
    /// 关闭手电筒
    func closeTorch() {
        _wrapper.closeTorch()
    }
    
    /// 切换手电筒状态
    func switchedTorch() {
        _wrapper.switchedTorch()
    }
}

private extension SKView {
    
    // 扫描区域
    var scanAreaRect: CGRect {
        let areaCenter = CGPoint(x: center.x, y: center.y + scanArea.offsetY)
        let width = scanArea.width
        let height = scanArea.height
        let minX = areaCenter.x - width / 2
        let minY = areaCenter.y - height / 2
        return CGRect(x: minX, y: minY, width: width, height: height)
    }
    
}
