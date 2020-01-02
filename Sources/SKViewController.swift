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
    
    public override var scanArea: SKScanArea {
        didSet {
            animateView.scanArea = scanArea
            view.setNeedsLayout()
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(_maskView)
        
        animateView.backgroundColor = UIColor.clear
        animateView.scanArea = scanArea
        view.addSubview(animateView)
        animateView.startAnimating()
        
        view.addSubview(_loadingIndicatorView)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animateView.stopAnimating()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateView.startAnimating()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let area = scanArea.rect(in: view.bounds)
        animateView.frame = area
        _maskView.scanArea = area
        _maskView.frame = view.bounds
        _loadingIndicatorView.center = animateView.center
    }
    
    public private(set) lazy var animateView = SKAnimationView()
    private lazy var _maskView = SKMaskView()
    
    // 加载中的旋转视图
    private lazy var _loadingIndicatorView: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView(style: .white)
        temp.stopAnimating()
        temp.isHidden = true
        return temp
    }()
    
    open override func didWrapperStateChange(_ state: SKScanWrapperState) {
        super.didWrapperStateChange(state)
        switch state {
        case .loading, .starting, .stoping:
            if !(_loadingIndicatorView.isAnimating) {
                _loadingIndicatorView.startAnimating()
                _loadingIndicatorView.isHidden = false
            }
            break
        default:
            if _loadingIndicatorView.isAnimating {
                _loadingIndicatorView.stopAnimating()
                _loadingIndicatorView.isHidden = true
            }
        }
    }
    
}

public extension SKViewController {
    
    /// 设置扫描区域以外的颜色，如果需要透明度，请直接给颜色透明度
    final func setOutsideTheScanArea(_ color: UIColor?) {
        _maskView.backgroundColor = color
    }
    
}
