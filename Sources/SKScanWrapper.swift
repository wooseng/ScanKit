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

public class SKScanWrapper: NSObject {

    // 扫描结果的回调
    public var scanCallback: (([AVMetadataObject]) -> Void)?
    
    // 会话对象
    private lazy var _session: AVCaptureSession = {
        let temp = AVCaptureSession()
        temp.sessionPreset = .hd1920x1080 // 设置会话采集率
        return temp
    }()
    
    // 预览视图
    private var _previewLayer: AVCaptureVideoPreviewLayer?
    
    // 是否已经执行过初始化操作
    private var _isInitialized = false
    
    // 预览视图的容器
    private weak var _container: UIView?
}

//MARK: - 公开方法
public extension SKScanWrapper {
    
    // 设置预览图层的容器
    func setContainer(_ view: UIView) {
        _container = view
        guard let layer = _previewLayer else {
            return
        }
        layer.frame = view.bounds
        view.layer.insertSublayer(layer, at: 0)
    }
    
    // 重置预览视图的 Frame
    func resize(_ rect: CGRect) {
        _previewLayer?.frame = rect
    }
    
    // 开始运行扫描器
    func startRunning() {
        if !_isInitialized {
            setupDeviceInput()
            setupMetadataOutput()
            setupVideoDataOutput()
            setupPreviewLayer()
            _isInitialized = true
        }
        if !_session.isRunning {
            _session.startRunning()
        }
    }
    
    // 停止运行扫描器
    func stopRunning() {
        if _session.isRunning {
            _session.stopRunning()
        }
    }
    
}

//MARK: - 私有方法
private extension SKScanWrapper {
    
    // 设置摄像设备输入流
    func setupDeviceInput() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if _session.canAddInput(input) {
                _session.addInput(input)
            }
        } catch {
            return
        }
    }
    
    // 设置元数据输出流
    func setupMetadataOutput() {
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 设置扫描范围（每一个取值0～1，以屏幕右上角为坐标原点）
        output.rectOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        
        // 添加元数据输出流到会话对象
        if _session.canAddOutput(output) {
            _session.addOutput(output)
        }
        
        // 设置数据输出类型(如下设置为条形码和二维码兼容)，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
        output.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]
    }
    
    // 设置摄像数据输出流 (用于识别光线强弱)
    func setupVideoDataOutput() {
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        if _session.canAddOutput(output) {
            _session.addOutput(output)
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
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        scanCallback?(metadataObjects)
    }
    
}

extension SKScanWrapper: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput,
                              didDrop sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {
        
    }
    
    public func captureOutput(_ output: AVCaptureOutput,
                              didOutput sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {
        
    }
    
}
