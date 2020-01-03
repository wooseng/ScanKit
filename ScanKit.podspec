Pod::Spec.new do |spec|

  spec.name         = "ScanKit"
  spec.version      = "0.2.0-pre.2"
  spec.summary      = "Swift扩展框架"
  spec.description  = <<-DESC
	一个使用Swift开发的二维码扫描框架
                        DESC

  spec.homepage     = "https://github.com/wooseng/ScanKit"
  spec.license      = "LICENSE"
  spec.author       = { "wooseng" => "zhanbaocheng@vip.qq.com" }
  spec.platform     = :ios, "10.0"
  spec.source = { :git => 'https://github.com/wooseng/ScanKit.git', :tag => spec.version }
  spec.source_files  = "Sources/*.swift", "Sources/**/*.swift"
  spec.resources    = "Sources/SKAssets.xcassets"
  spec.swift_version = '5.0'
  spec.requires_arc = true

end
