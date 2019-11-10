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
    
    internal var scanCallback: (([SKResult]) -> Void)? // 扫描结果的回调
    internal var wrapperStateDidChange: ((SKScanWrapperState) -> Void)? // 扫描器状态改变的回调
    internal var captureVideoOrientation = AVCaptureVideoOrientation.portrait // 预览方向
    internal var isDetectorEnable = true // 是否开启探测器进行识别
    internal var isDetectPreviewEnable = false { // 是否开启探测器预览视图
        didSet {
            _detectPreview.isHidden = !isDetectPreviewEnable
            _detector.delete = isDetectPreviewEnable ? self : nil
        }
    }
    internal private(set) var wrapperState = SKScanWrapperState.normal { // 扫描器的状态
        didSet {
            wrapperStateDidChange?(wrapperState)
        }
    }
    
    private var _lastCallbackTime = Date.distantPast // 上次回调结果的时间，用来控制回调的频率
    private var _previewLayer: AVCaptureVideoPreviewLayer? // 预览视图
    private weak var _container: UIView? // 预览视图的容器
    private var _scanAreaRect = CGRect.zero // 扫码区域的原始Rect
    private lazy var _session: AVCaptureSession = { // 会话对象
        let temp = AVCaptureSession()
        
        // 设置会话采集率
        temp.sessionPreset = .high
        return temp
    }()
    
    private lazy var _inputDevice: AVCaptureDevice? = {
        let temp = AVCaptureDevice.default(for: .video)
        do {
            try temp?.lockForConfiguration()
            temp?.focusMode = .continuousAutoFocus
            temp?.unlockForConfiguration()
        } catch { }
        return temp
    }()
    
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
        // 设置扫描范围（每一个取值0～1，以屏幕左上角为坐标原点）
        temp.rectOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
        return temp
    }()
    
    // 摄像数据输出流 (用于识别光线强弱)
    private lazy var _videoDataOutput: AVCaptureVideoDataOutput = {
        let temp = AVCaptureVideoDataOutput()
        temp.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        return temp
    }()
    
    // 图片探测器
    private lazy var _detector = SKDetector()
    
    // 图片探测器正在工作
    private var _isDetecting = false
    
    // 探测器预览视图
    private lazy var _detectPreview: UIImageView = {
        let temp = UIImageView()
        temp.frame = CGRect(x: 20, y: 80, width: 150, height: 150)
        temp.contentMode = .scaleAspectFill
        temp.clipsToBounds = true
        temp.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        return temp
    }()
    
    deinit {
        SKLogWarn("deinit:", self.classForCoder)
    }
}

//MARK: - 公开方法
internal extension SKScanWrapper {
    
    /// 设置预览图层的容器
    func setContainer(_ view: UIView) {
        _container = view
        _container?.addSubview(_detectPreview)
        guard let layer = _previewLayer else {
            return
        }
        layer.frame = view.bounds
        view.layer.insertSublayer(layer, at: 0)
    }
    
