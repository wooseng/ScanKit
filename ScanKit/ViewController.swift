//
// ViewController.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/9/18.
// Copyright © 2019 残无殇. All rights reserved.
//


import UIKit
import Sources

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = SKViewController()
        vc.scanCallback = { results in
            print("扫描结果", results)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

}

