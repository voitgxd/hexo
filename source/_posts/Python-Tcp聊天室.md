title: Python Tcp聊天室
date: 2015-11-24 18:24:46
tags: Python
categories: Python
---

![enter image description here](http://7xnq6l.com1.z0.glb.clouddn.com/powershell.png)

可以实现Tcp多人聊天哦，用cmd telnet连接即可。

<!--more-->

写代码的好处之一在于能养成极简化的思维习惯，遇到一个问题，总会去想有什么方法能最快、最优的处理它；遇到一个繁琐的处理流程，第一反应就是让它自动化。最近接触了下Python，发现真的挺好用，能极大简化工作量。果真如它介绍所说，又短又强悍！当Python面世时，有人说：完成同一个任务，C语言要写1000行代码，Java只需要写100行，而Python可能只要20行。

语法又简单、代码又简短，关键还能解决问题，对我来说就足够有吸引力了。不过，又有人说了：Python是解释型语言，执行的时候翻译过程非常耗时。C程序运行1秒钟，Java程序可能需要2秒，而Python程序可能就需要10秒。说的又对，那我不用它来写大型项目可以吧。写个py脚本备份备份blog，让你的重复工作自动化还是挺有趣的。

最近在学习的时候，发现了个非常有意思的例子。[原文](http://blog.csdn.net/trbbadboy/article/details/7900017)。

用Python写的聊天室，使用telnet登陆。仅仅只有一个py文件。原文准确来说，是用python写的一个简单的TCP服务器，只有三个类，一个用来使用socket绑定当前IP的某个端口，并不断监听来自telnet的连接请求。一个用来处理连接成功以后与客户端通信（收发数据）。另一个用来初始化配置信息。

使用方法：
1.安装Python（前提）
2.在命令行环境（cmd、Windows PowerShell或者其他）下运行这个脚本

```
python xxx.py
```

3.telnet访问（本机IP + 9113端口）

```
telnet 192.168.xx.xx 9113
```

4.再开一个命令行窗口访问就可以聊天了，可以输入以下命令查看当前聊天室的用户

```
.user
```

完整代码：

```
# Filename: ChatRoomServer.py 

import threading
import datetime
import socket
import subprocess

# a simple log function
def log(lg):
	print(lg)

# Chat room server listen thread class, this class is use for listening client login
# when a client request to connect server, this class will start a connect thread
class ServerListenThread(threading.Thread):
	def __init__(self, hostname, port, accept):
		threading.Thread.__init__(self)
		self.hostname = hostname
		self.port = port
		self.accept = accept
		self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
		self.sock.bind((hostname, port))
		self.sock.listen(0)
		self.listenstate = False
		log('ServerIp:%s ServerPort:%s  waiting for client...'%self.sock.getsockname())
	def run(self):
		clientid = 1
		while True:
			client, cltadd = self.sock.accept()
			log('a request from Id=%s%s'%('%d Address:'%clientid , cltadd))
			if self.accept(clientid, client):
				clientid = clientid + 1
			log(self.listenstate)
			if self.listenstate:
				log('server exit')
				break
		self.sock.close()
	def shutdown(self):
		self.listenstate = True

class ServerConnectThread(threading.Thread):
	def __init__(self, clientid, client, encoding, receive, disconnect):
		threading.Thread.__init__(self)
		self.client = client
		self.clientid = clientid
		self.encoding = encoding
		self.receive = receive
		self.disconnect = disconnect
		self.clientname = None
		self.inputs = self.client.makefile('rb', 0)
		self.outputs = self.client.makefile('wb', 0)
	
	def run(self):
		self.sendstring('Input your name:')
		while True:
			string = self.readline()
			if string:
				string = string.lstrip()
				if len(string)>0:
					self.receive(self, string)
			else:
				self.inputs.close()
				self.outputs.close()
				break
		if self.clientname:
			self.disconnect(self)
	def sendstring(self, string):
		#python3传递的是bytes，所以要编码
		self.sendbytes(bytes(string, self.encoding))
	def sendbytes(self, bts):
		self.outputs.write(bts)
	def readline(self):
		rec = self.inputs.readline()
		if rec:
			string = bytes.decode(rec, self.encoding)
			if len(string)>2:
				string = string[0:-2]
			else:
				string = ' '
		else:
			string = False
		return string


# Chat room server class, this class is constitute of a listen thread and many connect thread
class ChatRoomServer:
	def __init__(self, ip='0.0.0.0', port=9113, encoding='utf-8'):
		self.hostname = ip
		self.encoding = encoding
		self.port = port
		self.clients = {}
		self.clientnames = {}
	def whenconnect(self, clientid, client):
		log('a connect with Id=%s%s'%('%d Address:'%clientid , client.getpeername()))
		connect = ServerConnectThread(clientid, client, self.encoding, self.whenreceive, self.whenexit) 
		connect.start()
		return True

	def whenreceive(self, client, string):
		log('frome %d, receive:%s (%d)'%(client.clientid, string, len(string)))
		if client.clientname:
			if string[0] == '.':
				self.handlecmd(client, string[1:])
			elif string[0] == '$':
				self.execmd(client, string[1:])
			else:
				now = datetime.datetime.now()
				sendstring = '%s %s\r\n  %s\r\n'%(now, client.clientname, string)
				self.sendtoall(sendstring, client)
		else:
			if self.clientnames.__contains__(string):
				client.sendstring('%s is exited!!!\r\n'%string)
			else:
				client.clientname = string
				client.sendstring('Hell, %s!!!\r\n'%client.clientname)
				self.addclient(client)
		return True

	def whenexit(self, client):
		self.delclient(client)
		return True
	
	def handlecmd(self, client, cmd):
		log('cmd: %s'%cmd)
		if cmd=='user':
			client.sendstring('User list(%d):\r\n'%len(self.clients))
			for i in self.clients:
				clt = self.clients[i]
				client.sendstring(' %d\t%s\r\n'%(clt.clientid, clt.clientname))
		elif cmd == 'quit':
			self.serverlisten.shutdown()
		else:
			client.sendstring('Unknow command: %s:\r\n'%cmd)
	def execmd(self, client, cmd):
		log('cmd: %s'%cmd)
		p = subprocess.Popen(" " + cmd + " ", stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE, shell = True)
		p.wait()
		sends = bytes(p.stdout.read())
		client.sendbytes(sends)
	
	def start(self):
		self.serverlisten = ServerListenThread(self.hostname, self.port, self.whenconnect)
		self.serverlisten.start()
	
	def sendtoall(self, string, notfor):
		sends = bytes(string, self.encoding)
		for i in self.clients:
			if not(notfor and notfor.clientid==i):
				self.clients[i].sendbytes(sends)
	
	def addclient(self, client):
		self.sendtoall('%s logined!!!\r\n'%client.clientname, client)
		self.clients[client.clientid] = client
		self.clientnames[client.clientname] = client.clientid

	def delclient(self, client):
		self.sendtoall('%s logouted!!!\r\n'%client.clientname, client)
		del self.clients[client.clientid]
		del self.clientnames[client.clientname]

# start a chat room server
# 继承了线程的类start方法即执行子类的run方法
ChatRoomServer().start()
```

有翻到最后的吗？

翻到最后的就告诉你们我在代码里加了什么，可以试着输入以下命令：

```
$ls
```

最后，欢迎留言自己的IP + 端口哦！