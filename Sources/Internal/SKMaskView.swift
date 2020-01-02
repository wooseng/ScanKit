//
// SKMaskView.swift
// Sources
//
// Create by wooseng with company's MackBook Pro on 2019/11/3.
// Copyright © 2019 残无殇. All rights reserved.
//
//  遮罩层（主要用于非扫码区域的遮罩）
//

import UIKit

internal class SKMaskView: UIView {
    
    var scanArea = CGRect.zero
    
    private lazy var _maskLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        layer.mask = _maskLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(rect: bounds)
        path.append(UIBezierPath(rect: scanArea))

        _maskLayer.frame = bounds
        _maskLayer.fillRule = .evenOdd
        _maskLayer.path = path.cgPath
    }
    
}
