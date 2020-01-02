//
// ScanViewController.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/10/30.
// Copyright © 2019 残无殇. All rights reserved.
//


import UIKit
import Sources

class ScanViewController: SKViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扫一扫"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if arc4random() % 2 == 0 {
            scanArea.turnIntoCursorStyle()
        } else {
            scanArea.turnIntoGridStyle()
        }
//        scanArea.offsetY = -CGFloat(arc4random() % 100)
//        setOutsideTheScanArea(UIColor.random().withAlphaComponent(0.3))
    }
    
}
