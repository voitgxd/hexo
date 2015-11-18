title: hexo--deploy--模拟
date: 2015-11-17 17:16:10
tags: [Hexo, Python]
categories: Hexo
---
![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/165105-485d32f74f22219e.jpg)

自从Hexo部署起来之后就一直没有碰过了，因为不知道它还有个deploy模块，每次更新先使用markdown写一个md文件，然后在hexo目录下命令行编译，生成静态文件，接着把所有静态文件拷贝到git仓库下，最后一堆git命令才能把你blog更新一下，甚至有时仅仅是为了更新了一篇文章。

<!--more-->

### 前言

基于上述情况，为了使这个流程自动化，就有了这个py脚本。默默的用python把deploy的过程实现了一遍，满满的都是泪...

学而不精之无知真可怕！！！

### 目的

> 环境配置 Hexo + Git + Python

Hexo和Git配置参考 [不如](http://ibruce.info/2013/11/22/hexo-your-blog/) 

我的Hexo源文件和生成的静态文件remote在两个git仓库下，因此本地也搞了两个，而且还在windows的两个盘符的子目录里，所以需求如下：
1.在Hexo工作目录
```
hexo clean
hexo generate
```
2.把生成在public下的静态文件拷贝到另一个盘符下的git仓库目录下
3.在git仓库目录下进行提交
```
git add .
git commt -m 'update'
git push origin master
```
4.最后切回到工作目录进行源文件备份
```
git add .
git commt -m 'backup'
git push origin master
```

然后就开始折腾...

### 过程

使用的模块：
```
import os
import time
import subprocess
```

自定义工程路径：
把这三个值改成自己环境下的地址（脚本只能使用跑在windows环境，因为路径地址没有使用os封装）
```
workDir = r"D:\hexo"
sourceDir = r"D:\hexo\public"
targetDir = r"E:\hexo\voitgxd.github.com" 
```
文件夹拷贝函数，为了缩短复制文件时间，比如目标文件夹下文件与源文件同名并且文件大小相同则直接跳过，简单封装了下。
```
def copyFiles(sourceDir, targetDir): 
	global copyFileCounts 
	print(sourceDir)
	print(u"%s 当前处理文件夹%s已处理%s 个文件" %(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())), sourceDir,copyFileCounts))
	for f in os.listdir(sourceDir):
		sourceF = os.path.join(sourceDir, f)
		targetF = os.path.join(targetDir, f)
		if os.path.isfile(sourceF):
			if not os.path.exists(targetDir):
				#创建目录
				os.makedirs(targetDir)
			copyFileCounts += 1
			if not os.path.exists(targetF) or (os.path.exists(targetF) and (os.path.getsize(targetF) != os.path.getsize(sourceF))):
				#文件不存在，或者存在但是大小不同，覆盖
				open(targetF, "wb").write(open(sourceF, "rb").read())
				print(u"%s %s 复制完毕" %(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())), targetF))
			else:
				print(u"%s %s 已存在，不重复复制" %(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())), targetF))
		if os.path.isdir(sourceF):
			copyFiles(sourceF, targetF)
```
主执行程序(脚本放到git本地仓库下)：
a.切换到工作目录编译并生成最新静态文件
此处开启新线程切换目录并执行generate命令，因为在接下来复制操作的时候不确定静态文件是否编译完成，当子进程返回 0 ，即执行成功，再继续。

```
p = subprocess.Popen("cd /d " + workDir + " && (hexo generate)", stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE, shell = True) 
```

b.将静态文件拷贝到git仓库下

```
copyFiles(sourceDir,targetDir)
```

c.git提交

完整代码：
```
if __name__ == "__main__":
	#1.编译生成最新文件
	p = subprocess.Popen("cd /d " + workDir + " && (hexo generate)", stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE, shell = True)	
	p.wait()  
	if p.returncode == 0:  
	    #2.子进程正确执行并返回,则将新文件复制到git仓库下
		print(p.stdout.read())
		copyFiles(sourceDir,targetDir)
		
		inputC = input('commit to git? y/n : ')
		if inputC == "y":
			os.system("git add .")
			os.system('git commit -m "update blog"')
			os.system('git pull -u origin master')
			print("commit success")
		else:
			print("not commit")
			pass 
	else:
		print("generate failed.")
```

### 使用

编辑好文章以后在git仓库文件夹下 Git Bash 执行这个脚本即可

```
python blogUpdate.py
```