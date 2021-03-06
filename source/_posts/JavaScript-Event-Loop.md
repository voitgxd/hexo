title: JavaScript Event Loop
date: 2015-11-27 17:29:13
tags: JavaScript
categories: JavaScript
---
![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/jscallback.png)

前不久写jsapi的时候陷入一层层的无限回调之中，因为api需要保证独立性与安全性，通常是自定义与服务器端的通信机制，而且一般都是异步调用。当逻辑比较复杂，又要求同步的时候就会出现多层回调的情况。

<!--more-->

事后琢磨了下js的运行机制，心得记录下。

大学学通信的时候书上重点介绍了个两个名词：“进程” “线程”。课后练习仅仅fork了一个进程输出了下“Hello process”，
一般情况下，一个进程一次只能执行一个任务。
如果有很多任务需要执行，有三种解决方法。

> 1、排队。因为一个进程一次只能执行一个任务，只好等前面的任务执行完了，再执行后面的任务。
>  2、新建进程。为每个任务新建一个进程。
> 3、新建线程。因为进程太耗费资源，所以如今的程序往往允许一个进程包含多个线程，由线程去完成任务。

JavaScript语言的一大特点就是单线程，也就是说，同一个时间只能做一件事。js的单线程，与它的用途有关。作为浏览器脚本语言，JavaScript的主要用途是与用户互动，以及操作DOM。所有任务可以分成两种，一种是同步任务（synchronous），另一种是异步任务（asynchronous）。

同步任务:在主线程上排队执行的任务，只有前一个任务执行完毕，才能执行后一个任务；
异步任务:不进入主线程、而进入"任务队列"（task queue）的任务，只有"任务队列"通知主线程，某个异步任务可以执行了，该任务才会进入主线程执行。

![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/EventLoop.png)

运行机制：
1、所有同步任务都在主线程上执行，形成一个执行栈（execution context stack）。
2、主线程之外，还存在一个"任务队列"（task queue）。只要异步任务有了运行结果，就在"任务队列"之中放置一个事件。
3、一旦"执行栈"中的所有同步任务执行完毕，系统就会读取"任务队列"，看看里面有哪些事件。那些对应的异步任务，于是结束等待状态，进入执行栈，开始执行。
4、主线程不断重复上面的第三步。

主线程从"任务队列"中读取事件，这个过程是循环不断的，所以整个的这种运行机制又称为Event Loop（事件循环）。
