Pod::Spec.new do |s|
s.name         = "RMCurveArea"
s.version      = "1.0.1"
s.summary      = "坐标系绘制贝塞尔曲线与x坐标形成封闭区域，区域内部背景实现颜色渐变。图标分析图。"
s.homepage     = "https://github.com/wsj2012/RMCurveArea"
s.license      = "MIT"
s.author       = { "wsj_2012" => "time_now@yeah.net" }
s.source       = { :git => "https://github.com/wsj2012/RMCurveArea.git", :tag => "#{s.version}" }
s.requires_arc = true
s.ios.deployment_target = "9.0"
s.source_files  = "RMViews/*.{h, m}"

end
