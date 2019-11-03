//
// SKMaskView.swift
// Sources
//
// Create by wooseng with company's MackBook Pro on 2019/11/3.
// Copyright © 2019 残无殇. All rights reserved.
//
//  遮罩层（主要用于非扫码区域的遮罩，例如模糊，颜色等）
//

import UIKit

class SKMaskView: UIView {
    
    var scanArea = SKScanArea() {
        didSet {
            _effectView.isHidden = !scanArea.isMaskBlurEnable
            if scanArea.isMaskBlurEnable {
                backgroundColor = UIColor.clear
            } else {
                backgroundColor = scanArea.maskColor?.withAlphaComponent(scanArea.maskAlpha)
            }
            setNeedsDisplay()
        }
    }
    var scanAreaRect = CGRect.zero
    
    private lazy var _maskLayer = CAShapeLayer()
    private lazy var _effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(_effectView)
        layer.mask = _maskLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _effectView.frame = bounds
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(rect: bounds)
        path.append(UIBezierPath(rect: scanAreaRect))

        _maskLayer.frame = bounds
        _maskLayer.fillRule = .evenOdd
        _maskLayer.path = path.cgPath
    }
    
}