    /// 重置预览视图的 Rect 和 扫描区域的 Rect
    func resize(_ rect: CGRect, rectOfScan: CGRect) {
        _detectPreview.frame = rectOfScan
        guard let layer = _previewLayer else {
            return
        }
        var needResetRectScanArea = false
        if !layer.frame.equalTo(rect) {
            layer.frame = rect
            needResetRectScanArea = true
        }
        if !rectOfScan.equalTo(_scanAreaRect) {
            _scanAreaRect = rectOfScan
            needResetRectScanArea = true
        }
        if captureVideoOrientation != layer.connection?.videoOrientation {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
                layer.connection?.videoOrientation = self.captureVideoOrientation
            }
            SKLogPlain("预览图层方向改变")
            needResetRectScanArea = false
        }
        SKLogPlain("重置预览视图Rect")
        if needResetRectScanArea {
            resetScanArea(rectOfScan)
        }
    }
    
    /// 开始运行扫描器
    /// 如果开始运行的时候，会话并没有启动，则会先进行启动
    /// 如果要监控启动的状态，可以设置状态回调的闭包 wrapperStateDidChange
    func startRunning(_ complete: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            if self.wrapperState == .normal {
                self.wrapperState = .loading
                self.setupDeviceInput()
                self.setupMetadataOutput()
                self.setupVideoDataOutput()
                self.setupPreviewLayer()
                self.wrapperState = .loaded
            }
            if self.canStartRunning {
                self.wrapperState = .starting
                DispatchQueue.global().async {
                    self._session.startRunning()
                    DispatchQueue.main.async {
                        self.wrapperState = .started
                        complete?(true)
                    }
                }
            } else {
                complete?(false)
            }
        }
    }
    
    /// 停止运行扫描器
    func stopRunning(_ complete: ((Bool) -> Void)? = nil) {
        guard canStopRunning else {
            complete?(false)
            return
        }
        wrapperState = .stoping
        DispatchQueue.global().async {
            self._session.stopRunning()
            DispatchQueue.main.async {
                self.wrapperState = .stoped
                complete?(true)
            }
        }
    }
    
    /// 重新运行扫描器
    func restartRunning(_ complete: ((Bool) -> Void)?) {
        SKLogPlain("重启扫描器")
        stopRunning { [weak self] stopResult in
            if stopResult {
                self?.startRunning(complete)
            } else {
                complete?(false)
            }
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

//MARK: - 私有计算属性
private extension SKScanWrapper {
    
    // 会话是否可以启动运行
    var canStartRunning: Bool {
        return !_session.isRunning && (wrapperState == .loaded || wrapperState == .stoped)
    }
    
    // 会话是否可以停止运行
    var canStopRunning: Bool {
        return _session.isRunning && wrapperState == .started
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
    
    // 重置扫描区域的Rect
    func resetScanArea(_ rect: CGRect) {
        DispatchQueue.global().async {
            guard var targetRect = self._previewLayer?.metadataOutputRectConverted(fromLayerRect: rect),
                !self._metadataOutput.rectOfInterest.equalTo(targetRect) else {
                return
            }
            targetRect.origin.x = max(0, targetRect.origin.x)
            targetRect.origin.y = max(0, targetRect.origin.y)
            targetRect.size.width = min(1, targetRect.size.width)
            targetRect.size.height = min(1, targetRect.size.height)

            self._session.beginConfiguration()
            self._metadataOutput.rectOfInterest = targetRect
            self._session.commitConfiguration()
            SKLogPlain("重置扫描区域的Rect", self._metadataOutput.rectOfInterest)
        }
    }
    
    // 扫描到数据后，必须通过此方法进行回调，此方法里对回调频率做了控制，避免极短时间内回调很多次
    func didScanResults(_ results: [SKResult]) {
        let date = Date()
        guard date.timeIntervalSince(_lastCallbackTime) >= 1 else {
            return
        }
        _lastCallbackTime = date
        objc_sync_enter(self)
        scanCallback?(results)
        objc_sync_exit(self)
    }
    
}


extension SKScanWrapper: AVCaptureMetadataOutputObjectsDelegate {
    
    // 扫描获取到的数据输出回调
    internal func metadataOutput(_ output: AVCaptureMetadataOutput,
                                 didOutput metadataObjects: [AVMetadataObject],
                                 from connection: AVCaptureConnection) {
        let size = _previewLayer?.bounds.size ?? CGSize.zero
        let results = metadataObjects.map { SKResult($0, size: size) }
        if !results.isEmpty {
            didScanResults(results)
        }
    }
    
}

extension SKScanWrapper: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    internal func captureOutput(_ output: AVCaptureOutput,
                                didOutput sampleBuffer: CMSampleBuffer,
                                from connection: AVCaptureConnection) {
        guard isDetectorEnable, !_isDetecting else {
            return
        }
        _isDetecting = true
        DispatchQueue.global().async {
            do {
                let results = try self._detector.detect(from: sampleBuffer)
                if !results.isEmpty {
                    DispatchQueue.main.async {
                        self.didScanResults(results)
                    }
                }
            } catch let error {
                let e = error as? SKError
                SKLogError(e?.message)
            }
            self._isDetecting = false
        }
    }
    
}

extension SKScanWrapper: SKDetectorDelete {
    
    func detector(_ detector: SKDetector, didOutput output: UIImage) {
        _detectPreview.image = output
    }
    
}
