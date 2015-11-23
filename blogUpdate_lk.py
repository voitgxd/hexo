#!/usr/bin/python
# Filename: blogUpdate.py
# -*- coding: utf-8 -*-   

import os
import subprocess

if __name__ == "__main__":
	inputC = input('commit to git? y/n : ')
	if inputC == "y":
		os.system("hexo clean & (hexo generate) & (hexo deploy)")
		inputCo = input('backup source to git? y/n : ')
		if inputCo == "y":
			os.system("git checkout lk")
			os.system("git add --all")
			os.system('git commit -m "backup"')
			os.system("git checkout master")
			os.system("git merge lk")
		else:
			print("not backup")
		print("commit success")
	else:
		print("not commit")