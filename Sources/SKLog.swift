//
//  SKLog.swift
//  ScanKit
//
//  Created by 残无殇 on 2019/10/28.
//  Copyright © 2019 残无殇. All rights reserved.
//

import Foundation

// 错误日志
internal func SKLogError(_ items: Any?..., separator: String = " ") {
    SKLog(items, type: "error")
}

// 警告日志
internal func SKLogWarn(_ items: Any?..., separator: String = " ") {
    SKLog(items, type: "warn")
}

// 普通日志
internal func SKLogPlain(_ items: Any?..., separator: String = " ") {
    SKLog(items, type: "plain")
}

fileprivate func SKLog(_ items: [Any?], type: String, separator: String = " ") {
    #if DEBUG
    let date = currentDateString()
    var logString = "[\(date) \(kitName) \(type)] "
    logString += items.map { item -> String in
        guard let item = item else {
            return "null"
        }
        if JSONSerialization.isValidJSONObject(item) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                return String(data: jsonData, encoding: .utf8) ?? "null"
            } catch {
                return "null"
            }
        } else {
            return "\(item)"
        }
    }.joined(separator: separator)
    print(logString)
    #endif
}

// 获取当前时间字符串
fileprivate func currentDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
    return dateFormatter.string(from: Date())
}
