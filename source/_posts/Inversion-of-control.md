title: Inversion of control
date: 2015-11-27 18:20:53
tags: ioc
categories: 设计模式
---
![Inversion of control](http://7xnq6l.com1.z0.glb.clouddn.com/ioc.jpg)

Spring的优点有哪些？不假思索：[IOC（控制反转）](http://baike.baidu.com/link?url=CfxqS05F9QAY1-D2Hu4_iE4sn_snM43ySW24TbFQj9k2N2cDA6_RO1xtElZkEpUsUlXcSLoFdA293e3mV6WKpq)、AOP（面向切面）。既然它是优点，而且是公认优秀框架的优点，你有没有在你的日常工作中或者思维方式中使用过？此处默哀三分钟...

<!--more-->

接下来以亲身经历说下IOC的好处。

需求：
前不久写用于H5游戏关于实时pvp的jsapi，需要实时获取玩家的得分继续后续操作。

方案：
1.api定义一个funciton作为入口让接入方调用。
2.接入方提供一个返回得分的funtion作为参数传给api。

好好琢磨下这两种情况的优缺点！

假设一下：
1.接入方的游戏得分一直在变化，甚至在一个while(true){...}中，他会把你的代码放到了循环中，导致api的代码1秒被调用3次，甚至更多。如果的你的api中是采用Http异步通讯，把当前得分上传到服务器。游戏跑起来会导致一个什么情况呢，页面假死了，而且并发量增加以后服务扛不住了。
2.假设api还是Http异步通讯，但是是在我需要发请求的时候才调用。比如setTimeinteval一下，你接入方把分数发给我，api每隔2秒上传一下。

总结：
api应保持独立性和安全性，对外提供的入口一定不能影响内部的正常运行。所以主动权一定到转移到己方。说直白一点，你的方法再好，再巧妙，对方不按照规矩办事你也无可奈何。

案例虽简，重在思维，重在应用。