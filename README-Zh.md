#psd2html

---

psd2html是一个可以通过特定ps约定来自动生成html的ruby命令行程序。
psd2html会自动解析你的psd文件生成相应的html代码包括css。生成的代码都是使用绝对定位实现的，因此psd2html适合的场景为对性能，html语义都不是要求很高的场景，比如只有几天寿命的活动页面。

应该说完美的psd2html的解决方案几乎是不存在的。经过一些调研，最终确定了使用一种约定生成的方式。


###安装与使用
使用gem安装
```
gem install psd2html
```
之后可以在ruby中引入
比如 example.rb
```
require './psd2html.rb'
psd = Psd2Html.new('./example.psd')
puts psd.render()
```
你可以这么调用
```
ruby example.rb > test.html
```
打开生成的test.html就可以看到完整100%还原的效果了
当然不是所有的psd都可以的，必须是遵循一定的规范的psd才行


### psd规范

我们看下下面的这个psd文件。


可以看到

###接口定义
Psd2Html.new会返回一个根节点
接口非常简单，总共有下面这些:
* render_css 返回生成的css
* render_html 返回生成的html
* render 返回整个页面，包括css和html



