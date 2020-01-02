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

public class SKAnimationView: SKAnimation {
    
    public private(set) var isAnimating = false // 是否正在动画
    public var scanArea = SKScanArea() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private lazy var _animationgView = UIImageView()
    private var _willStopAnimating = false // 是否将要停止动画
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(_animationgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    deinit {
        SKLogWarn("deinit:", self.classForCoder)
    }
    
}

public extension SKAnimationView {
    
    /// 开始动画
    func startAnimating() {
        guard !isAnimating else {
            return
        }
        _willStopAnimating = false
        animation()
    }
    
    /// 停止动画
    func stopAnimating() {
        guard isAnimating, !_willStopAnimating else {
            return
        }
        _willStopAnimating = true
    }
    
}

private extension SKAnimationView {
    
    func animation() {
        guard let image = scanArea.animationImage else {
            SKLogWarn("动画图片为空")
            return
        }
        let width = frame.width
        let height = width * image.size.height / image.size.width
        guard width > 0, height > 0 else {
            SKLogWarn("视图尚未设置完成")
            return
        }
        isAnimating = true
        _animationgView.image = scanArea.animationImage
        
        _animationgView.frame = CGRect(x: 0, y: -height, width: width, height: height)
        let targetRect = CGRect(x: 0, y: frame.height - height, width: width, height: height)
        _animationgView.isHidden = false
        _animationgView.alpha = 1
        let duration = scanArea.animationDuration // 动画持续时长
        
        let group = DispatchGroup()
        
        group.enter()
        UIView.animate(withDuration: duration, animations: {
            self._animationgView.frame = targetRect
        }) { _ in
            group.leave()
        }
        
        group.enter()
        let disappearDuration = duration / 3
        let disappearBegin = duration - disappearDuration
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + disappearBegin) {
            UIView.animate(withDuration: disappearDuration, animations: {
                self._animationgView.alpha = 0
            }) { _ in
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.didAnimationEnd()
        }
    }
    
    // 动画结束执行的方法
    func didAnimationEnd() {
        _animationgView.isHidden = true
        if _willStopAnimating {
            isAnimating = false
        } else {
            animation()
        }
    }
    
    // 绘制扫描边框
    func drawBox(_ rect: CGRect) {
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
    func drawAreaCorner(_ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) {
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
