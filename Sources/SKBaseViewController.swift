//
//  SKBaseViewController.swift
//  Sources
//
//  Created by 稍息 on 2020/1/2.
//  Copyright © 2020 残无殇. All rights reserved.
//
//  基础扫码视图控制器，只包含扫码需要的基础与核心功能
//  使用的时候，如果选择继承此类，那么很多常用功能都需要自己动手去实现
//

import UIKit

open class SKBaseViewController: UIViewController {
    
    /// 扫描成功的回调，如果是继承此类，则重载相关方法即可
    public var scanCallback: (([SKResult]) -> Void)?
    
    /// 是否开启探测器进行识别，可以提升识别速度与识别度，默认开启
    /// 开启后会使用CIFilter对图像进行实时处理，然后使用CIDetector进行识别
    /// 如果机器性能较低，建议关闭
    public var isDetectorEnable = true {
        didSet {
            _wrapper.isDetectorEnable = isDetectorEnable
        }
    }
    
    /// 是否开启探测器预览视图，只有开启探测器进行识别，此属性才有效，默认关闭，一般用于测试
    public var isDetectPreviewEnable = false {
        didSet {
            _wrapper.isDetectPreviewEnable = isDetectPreviewEnable
        }
    }
    
    /// 扫描区域配置
    public var scanArea = SKScanArea()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        SKPermission.authorizeCamera {
            if $0 {
                self.setupScanWrapper()
            } else {
                self.permissionDenied(.camera)
            }
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _wrapper.stopRunning()
        _wrapper.closeTorch()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _wrapper.startRunning()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.forceOrientation(to: .portrait)
    }
    
    /// 权限拒绝后会调用此方法
    ///
    /// 默认弹窗提示并支持跳转到系统设置页
    /// 如果想实现自己逻辑或者弹窗样式，可以重写此方法(重写的话不要使用 super 关键词)
    open func permissionDenied(_ type: SKPermissionType) {
        let message = type == .camera ? "您没有使用摄像头的权限，是否前往设置？" : "您没有访问相册的权限，是否前往设置？"
        let alert = UIAlertController(title: "权限提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { [weak self] _ in
            self?.back(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "打开设置", style: .default, handler: { [weak self] _ in
            self?.back(animated: true)
            SKPermission.openSystemSeting()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    /// 扫描启动完成后会调用此方法
    open func didScanStartRunning() { }
    
    /// 扫描停止后会调用此方法
    open func didScanStopRunning() { }
    
    /// 扫码完成会执行此方法
    /// 如果继承此视图控制器，可以重载此方法，然后实现自己的逻辑
    /// 如果直接使用此视图控制器，则可以选择实现回调闭包函数 scanCallback
    open func didScanFinshed(_ results: [SKResult]) {
        back(animated: true)
    }
    
    /// 扫描器状态发生变化会调用此方法
    open func didWrapperStateChange(_ state: SKScanWrapperState) { }
    
    deinit {
        SKLogWarn("deinit:", self.classForCoder)
    }
    
    //MARK: - 私有属性
    private lazy var _wrapper = SKScanWrapper()
    
    //MARK: - 视图旋转限制
    open override var shouldAutorotate: Bool { true }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { .portrait }
    
}

//MARK: - 手电筒相关
public extension SKBaseViewController {
    
    /// 手电筒是否可用
    var isTorchEnable: Bool { _wrapper.isTorchEnable }
    
    /// 手电筒是否处于关闭状态
    var isTorchClosed: Bool { _wrapper.isTorchClosed }
    
    /// 打开手电筒
    final func openTorch() {
        _wrapper.openTorch()
    }
    
    /// 关闭手电筒
    final func closeTorch() {
        _wrapper.closeTorch()
    }
    
    /// 切换手电筒状态
    final func switchedTorch() {
        _wrapper.switchedTorch()
    }
    
}

private extension SKBaseViewController {
    
    // 设置扫描器
    func setupScanWrapper() {
        #if targetEnvironment(simulator)
        SKLogError("此框架暂不支持模拟器")
        #else
        _wrapper.setContainer(view)
        _wrapper.scanCallback = { [weak self] in
            self?._wrapper.stopRunning()
            self?.scanCallback?($0)
            self?.didScanFinshed($0)
        }
        _wrapper.wrapperStateDidChange = { [weak self] in
            SKLogPlain("扫描器状态", $0)
            self?.didWrapperStateChange($0)
            if $0 == .started {
                self?.didScanStartRunning()
            } else if $0 == .stoped {
                self?.didScanStopRunning()
            }
        }
        _wrapper.startRunning()
        #endif
    }
    
}
