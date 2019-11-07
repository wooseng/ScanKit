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
        title = "哈哈"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        scanView?.switchedTorch()
        if arc4random() % 2 == 0 {
            scanView?.scanArea.turnIntoWechat()
        } else {
            scanView?.scanArea.turnIntoAlipay()
        }
        scanView?.scanArea.offsetY = -60
    }
    
    override func didScanStartRunning() {
        super.didScanStartRunning()
        scanView?.isLimitRecognitionArea = true
    }
    
}
