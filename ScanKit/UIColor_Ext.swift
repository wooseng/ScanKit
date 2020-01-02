//
//  UIColor_Ext.swift
//  ScanKit
//
//  Created by 稍息 on 2020/1/2.
//  Copyright © 2020 残无殇. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func random() -> UIColor {
        UIColor(red: CGFloat(arc4random() % 255) / 255,
                green: CGFloat(arc4random() % 255) / 255,
                blue: CGFloat(arc4random() % 255) / 255,
                alpha: 1)
    }
    
}
