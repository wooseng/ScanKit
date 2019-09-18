Pod::Spec.new do |spec|

  spec.name         = "ScanKit"
  spec.version      = "0.0.1"
  spec.summary      = "Swift扩展框架"
  spec.description  = <<-DESC
	一个使用Swift开发的二维码扫描框架
                        DESC

  spec.homepage     = "https://github.com/wooseng/ScanKit"
  spec.license      = "LICENSE"
  spec.author       = { "wooseng" => "zhanbaocheng@vip.qq.com" }
  spec.platform     = :ios, "10.0"
# spec.ios.deployment_target = "10.0"
# spec.osx.deployment_target = "10.7"
# spec.watchos.deployment_target = "2.0"
# spec.tvos.deployment_target = "9.0"

  spec.source = { :git => 'https://github.com/wooseng/ScanKit.git', :tag => spec.version }
  spec.source_files  = "Sources/*.swift", "Sources/**/*.swift"
# spec.public_header_files = "Classes/**/*.h"

  spec.swift_version = '5.0'
  spec.requires_arc = true
# spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

# 以下为需要依赖的系统框架和库
# spec.framework  = "SomeFramework"
# spec.library   = "iconv"

# 以下为需要依赖的第三方的pod库, 如果有多个依赖，则换行接着写, 依赖的写法与Podfile中的写法一致
# spec.dependency "SnapKit"

end
