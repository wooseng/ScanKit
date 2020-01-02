//
//  SKScanArea.swift
//  ScanKit
//
//  Created by 残无殇 on 2019/10/28.
//  Copyright © 2019 残无殇. All rights reserved.
//
//  扫描区域配置
//

import UIKit

public struct SKScanArea {
    
    public init() {
        width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 100
        height = width
    }
    
    public var width: CGFloat = 0
    public var height: CGFloat = 0
    
    //MARK: 边框
    public var borderWidth: CGFloat = 1
    public var borderColor: UIColor? = UIColor.green.withAlphaComponent(0.6)
    
    //MARK: 四个角
    public var cornerColor: UIColor? = UIColor.blue
    public var cornerWidth: CGFloat = 3
    public var cornerRadius: CGFloat = 20 // 圆角半径
    
    /// 基于视图中心沿Y轴方向偏移，如果大于0，则向下偏移，小于0，则向上偏移，默认居中
    public var offsetY: CGFloat = 0
    
    //MARK: 动画设置
    public var animationImage: UIImage?
    public var animationDuration: TimeInterval = 2
    
}

//MARK: 样式切换
public extension SKScanArea {
    
    /// 将扫描区域样式修改为光标风格样式，类似微信
    mutating func turnIntoCursorStyle() {
        animationImage = SKHelper.image(with: "sk_image_animate_wechat")
        cornerColor = UIColor.green.withAlphaComponent(0.6)
        borderColor = UIColor.gray.withAlphaComponent(0.6)
    }
    
    /// 将扫描区区域样式修改为网格风格样式，类似支付宝
    mutating func turnIntoGridStyle() {
        animationImage = SKHelper.image(with: "sk_image_animate_alipay")
        cornerColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        borderColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        cornerWidth = 5
    }
}

internal extension SKScanArea {
    
    func rect(in bounds: CGRect) -> CGRect {
        let width = min(self.width, bounds.width)
        let height = min(self.height, bounds.height)
        let x = (bounds.width - width) / 2
        let y = (bounds.height - height) / 2 + offsetY
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}
