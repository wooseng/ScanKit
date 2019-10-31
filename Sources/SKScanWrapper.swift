//
// SKScanWrapper.swift
// ScanKit
//
// Create by wooseng with company's MackBook Pro on 2019/9/18.
// Copyright © 2019 残无殇. All rights reserved.
//
//  摄像头扫描器
//


import UIKit
import AVFoundation

internal class SKScanWrapper: NSObject {

    // 扫描结果的回调
    internal var scanCallback: (([SKResult]) -> Void)?
    
    // 会话对象
    private lazy var _session: AVCaptureSession = {
        let temp = AVCaptureSession()
        temp.sessionPreset = .hd1920x1080 // 设置会话采集率
        return temp
    }()
    
    private lazy var _inputDevice = AVCaptureDevice.default(for: .video)
    private lazy var _input: AVCaptureDeviceInput? = {
        guard let device = _inputDevice,
            let input = try? AVCaptureDeviceInput(device: device) else {
            return nil
        }
        return input
    }()
    
    // 元数据输出流
    private lazy var _metadataOutput: AVCaptureMetadataOutput = {
        let temp = AVCaptureMetadataOutput()
        temp.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 设置扫描范围（每一个取值0～1，以屏幕右上角为坐标原点）
        temp.rectOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
        return temp
    }()
    
    // 摄像数据输出流 (用于识别光线强弱)
    private lazy var _videoDataOutput: AVCaptureVideoDataOutput = {
        let temp = AVCaptureVideoDataOutput()
        temp.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        return temp
    }()
    
    // 预览视图
    private var _previewLayer: AVCaptureVideoPreviewLayer?
    
    // 是否已经执行过初始化操作
    private var _isInitialized = false
    
    // 预览视图的容器
    private weak var _container: UIView?
    
    deinit {
        SKLogWarn("deinit:", self.classForCoder)
    }
}

//MARK: - 公开方法
internal extension SKScanWrapper {
    
    /// 设置预览图层的容器
    func setContainer(_ view: UIView) {
        _container = view
        guard let layer = _previewLayer else {
            return
        }
        layer.frame = view.bounds
        view.layer.insertSublayer(layer, at: 0)
    }
    
    /// 重置预览视图的 Frame
    func resize(_ rect: CGRect) {
        _previewLayer?.frame = rect
    }
    
    /// 开始运行扫描器
    func startRunning() {
        DispatchQueue.main.async {
            if !self._isInitialized {
                self.setupDeviceInput()
                self.setupMetadataOutput()
                self.setupVideoDataOutput()
                self.setupPreviewLayer()
                self._isInitialized = true
            }
            if !self._session.isRunning {
                self._session.startRunning()
            }
        }
    }
    
    /// 停止运行扫描器
    func stopRunning() {
        guard _session.isRunning else {
            return
        }
        DispatchQueue.main.async {
            self._session.stopRunning()
        }
    }
    
}

//MARK: - 手电筒相关操作
internal extension SKScanWrapper {
    
    /// 手电筒是否可用
    var isTorchEnable: Bool {
        guard let device = _inputDevice else {
            return false
        }
        return device.hasTorch && device.isTorchAvailable
    }
    
    /// 手电筒是否处于关闭状态
    var isTorchClosed: Bool { _inputDevice?.torchMode == AVCaptureDevice.TorchMode.off }
    
    /// 打开手电筒
    func openTorch() {
        setTorchMode(.on)
    }
    
    /// 关闭手电筒
    func closeTorch() {
        setTorchMode(.off)
    }
    
    /// 切换手电筒状态
    func switchedTorch() {
        if isTorchClosed {
            setTorchMode(.on)
        } else {
            setTorchMode(.off)
        }
    }
    
    // 设置手电筒模式
    private func setTorchMode(_ mode: AVCaptureDevice.TorchMode) {
        do {
            try _inputDevice?.lockForConfiguration()
            _inputDevice?.torchMode = mode
            _inputDevice?.unlockForConfiguration()
        } catch {
            SKLogError("设置手电筒模式失败")
        }
    }
}

//MARK: - 私有方法
private extension SKScanWrapper {
    
    // 设置摄像设备输入流
    func setupDeviceInput() {
        guard let input = _input, _session.canAddInput(input) else {
            return
        }
        if _session.canAddInput(input) {
            _session.addInput(input)
        }
    }
    
    // 设置元数据输出流
    func setupMetadataOutput() {
        // 添加元数据输出流到会话对象
        if _session.canAddOutput(_metadataOutput) {
            _session.addOutput(_metadataOutput)
        }
        
        // 设置数据输出类型(如下设置为条形码和二维码兼容)，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
        _metadataOutput.metadataObjectTypes = [
            .qr, .ean13, .ean8, .code93, .code128, .dataMatrix, .code39, .code39Mod43, .aztec
        ]
    }
    
    // 设置摄像数据输出流 (用于识别光线强弱)
    func setupVideoDataOutput() {
        if _session.canAddOutput(_videoDataOutput) {
            _session.addOutput(_videoDataOutput)
        }
    }
    
    // 设置预览图层
    func setupPreviewLayer() {
        _previewLayer = AVCaptureVideoPreviewLayer(session: _session)
        
        // 保持纵横比；填充层边界
        _previewLayer?.videoGravity = .resizeAspectFill
        
        if let view = _container {
            _previewLayer?.frame = view.bounds
            view.layer.insertSublayer(_previewLayer!, at: 0)
        }
    }
}


extension SKScanWrapper: AVCaptureMetadataOutputObjectsDelegate {
    
    // 扫描获取到的数据输出回调
    internal func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        let result = metadataObjects.map {
            SKResult($0)
        }
        scanCallback?(result)
    }
    
}

extension SKScanWrapper: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    internal func captureOutput(_ output: AVCaptureOutput,
                              didDrop sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {
        
    }
    
    internal func captureOutput(_ output: AVCaptureOutput,
                              didOutput sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {
        
    }
    
}
