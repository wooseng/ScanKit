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
        navigationController?.navigationBar.isTranslucent = false
        edgesForExtendedLayout = []
        view.backgroundColor = UIColor.white
        view.addSubview(_stackView)
        _stackView.addArrangedSubview(_defaultButton)
        _stackView.addArrangedSubview(_alipayButton)
        _stackView.addArrangedSubview(_wechatButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = ScanViewController()
        vc.scanCallback = { [weak self] results in
            self?.showReslut(results)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _stackView.frame = view.bounds
    }
    
    private lazy var _stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .fill
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        return sv
    }()

    private lazy var _defaultButton = Button("默认动画样式", target: self, action: #selector(buttonClickEvent(btn:)))
    private lazy var _alipayButton = Button("支付宝动画样式", target: self, action: #selector(buttonClickEvent(btn:)))
    private lazy var _wechatButton = Button("微信动画样式", target: self, action: #selector(buttonClickEvent(btn:)))
    
    @objc private func buttonClickEvent(btn: Button) {
        switch btn {
        case _defaultButton:
            let vc = SKViewController()
            vc.scanCallback = { [weak self] result in
                self?.showReslut(result)
            }
            navigationController?.pushViewController(vc, animated: true)
        case _alipayButton:
            let vc = ScanViewController()
            var area = SKScanArea()
            area.turnIntoAlipay()
            vc.scanArea = area
            vc.setOutsideTheScanArea(UIColor.yellow.withAlphaComponent(0.3))
            vc.scanCallback = { [weak self] result in
                self?.showReslut(result)
            }
            navigationController?.pushViewController(vc, animated: true)
        case _wechatButton:
            let vc = ScanViewController()
            var area = SKScanArea()
            area.turnIntoWechat()
            vc.scanArea = area
            vc.setOutsideTheScanArea(UIColor.red.withAlphaComponent(0.3))
            vc.scanCallback = { [weak self] result in
                self?.showReslut(result)
            }
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    private func showReslut(_ results: [SKResult]) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            var result = results.map { $0.stringValue }.filter { $0 != nil }.map { $0! }.joined(separator: "\n")
            if result.isEmpty {
                result = "无结果"
            }
            let alert = UIAlertController(title: "扫描结果", message: result, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

fileprivate class Button: UIButton {
    
    convenience init(_ title: String, target: Any?, action: Selector) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setTitleColor(UIColor.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

