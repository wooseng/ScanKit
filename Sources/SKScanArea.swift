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
    
    public var width: CGFloat = 200
    public var height: CGFloat = 200
    
    //MARK: 边框
    public var borderWidth: CGFloat = 1
    public var borderColor: UIColor? = UIColor.green.withAlphaComponent(0.6)
    
    //MARK: 四个角
    public var cornerColor: UIColor? = UIColor.blue
    public var cornerWidth: CGFloat = 3
    public var cornerRadius: CGFloat = 20 // 圆角半径
    
    /// 基于视图中心沿Y轴方向偏移，如果大于0，则向下偏移，小于0，则向上偏移，默认居中
    public var offsetY: CGFloat = 0
    
}
