# ScanKit
Swift封装的二维码扫描框架

# 安装
由于此框架目前处于开发初步阶段，所以，暂时没有发布到 `Cocoapods`，但已经支持使用 `Cocoapods` 导入。
在 `Podfile` 文件中添加以下内容
```
pod 'ScanKit', :git => 'https://github.com/wooseng/ScanKit.git'
```
然后使用 `pod install` 即可安装此框架

当然，如果你愿意下载源码拖到项目里，也可以，但是不推荐，开发初步阶段会遇到很多问题，所以更新的频率会稍微高些

一般来说，在此框架 1.0.0 版本以前，推荐每周查看并更新一次，之后可以保持每月一更的频率

# 使用

主要有三种使用方式，包含了从简单基础使用，到复杂自定义使用。
#### 最简单的方式，直接使用框架提供的视图控制器 `SKViewController`
```Swift
import ScanKit

let vc = SKViewController()
vc.scanCallback = { results in
    print("扫描结果", results)
}
navigationController?.pushViewController(vc, animated: true)
```

#### 稍微复杂一点的方式，自定义一个视图控制器并继承 `SKViewController`
这种方式可以满足大多数使用场景，也是最推荐的使用方式，接下来，我就主要介绍一下这种方式。

1. 自定义权限提示
`SKViewController` 会自动申请对应的权限，想自定义没权限时的弹窗，可以重写 `open func permissionDenied(_ type: SKPermissionType)` 方法，记住，千万不要使用 `super` 关键字，不然就会弹出框架内置的提示哦

2. 需要添加子视图
由于预览视图与扫描器是异步创建的，所以，如果需要增加子视图，需要重载 `open func didScanViewSetupFinsh()` 方法，然后在里面实现相关逻辑，尽量不要在其他地方设置

3. 监听扫码事件
如果是继承 `SKViewController`，可以重载 `open func didScanFinshed(_ results: [SKResult])` 方法，然后在里面写获取到码内容后的相关逻辑
当然，也可以设置闭包回调 `public var scanCallback: (([SKResult]) -> Void)?`，效果是一样的

4. 手电筒控制

```
// 手电筒是否可用
scanView?.isTorchEnable

// 手电筒是否已关闭
scanView?.isTorchClosed

// 打开手电筒
scanView?.openTorch()

// 关闭手电筒
scanView?.closeTorch()

// 切换手电筒模式(打开或关闭)
scanView?.switchedTorch()
```
5. 修改扫码动画区域

直接实例化一个 `SKScanArea`，修改其中的属性，然后赋值给 `scanView?.scanArea` 即可

7. 其他
源码中注释应该算是写的还阔以吧，自己去研究吧


