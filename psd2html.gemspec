# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'psd2html/version'

Gem::Specification.new do |spec|
  spec.name          = "psd2html"
  spec.version       = Psd2html::VERSION
  spec.date             = Time.now.strftime('%Y-%m-%d')
  spec.authors       = ["cherishpeace"]
  spec.email         = ["xhzhuweikang@163.com"]
  spec.summary       = %q{psd2html是一个可以通过特定ps约定来自动生成html的ruby程序。支持命令行和程序内部引用。}
  spec.description   = %q{psd2html是一个可以通过特定ps约定来自动生成html的ruby命令行程序。
psd2html会自动解析你的psd文件生成相应的html代码包括css。生成的代码都是使用绝对定位实现的，因此psd2html适合的场景为对性能，html语义都不是要求很高的场景，比如只有几天寿命的活动页面。

应该说完美的psd2html的解决方案几乎是不存在的。经过一些调研，最终确定了使用一种约定生成的方式。}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "mustache"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  
end
