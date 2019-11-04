//
// UIImage+Xcassets.swift
// Sources
//
// Create by wooseng with company's MackBook Pro on 2019/11/3.
// Copyright © 2019 残无殇. All rights reserved.
//


import UIKit

internal class SKHelper: NSObject {
    
    static var bundle: Bundle = {
        let tempBundle = Bundle(for: SKHelper.classForCoder())
        if let path = tempBundle.path(forResource: "SKAssets", ofType: "xcassets"),
            let temp = Bundle(path: path) {
            return temp
        }
        return tempBundle
    }()
    
    static func image(with name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
}
