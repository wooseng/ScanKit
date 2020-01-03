# ScanKit
Swift封装的二维码扫描框架

# 安装
由于此框架目前处于开发初步阶段，所以，暂时没有发布到 `Cocoapods`，但已经支持使用 `Cocoapods` 导入。
在 `Podfile` 文件中添加以下内容
```
pod 'ScanKit', :git => 'https://github.com/wooseng/ScanKit.git', :branch => '0.2'
```
然后使用 `pod install` 即可安装此框架

开发初期，更新频率会高些，见谅。

# 设备方向
此框架只针对竖直方向，如果你的APP也是只支持竖直方向，那么，你可以忽略此处，否则，请仔细阅读，并在项目中进行对应的设置。

1. 如果扫码页面是使用 `UINavigationController ` 推出的，那么需要自定义 `UINavigationController`，并在里面实现以下代码
```
override var shouldAutorotate: Bool {
    topViewController?.shouldAutorotate ?? true
}

override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    topViewController?.supportedInterfaceOrientations ?? [.portrait, .landscapeLeft, .landscapeRight]
}
    
override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
}
```

2. 如果扫码页面存在于 `UITabBarController` 中，那么需要自定义 `UITabBarController`，并在里面实现以下代码
```
override var shouldAutorotate: Bool {
    topViewController?.shouldAutorotate ?? true
}

override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    topViewController?.supportedInterfaceOrientations ?? [.portrait, .landscapeLeft, .landscapeRight]
}
    
override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
}
```


# 使用

主要有以下两种使用方式
#### 直接使用框架提供的视图控制器 `SKViewController`
```Swift
import ScanKit

let vc = SKViewController()
vc.scanCallback = { results in
    print("扫描结果", results)
}
navigationController?.pushViewController(vc, animated: true)
```

#### 自定义一个视图控制器并继承 `SKViewController`
这种方式可以满足大多数使用场景，也是最推荐的使用方式，接下来，我就主要介绍一下这种方式。

1. 自定义权限提示
框架会自动申请对应的权限，如果没有对应的权限，会弹出默认的提示框。
如果想自定义没权限时的弹窗，可以重写以下方法（不要使用 `super` 关键词）：
```
open func permissionDenied(_ type: SKPermissionType)
``` 

2. 监听扫码事件
如果是继承 `SKViewController`，可以重载
```
open func didScanFinshed(_ results: [SKResult])
``` 
方法，然后在里面写获取到码内容后的相关逻辑
当然，也可以设置以下闭包回调的值，效果是一样的 
```
public var scanCallback: (([SKResult]) -> Void)?
```

3. 手电筒控制
框架提供了以下属性与方法，方便控制手电筒
```
/// 手电筒是否可用
var isTorchEnable: Bool { get }
    
/// 手电筒是否处于关闭状态
var isTorchClosed: Bool { get }
    
/// 打开手电筒
final func openTorch()
    
/// 关闭手电筒
final func closeTorch()
    
/// 切换手电筒状态
final func switchedTorch()

```

4. 修改扫码动画区域

直接实例化一个 `SKScanArea`，修改其中的属性，然后赋值给 `scanView?.scanArea` 即可
当然，也可以直接修改属性，例如： `scanArea.width = 100`

5. 其他
源码中注释我会尽量写详细，方便自己研究。


