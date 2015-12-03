title: Java-PK对战游戏
date: 2015-12-03 11:40:10
tags: 游戏
categories: java
---
![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/pkgame.jpg)

提到实时pvp对战，大多都是使用相关的游戏服务器框架实现的，这篇文章就来告诉你如何使用纯java开发一个支持实时pk对战的web服务器。

### 数据结构

![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/pk_controller.png)

使用六个ConcurrentMap存储相关信息，分别为玩家信息、房间信息、匹配成功以后的玩家房间信息（方便在游戏过程中对玩家的操作）、玩家等待队列、未满房间队列（LinkedBlockingQueue）、未满房间栈（LinkedBlockingDeque）。

### 控制逻辑

玩家：
1.加入游戏
2.匹配
3.匹配成功
4.准备就绪
5.开始游戏
6.游戏结束

中央控制器：
1.创建玩家
2.将玩家加入等待队列，并调用线程池执行一次匹配操作
3.创建房间并将匹配到的玩家添加到房间中
4.玩家状态置为ready
5.置状态开始接受玩家请求
6.返回得分并清除房间

匹配任务：
1.从该游戏的等待队列中poll一个玩家出来。
2.查找该游戏的未满房间栈：如果不为空则poll栈顶房间，将玩家加入，如果房间还未满，再将房间入栈。
3.如果未满房间栈为空，则查找未满房间队列：不为空则poll队列房间加入玩家，未满则将该房间入未满房间栈。
4.如果未满房间队列为空，则从等待队列再poll一个玩家创建房间并将房间加入该游戏的未满房间队列。

具体代码实现相信看懂的人都能搞定吧！具体效果请搜索 “火爆游戏”。