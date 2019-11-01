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

/// 扫描器的状态
internal enum SKScanWrapperState {
    
    /// 正常状态，扫描器加载前是这种状态
    case normal
    
    /// 正在加载中
    case loading
    
    /// 已经加载完成
    case loaded
    
    /// 正在启动
    case starting
    
    /// 已经启动
    case started
    
    /// 正在停止
    case stoping
    
    /// 已经停止
    case stoped
    
    /// 未知状态，一般是加载失败会被设置为这个状态
    case unknow
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
