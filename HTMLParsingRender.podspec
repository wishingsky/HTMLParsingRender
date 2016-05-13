Pod::Spec.new do |s|
  s.name         = "HTMLParsingRender"
  s.version      = "0.0.1"
  s.summary      = "HTMLParsingRender"

  s.description  = "解析html自定义标签, 原生渲染"

  s.homepage     = "https://github.com/wishingsky/HTMLParsingRender"

  s.license      = "MIT"

  s.author             = { "weixiaoyun" => "wei_xiaoyun@hotmail.com" }
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/wishingsky/HTMLParsingRender.git", :tag => s.version.to_s }

  s.source_files  = "HTMLParsingRender", "HTMLParsingRender/*.{h,m}"
  s.exclude_files = "HTMLParsingRender/Exclude"

  s.resources = "HTMLParsingRender/Resources/*.png", "HTMLParsingRender/*.txt"

  s.requires_arc = true
  
  s.dependency "DTCoreText"

end
