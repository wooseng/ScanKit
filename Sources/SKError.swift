//
//  SKError.swift
//  Sources
//
//  Created by 稍息 on 2019/11/10.
//  Copyright © 2019 残无殇. All rights reserved.
//

import Foundation

public class SKError: Error {
    
    public var message: String
    
    public init(_ message: String) {
        self.message = message
    }
}
