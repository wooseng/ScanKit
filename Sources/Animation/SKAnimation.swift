//
//  SKAnimation.swift
//  Sources
//
//  Created by 稍息 on 2020/1/2.
//  Copyright © 2020 残无殇. All rights reserved.
//

import UIKit

public typealias SKAnimation = UIView & SKAnimationProtocol

public protocol SKAnimationProtocol {
    
    /// 动画相关配置
    var scanArea: SKScanArea { get set}
    
    /// 是否正在执行动画
    var isAnimating: Bool { get }
    
    /// 开始动画
    func startAnimating()
    
    /// 停止动画
    func stopAnimating()
    
}
