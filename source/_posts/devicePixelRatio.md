title: devicePixelRatio
date: 2015-11-26 17:09:59
tags: 前端
categories: 前端
---
![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/iphone-3.jpg)

本文所说devicePixelRatio其实指的是window.devicePixelRatio,移动端网页中设计中需要经常考虑到的一个属性。

<!--more-->

### 定义

> window.devicePixelRatio是设备上物理像素和逻辑像素的比例。
> 公式表示就是：window.devicePixelRatio = 物理像素 / 逻辑像素

测试一下：<button onclick="alert(window.devicePixelRatio);" class="btn btn-primary" type="button" style="border-radius: 9px">点击弹出window.devicePixelRatio值</button>

### 解释

![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/iphone-4.jpg)

这张图中第一行的「像素」(Points) 就是所谓的「逻辑像素」。

在 iPhone 4 前的时代，逻辑像素和物理像素是一一对应的——即，设计中的一个点对应屏幕硬件上的一个像素点。 

iPhone 4 之后，Retina 屏幕出现。在 Retina 屏幕上，使用 4 个硬件上的像素点 (2 x 2) 来表示一个逻辑像素点。
举个例子：
在开发环境中，使用 12 pt 的字体，在非 Retina 屏幕上字面高度为 12 个物理像素点；而同样是 12 pt 的字体，在 Retina (@2x) 屏幕上的字面高度，是 24 个像素点。同样，使用代码来生成的一个 20 pt x 30 pt 尺寸的举行，在非 Retina 屏幕中尺寸为 20 x 30 个物理像素；而在 Retina (@2x) 屏幕上，其尺寸为 40 x 60 个物理像素。在 Retina 屏幕上进行设计，文字尺寸、空间大小等等都应该遵照逻辑像素进行。比如，为 iPhone 4/4s （逻辑像素 320 pt x 480 pt，物理像素 620 px x 960）设计，则界面中各个元素的尺度应当以 320 x 480 为准；在 Retina 屏幕上的「2x」，可以理解为元素的精细度翻了一倍。换言之，多出来的那些像素并不是用来显示更多内容的，而是用来提高这些内容的精细程度的。这样，同样界面在 iPhone 4/4s 和旧设备上的差别，就仅在于画面的精细程度，而非内容的多寡。使用设计软件制作界面元素时尺寸的翻倍，也是为了提高精细度；在开发环境中，仍是按照 @1x 的逻辑来设计界面；如果误用 @2x 的尺度，则会导致文字、控件等过小。

iPhone 6 Plus 的逻辑像素为 414 pt x 736 pt, 而其使用了新一代的 Retina 屏幕 (@3x)，换言之，如果按照上述的显示方式，物理像素理应为 1242 px x 2208 px。 从图中 iPhone 6 Plus 的「渲染像素」亦可以看到这一个值。

### 使用场景

假设你的jsapi中的ui，img布局是基于@1x的逻辑来设计的，那么在后续@2x、@3x的设备展示时就会出现偏小的情况。
解决方案为根据不同的设备加载相应尺寸的设备。即在@2x的设备中尺寸翻倍。

如果没有设计适配逻辑，又想使用默认的@1x的效果，则可以使用：

```
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
```

指明网页宽度采用设备宽度，缩放比例为1。则浏览器会按照你设定的px去显示，而不会缩小至1/2/、1/3。
