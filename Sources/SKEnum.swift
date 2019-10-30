//
// SKEnum.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/9/18.
// Copyright © 2019 残无殇. All rights reserved.
//
//  框架自定义的枚举
//


import Foundation

/// 权限类型
public enum SKPermissionType {
    case photo // 图库，相册
    case camera // 相机
}

/// 扫码数据的类型（暂时没有使用）
public enum SKResultType {
    
    /// 未知
    case unknow
    
    /// 文本
    case text
    
    /// 网址
    case url
    
    /// 邮箱地址
    case email
    
    /// 电话号码
    case phoneNumber
    
    /// 联系方式
    case contact_MECARD
    case contact_BIZCARD
    case contact_vCard
    
    /// 短信
    case sms
    
    /// 彩信
    case mms
    
    /// 地理位置
    case geographic
    
}
