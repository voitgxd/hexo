title: java-h5
date: 2015-11-20 19:05:32
tags: [java,h5]
categories: java
---

![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/zhpmh.png)

为了应付 [甄嬛传](http://z.8864.com/) 手游的发布，上层建筑下命令了，宣传必须要到位，必须要向当前的流量大户靠近，比如某鹅厂的某个圈子。于是乎，身处的游戏公司理所当然的就造出了这么个游戏，[“甄嬛拍卖会”](http://games.huobaoyx.com/h5/apps/13326/auctioneerSalls/index.html)，于是乎，某某猿就开始为其折腾。

<!--more-->

说到java做游戏服务器方案，mina、netty风头正盛，但这些庞然大物都不适合当前情况，一是需求，二是时间。好吧，接下来说下这个 nx 的需求。

1.玩家每次游戏结束可以看到自己的得分排名和击败人数比例
2.击败比例超过50%发放甄嬛传手游的礼包码
3.游戏挂掉可以使用复活币复活
4.复活币不足提供支付宝充值
5....没了...

然后...没了，如此精简的需求，取上不足，拿netty折腾一番，实在不划算，取下...，好吧，搞个WEB项目吧。默默合计下，1、2可以用现有的js API搞定，只需要KO后俩，一向动手即Spring、Sturts成习惯，发现搭个这么完整的MVC框架，却用来处理仅仅几个请求，而且用不到视图层。然后...，好吧，Servlet。

于是乎，一个游戏服务器，变成了一个Servlet工程。

不扯了，接下来说正题，解决方案和此文**目的所在**。为节省时间项目所用到其他框架：
1.Spring 仅使用其容器对Bean对象进行管理
2.Google guava 仅使用其cache模块实现本地缓存管理
3.其他原生

此文主要为了记录下过程中遇到麻烦的三个点：

### Spring管理Servlet

方法：把servlet配置为spring的bean，然后将bean名称作为属性注入到代理servlet，使用代理servlet统一配置和运行。
代理servlet：

```
private String targetServlet;//bean名称
private Servlet target;//根据名称获得的Servlet对象

ServletContext context = this.getServletContext();
WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(context);
this.target = (Servlet) wac.getBean(targetServlet);
```

### JS跨域访问

因为游戏是使用白鹭引擎做的H5游戏，要和服务器通信xhr请求必须加Access-Control-Allow-Origin头，问题的关键就在这里，服务器在什么时机给请求加这个头？

```
response.addHeader("Access-Control-Allow-Origin", accessOrigin);
```

这里要说下浏览器的同源策略，不同域的客户端脚本不能读写对方的资源。但是实践中有一些场景需要跨域的读写，所以在XMLHttpRequest v2标准下，提出了CORS(Cross Origin Resourse-Sharing)的模型。

CORS定义了两种跨域请求，简单跨域请求和非简单跨域请求。当一个跨域请求发送简单跨域请求包括：请求方法为HEAD，GET，POST;请求头只有4个字段，Accept，Accept-Language，Content-Language，Last-Event-ID;如果设置了Content-Type，则其值只能是application/x-www-form-urlencoded,multipart/form-data,text/plain。

当需要发送一个跨域请求的时候，浏览器会首先检查这个请求，如果它符合上面所述的简单跨域请求，浏览器就会立刻发送这个请求。如果浏览器检查之后发现这是一个非简单请求，比如请求头含有X-Forwarded-For字段。这时候浏览器不会马上发送这个请求，而是有一个Preflighted requests（先导请求），跟服务器验证的过程。浏览器先发送一个options方法的预检请求。

解释 [原文](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#Access-Control-Request-Method) 。简单来说，有两种方法让浏览器识别你的请求为非简单请求。
1.自定义一个消息头

```
xhr.setRequestHeader('G_NAME', 'zhenhuan');
```

2.发送请求携带coocie信息

```
xhr.withCredentials = true;//发送HTTP Cookies和验证信息
```

### 过滤器机制

出现问题的情境：
加允许访问的消息头的逻辑是用CorsFilter实现的，位于

```
filterchain.doFilter(servletrequest, servletresponse);
```

的下部，但是我servlet写出消息之后把response流关闭了，然后过滤器的流对象就处于关闭状态了，

```
response.addHeader("Access-Control-Allow-Origin", accessOrigin);
```

上述操作一直不成功。

此处的**位置**非常关键，因为过滤器在执行你的servlet代码之前顺序执行了第一句代码的前半部分，执行完servlet代码之后才倒序执行了后半部分，所以流对象被关闭了。