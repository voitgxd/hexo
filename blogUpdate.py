#!/usr/bin/python
# Filename: blogUpdate.py
# -*- coding: utf-8 -*-   

import os
import subprocess

if __name__ == "__main__":
	inputC = input('commit to git? y/n : ')
	if inputC == "y":
		os.system("hexo generate & (hexo deploy)")
		inputCo = input('backup source to git? y/n : ')
		if inputCo == "y":
			os.system("git add -A")
			os.system('git commit -m "backup"')
			os.system("git push origin master")
		else:
			print("not backup")
		print("commit success")
	else:
		print("not commit")