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

之后这么调用
```
psd2html ./example/simple.psd ./simple.html
```
打开生成的test.html就可以看到完整100%还原的效果了
生成的代码如下：
```
<meta charset="utf-8" />
<style type="text/css">
    .root-container{ position:relative; } .block-link-container0{ position:absolute;
    display:inline-block; width:266px; height:376px; left:203px; top:35px;
    z-index:11; } .text-0f0e8d4c3316eafc1d2e5b01f0306674{ position:absolute;
    display:inline-block; width:75px; height:15px; left:175px; top:295px; z-index:26;
    font-family: microsoft yahei, SimSun, AdobeInvisFont; font-size: 12.0px;
    color: #ffffff; } .text-f03a7af702e833e4cb363908e77f0773{ position:absolute;
    display:inline-block; width:63px; height:14px; left:16px; top:296px; z-index:25;
    font-family: microsoft yahei, TRENDS, SimSun, AdobeInvisFont; font-size:
    12.0px; color: #ffffff; } .text-475a707230fa4b0685d731ceb38ce420{ position:absolute;
    display:inline-block; width:145px; height:15px; left:60px; top:257px; z-index:24;
    font-family: microsoft yahei, TRENDS, SimSun, AdobeInvisFont; font-size:
    12.0px; color: #ffffff; } .img-39fea138e0f71a1b807577b9a7f752b7{ position:absolute;
    display:inline-block; border:none; width:232px; height:42px; left:16px;
    top:333px; z-index:23; } .img-1c7ebfa3973f7a478aae490cfe662d4c{ position:absolute;
    display:inline-block; border:none; width:230px; height:230px; left:18px;
    top:10px; z-index:22; } .img-5a703be8b05a4c18bea1f4eb05eba132{ position:absolute;
    display:inline-block; border:none; width:266px; height:376px; left:0px;
    top:0px; z-index:21; }
</style>
<div class="root-container">
    <a class="block-link-container0" href="#">
        <div style="position:relative;">
            <span class="text-0f0e8d4c3316eafc1d2e5b01f0306674">
                促销价:￥188
            </span>
            <span class="text-f03a7af702e833e4cb363908e77f0773">
                原价:￥786
            </span>
            <span class="text-475a707230fa4b0685d731ceb38ce420">
                中年大码优雅简约雪纺衬衫
            </span>
            <img class="img-39fea138e0f71a1b807577b9a7f752b7" src="./img-source-39fea138e0f71a1b807577b9a7f752b7-1400059230.png"
            />
            <img class="img-1c7ebfa3973f7a478aae490cfe662d4c" src="./img-source-1c7ebfa3973f7a478aae490cfe662d4c-1400059230.png"
            />
            <img class="img-5a703be8b05a4c18bea1f4eb05eba132" src="./img-source-5a703be8b05a4c18bea1f4eb05eba132-1400059231.png"
            />
        </div>
    </a>
</div>
```
当然不是所有的psd都可以的，必须是遵循一定的规范的psd才行



### psd规范

我们看下下面的这个psd文件。
![图层](http://blogzwk.qiniudn.com/aa.JPG)

对应的效果为
![效果](http://blogzwk.qiniudn.com/22.jpg)

可以看到这是一个典型的宝贝区块的psd文件
注意到每个内容后面我们都使用了`|标记`

比如促销价后面跟的是text，它将告诉我们的解析器把它当成一个文本处理这样解析引擎就会生成一个字体的html容器。而按钮图后面跟的是img，代表将当前图层当做图片处理，这样引擎就会生成一个img的html代码。
block则代表一个区块，也就是一个容器，用来包裹里面的内容。

注意到block前面的container了没。container将作为生成的html容器的class名称。
所以完整的命名为 标题|class名称|类型约定

具体的逻辑是这样的：
1. 通过|来分割标记，如果有类型约定，也有class名称，就会正常赋值
2. 如果只有一个类型约定标记，就会使用标题作为class，标题为英文最好，如果是中文的话，会使用MD5生成一个串作为class。

类型约定是整个工具的灵魂。它将告诉引擎怎么解析图层。目前总共有下面这些类型约定:

1. block 根据图层信息，生成一个容器。类似这样 `<div style="position:absolute"><div style="position：relative">...</div></div>`,容器会对外绝对定位，对内相对定位。所有容器的子节点都相对父节点定位。
2. block-link block的变种，不同的是外面不再是div，而是变成了可以点击的a标记。
3. text 根据图层信息，生成一个span容器，里面是文字内容。
4. text-link text的变种。外面会是a标记，这样变得可点击。
5. img 根据图层信息，生成一个img标签。
6. img-link img的变种，会在img外面包一层a标记，变的可点击。
7. img-bg img的变种，会将当前图片作为父节点的背景图像。

> 注意，如果外面容器是 block-link，子图层最好不要再出现xxx-link的东西，不然就会生成a标记里面套a标记的代码，浏览器是不能正常识别的

