title: Git命令备忘录
date: 2015-11-23 16:35:42
tags: util
categories: Git
---
![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/git-command.jpg)

<!--more-->

### 常用命令

1.查看提交历史、回滚到之前的版本（^^表示上两个版本，~10表示上10个版本）

```
git reset --hard HEAD^^
```

```
git reset --hard HEAD~10
```

2.查看命令历史查找commit_id，由回滚状态到版本库目前状态id为commit_id的某个状态

```
git reflog
git reset --hard commit_id
```

3.撤销某个文件在工作区的最近一次修改

```
git checkout -- file_name
```

4.关联一个远程的版本库

```
git remote add origin git@server-name:path/repo-name.git
```

5.第一次推送master分支的所有内容，后续直接用git push master

```
git push -u origin master
```

6.给Git常用命令起别名，删除别名在.git/config文件中直接删除对应的行

```
git config --global alias.last 'log -1'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

### 分支

1.基本命令

```
git branch #查看分支
git branch <name> #创建分支
git checkout <name> #切换分支
git checkout -b <name> #创建+切换分支
git merge <name> #合并某分支到当前分支
git branch -d <name> #删除分支
git log --graph #查看分支合并图
git merge --no-ff -m "merge with no-ff" dev #不使用Fast forward合并分支

git branch -D <name> #强行删除为被合并过的分支
```

2.多人协同操作

```
git remote -v #查看远程库信息
git pull #拉取分支在远程路下的最新提交
git push origin branch-name #从本地推送分支
git checkout -b branch-name origin/branch-name #在本地创建和远程分支对应的分支
git branch --set-upstream branch-name origin/branch-name #建立本地分支和远程分支的关联
```

3.临时操作

```
git stash #保存现场
git stash pop #恢复工作区被保存的内容，同时删除保存区的该内容
```

### 标签

```
git tag <name> #新建一个标签，默认为HEAD，也可以指定一个commit id
git tag -a <tagname> -m "blablabla..." #指定标签信息
git tag #查看所有标签
git push origin <tagname> #推送一个本地标签
git push origin --tags #推送全部未推送过的本地标签
git tag -d <tagname> #删除一个本地标签
git push origin :refs/tags/<tagname> #删除一个远程标签
```