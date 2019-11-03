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
        width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 150
        height = width
    }
    
    public var width: CGFloat = 230
    public var height: CGFloat = 230
    
    //MARK: 边框
    public var borderWidth: CGFloat = 1
    public var borderColor: UIColor? = UIColor.green.withAlphaComponent(0.6)
    
    //MARK: 四个角
    public var cornerColor: UIColor? = UIColor.blue
    public var cornerWidth: CGFloat = 3
    public var cornerRadius: CGFloat = 20 // 圆角半径
    
    /// 基于视图中心沿Y轴方向偏移，如果大于0，则向下偏移，小于0，则向上偏移，默认居中
    public var offsetY: CGFloat = 0
    
    //MARK: 非扫码区域的蒙层
    public var maskColor: UIColor? = UIColor.black
    public var maskAlpha: CGFloat = 0.6
    
    /// 是否开启非扫码区域使用高斯模糊(如果设置为true，则 maskColor 与 maskAlpha 两个属性将会失效)
    public var isMaskBlurEnable = false
    
    //MARK: 动画设置
    public var animationImage: UIImage?
    public var animationDuration: TimeInterval = 2
    
}

//MARK: - 便利生成
public extension SKScanArea {
    
    static func wechat() -> Self {
        var area = SKScanArea()
        area.animationImage = SKHelper.image(with: "sk_image_animate_wechat")
        area.cornerColor = UIColor.green.withAlphaComponent(0.6)
        area.borderColor = UIColor.gray.withAlphaComponent(0.6)
        return area
    }

    static func alipay() -> Self {
        var area = SKScanArea()
        area.animationImage = SKHelper.image(with: "sk_image_animate_alipay")
        area.cornerColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        area.borderColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        area.cornerWidth = 5
        return area
    }
}
