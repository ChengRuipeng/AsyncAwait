
Pod::Spec.new do |s|

  s.name         = "AsyncAwait"
  s.version      = "0.5.0"
  s.summary      = "生成器与迭代器的OC实现"

  s.description  = <<-DESC
  生成器与迭代器的OC实现,实现类似ES6的yied语意,实现async异步块，支持在iOS项目中以同步风格编写异步代码,避免了回调链和Promise链.
                   DESC

  s.homepage     = "https://github.com/ChengRuipeng/AsyncAwait.git"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.author       = { "LuckyRoc" => "974098768@qq.com" }
  
  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source = { :git => "https://github.com/ChengRuipeng/AsyncAwait.git", :tag => "#{s.version}" }


  s.source_files  = "AsyncAwait/Class/*.{h,m,swift}"
  s.public_header_files = "AsyncAwait/Class/*.h"

  s.requires_arc = false

  s.swift_version = "5.0"

end
