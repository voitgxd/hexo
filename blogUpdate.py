#!/usr/bin/python
# Filename: blogUpdate.py
# -*- coding: utf-8 -*-   

import os
import time
import subprocess

if __name__ == "__main__":
	#1.编译生成最新文件
	inputC = input('add to git? y/n : ')
	if inputC == "y":
		#3.ssh连接git并提交
		os.system("hexo generate & (hexo deploy)")
		#os.system("ssh -T git@github.com")
		#time.sleep(2)
		os.system("git add .")
		#time.sleep(2)
		os.system('git commit -m "backup"')
		#time.sleep(2)
		os.system("git push origin master")
		print("commit success")
	else:
		print("未提交，脚本结束")