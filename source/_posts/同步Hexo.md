title: 同步Hexo
date: 2015-11-18 16:57:18
tags: Hexo
categories: Hexo
---
![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/4845745_161629814000_ok.jpg)

Hexo换机必备，越编越懒，留着备拷

<!--more-->

### 环境

1.[Node](https://nodejs.org/en/)

2.Git

3.Python

### 步骤

1.Git ssh 公钥设置

```
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
$ ssh-keygen -t rsa -C "youremail@example.com"
```

2.在本地工作目录连接远程并同步

```
git remote add origin git@github.com:voitgxd/hexo.git
git pull origin master
```

3.在工作目录安装Hexo,Hexo3.0以后server和deploy都得单独安装

```
npm install hexo --save
npm install hexo-deployer-git --save
npm install hexo-server --save
```

4.写好md之后在工作目录用Git Bash执行python脚本提交(发布到Git并备份工作区)

```
python blogUpdate.py
```