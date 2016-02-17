title: 使用 Lombok 减少你的样板代码
date: 2016-02-17 14:55:05
tags: [java,Lombok,maven]
categories: java
---
一个强大的项目[Lombok](https://projectlombok.org/)。
好的项目在于提高效率，减少重复劳动，一个个优秀的项目前赴后继为之奋斗，Spring Framework的格言就是减少JEE的复杂度，EJB v3致力于减少样板代码，Lombok也是其中之一。

<!--more-->

[原文。](http://www.oschina.net/translate/lombok-reduces-your-boilerplate-code?cmp)

接下来开始Eclipse + Maven + Lombok环境配置。
#### 工程引入lombok包
[最新的lombok maven配置](http://mvnrepository.com/artifact/org.projectlombok/lombok/1.16.6)

```
<dependency>
	<groupId>org.projectlombok</groupId>
   	<artifactId>lombok</artifactId>
   	<version>1.16.6</version>
</dependency>
```
#### eclipse / myeclipse 手动安装 lombok
使用 lombok 是需要安装的，如果不安装，IDE 则无法解析 lombok 注解。
1. 将 lombok.jar 复制到 myeclipse.ini / eclipse.ini 所在的文件夹目录下
2. 打开 eclipse.ini / myeclipse.ini，在最后面插入以下两行并保存：
```
-Xbootclasspath/a:lombok-1.16.6.jar
-javaagent:lombok-1.16.6.jar
```
3.重启 eclipse / myeclipse
#### lombok 注解
Lombok核心特征是你需要用注解来创建代码，目的是减少你要写的样板代码的数量。它为你提供如下注解，这可能会永远改变代码（不是你的生活）：

@Getter 和 @Setter: 为你的字段创建getter和setter
@EqualsAndHashCode: 实现equals()和hashCode()
@ToString: 实现toString()
@Data: 使用上面四个注解的特征
@Cleanup: 关闭流
@Synchronized: 对象上同步
@SneakyThrows: 抛出异常
