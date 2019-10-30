//
// SKViewController.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/9/18.
// Copyright © 2019 残无殇. All rights reserved.
//
// 扫描框架主控制器
//
// 1. 可以对其进行设置后直接使用
// 2. 可以继承此控制器后使用

import UIKit

open class SKViewController: UIViewController {
    
    /// 扫描视图控件
    public private(set) var scanView: SKView?
    
    /// 扫描成功的回调，如果是继承此类，则重载相关方法即可
    public var scanCallback: (([SKResult]) -> Void)?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        SKPermission.authorizeCamera {
            if $0 {
                self.setupScanView()
            } else {
                self.permissionDenied(.camera)
            }
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanView?.stopRunning()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scanView?.startRunning()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scanView?.frame = view.bounds
    }
    
    /// 权限拒绝后会调用此方法
    ///
    /// 默认弹窗提示并支持跳转到系统设置页
    /// 如果想实现自己逻辑或者弹窗样式，可以重写此方法(重写的话不要使用 super 关键词)
    open func permissionDenied(_ type: SKPermissionType) {
        let message = type == .camera ? "您没有使用摄像头的权限，是否前往设置？" : "您没有访问相册的权限，是否前往设置？"
        let alert = UIAlertController(title: "权限提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { [weak self] _ in
            self?.closeCurrentPage()
        }))
        alert.addAction(UIAlertAction(title: "打开设置", style: .default, handler: { [weak self] _ in
            self?.closeCurrentPage()
            SKPermission.openSystemSeting()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    /// 扫描视图设置完毕会调用，如果需要添加自己的视图控件，可以重载此方法，然后在这里面写
    /// 注意，扫描视图设置失败不会调用，例如没有权限、设备不支持等，都会导致此方法不调用
    open func didScanViewSetupFinsh() { }
    
    /// 扫码完成会执行此方法
    /// 如果继承此视图控制器，可以重载此方法，然后实现自己的逻辑
    /// 如果直接使用此视图控制器，则可以选择实现回调闭包函数 scanCallback
    open func didScanFinshed(_ results: [SKResult]) {
        closeCurrentPage()
        scanCallback?(results)
    }
    
}

//MARK: - 私有方法
private extension SKViewController {
    
    // 关闭当前页面
    func closeCurrentPage() {
        guard let nav = navigationController, nav.viewControllers.first != self else {
            dismiss(animated: true, completion: nil)
            return
        }
        nav.popViewController(animated: true)
    }
    
    // 设置扫描视图控件
    func setupScanView() {
        #if targetEnvironment(simulator)
        SKLogError("此框架暂不支持模拟器")
        #else
        if scanView != nil {
            scanView?.removeFromSuperview()
        }
        let scanView = SKView()
        scanView.frame = view.bounds
        scanView.scanCallback = { [weak self] results in
            self?.didScanFinshed(results)
        }
        view.addSubview(scanView)
        self.scanView = scanView
        scanView.startRunning()
        didScanViewSetupFinsh()
        #endif
    }
    
}
