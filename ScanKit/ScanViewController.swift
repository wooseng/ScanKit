//
// ScanViewController.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/10/30.
// Copyright © 2019 残无殇. All rights reserved.
//


import UIKit
import Sources

class ScanViewController: SKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扫一扫"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        switchedTorch()
        if arc4random() % 2 == 0 {
            scanArea.turnIntoWechat()
        } else {
            scanArea.turnIntoAlipay()
        }
        scanArea.offsetY = -60
    }
    
}
