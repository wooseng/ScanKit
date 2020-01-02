//
//  BaseNavigationController.swift
//  ScanKit
//
//  Created by 稍息 on 2020/1/2.
//  Copyright © 2020 残无殇. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        topViewController?.shouldAutorotate ?? true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? [.portrait, .landscapeLeft, .landscapeRight]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
}
