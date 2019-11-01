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
    
    public var scanCallback: (([SKResult]) -> Void)? // 扫描器扫描到结果后会使用此闭包进行回调
    public var scanDidStartRunning: (() -> Void)? // 扫描器启动扫描后会使用此闭包进行回调
    public var scanDidStopRunning: (() -> Void)? // 扫描器停止扫描后会使用此闭包进行回调
    public var isLimitRecognitionArea = false { // 是否限制识别区域
        didSet {
            setNeedsLayout()
        }
    }
    public private(set) lazy var animateView = SKAnimationView()
    public var scanArea = SKScanArea() {
        didSet {
            animateView.scanArea = scanArea
            setNeedsLayout()
        }
    }
    
    private lazy var _wrapper = SKScanWrapper()
    private lazy var _loadingIndicatorView = UIActivityIndicatorView(style: .white) // 加载中的旋转视图
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupWrapper()
        
        animateView.backgroundColor = UIColor.clear
        animateView.scanArea = scanArea
        addSubview(animateView)
        
        addSubview(_loadingIndicatorView)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let area = scanAreaRect
        _wrapper.resize(bounds, rectOfScan: isLimitRecognitionArea ? area : bounds)
        animateView.frame = area
        _loadingIndicatorView.center = center
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
    
    // 设置扫描器
    func setupWrapper() {
        _wrapper.setContainer(self)
        _wrapper.wrapperStateDidChange = { [weak self] in
            SKLogPlain("扫描器状态", $0)
            switch $0 {
            case .loading, .starting, .stoping:
                if !(self?._loadingIndicatorView.isAnimating ?? false) {
                    self?._loadingIndicatorView.startAnimating()
                    self?._loadingIndicatorView.isHidden = false
                }
            default:
                if self?._loadingIndicatorView.isAnimating ?? false {
                    self?._loadingIndicatorView.stopAnimating()
                    self?._loadingIndicatorView.isHidden = true
                }
            }
            if $0 == .started {
                self?.scanDidStartRunning?()
            } else if $0 == .stoped {
                self?.scanDidStopRunning?()
            }
        }
    }
    
}
