//
// SKViewController.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/9/18.
// Copyright © 2019 残无殇. All rights reserved.
//
//  扫描框架视图控制器，里面主要是实现额外功能，比如动画、扫描区域外样式等等
//  一般来说，我们推荐继承此类来实现自己的个性化定制
//

import UIKit

open class SKViewController: SKBaseViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(_maskView)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _maskView.scanArea = scanArea.rect(in: view.bounds)
        _maskView.frame = view.bounds
    }
    
    private lazy var _maskView = SKMaskView()
    
}

public extension SKViewController {
    
    /// 设置扫描区域以外的颜色，如果需要透明度，请直接给颜色透明度
    final func setOutsideTheScanArea(_ color: UIColor?) {
        _maskView.backgroundColor = color
    }
    
}
