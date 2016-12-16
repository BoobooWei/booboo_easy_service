# ULE 笔试题

## 选择题单选(2' 50' 100')

1.用shell打开一个远程shell是，以下哪一项不必要？

A. 远程机器必须运行sshd服务 
B. 你必须知道机器上一个帐号的用户名和密码（可以通过key方式）
C. 本地机器必须是linux机器（操作系统不重要）
D. 你必须知道远程机器的主机名hostname或IP地址（可以通过Console口）

2.以下哪一项不是操作系统？

A. 红帽企业版Linux RHEL7
B. Windows 2000
C. Microsoft Office				
D. Mac OS X

3.以下哪一项是红帽企业版Linux默认Shell？
A. /bin/bash					B. /bin/tcsh
C. /bin/zsh					D. /bin/sh

4.以下哪一项命令会列出进程信息？
A. ps		B. lsps		C. lps		D. ls

5.假设shell的当前工作目录是“/home/superman/”，以下哪一项是对文件“/home/superman/mail/sent”的相对路径？
A. mail/sent	B. /mail/sent	C. sent		D. /sent

6.下面哪一项命令会成功地把cal命令的输出重定向到文件lsout.txt中？
A. lsout.txt > cal	B. cal ===> lsout.txt	C. cal > lsout.txt	D. cal } lsout.txt

7.以下哪一项控制键组合使bash清屏？
A. ctrl+c	B. ctrl+d	C. ctrl+l	D. ctrl+s

8.以下哪种方式不能获得ls命令的帮助?
A. help ls	B. ls - -help	C. man ls	D. pinfo ls

9.以下哪一项是相对目录的引用？
A. /home/student	B. /etc		C. ..	D. ~

10.student用户执行cd ～命令后的结果是什么？
A. /home/student	B. /etc		C. ..	D. ~

11.文件named.conf 是一个系统配置文件，它位于
A. /tmp	B. /etc		C. /var		D. /bin

12.命令mv f1 f2 f3 f4可以做到 
A. 将四个文件从当前目录中移出来 	B. 将四个文件移动到当前目录
C. 将四个文件移动到默认目录		D. 将三个文件从当前目录种移出

13.命令ls ？e* 的输出中应该包含以下哪个文件？
A. one		B. rove		C. ebbs	D. teaback

14.下面哪个文件含有用户信息？
A. /etc/user.dat	B. /etc/passwd.dat	C. /etc/users	D. /etc/passwd

15.下列哪一项是正确的？
A. 普通用户可以查看/etc/shadow文件	B. 普通用户可以编辑/etc/shadow文件
C. A和B都正确				D. 以上都不正确


16.哪个文件定义了次要组成员身份？
A. /etc/group		B. /etc/secondary	C. /etc/passwd		D. /etc/shadow

17.下列哪个命令会使文件sample.sh的有权限rwxrwxr-x，当前的权限是rw-rw-r--?
A. chmod a+rw sample.sh			B. chmod go+x sample.sh
C. chmod a+x sample.sh			D. chmod x+a sample.sh

18.以下哪个umask值导致新建文件的默认权限是rwxr-xr-x?
A. 022		B. 033		C. 011		D. 新建文件不可能有这样的权限

19.以下哪项是不正确的？
A. 目录之间不能用硬链接		B. 软链接必须在同一个文件系统下
C. 删除原文件后硬链接还能使用	D. 删除源文件后软链接不能使用

20.下面哪个命令可以确定当前系统挂载的文件系统？
A. chown		B. df		C. du		D. ls

21.将/etc/目录打包并用bzip2压缩到/tmp/etc.tar.bz2的命令为
A. tar -fjcv /etc/ /tmp/etc.tar.bz2 	B. tar -jcf /etc/ /tmp/etc.tar.bz2
C. tar -jcf /tmp/etc.tar.bz2 /etc/		C. tar -zcf /tmp/etc.tar.bz2 /etc/

22.创建名为myhome的别名，并将其替换为短语 cd /var/www/html 
A. alias myhome cd /var/www/html		B. alias myhome "/var/www/html"
C. alias myhome=cd /var/www/html	D. alias myhome="cd /var/www/html"

23.登陆shell的流程读取的配置文件的不包括哪一个
A. /etc/bashrc		B. /etc/fstab	C. /etc/profile		D. ~/.bashrc

24.从/etc/passwd文件中截取以bash结尾的行
A. grep $bash /etc/passwd		
B. grep /etc/passwd bash$
C. grep bash$ /etc/passwd 	
D. grep bash% /etc/passwd

25.从/etc/passwd文件中提取以冒号分割的第三列内容              
A. cut -b : -k 3 /etc/passwd	
B. cut -d : -f 3 /etc/passwd
C. cut -d : -k 3 /etc/passwd 	
D. cut -b : -k 3 /etc/passwd

26.将/tmp/b文件按照数字大小，以冒号为分割，依照第二列，从小到大排序
A. sort -n -t : -k 2 -r /tmp/b	B. sort -d : -f 2 -r /tmp/b
C. sort -n -t : -k 2 /tmp/b   	D. sort -n -d : -f 2 /tmp/b

27.RHEL6系统图形化界面，多用户，有网络的runlevel
A. 3	B. 5	C. 1	D. 6

28.设置一次性计划任务的命令和设置周期性计划任务的命令为
A. crond atd	B. at crontab	c. atd crontab	D. crontab at

29.vim编辑器从退出模式进入插入模式并在光标所在行的下一行插入
A. O	B. I 	C. o	D.i

30.root用户修改目录/tmp/justice/的所属者和所属组，修改为所属者：superman，所属组：justice
A. usrmod -u superman -g justice /tmp/justice
B. chmod superman:justice  /tmp/justice
C. chown superman:justice  /tmp/justice
D. chgrp superman:justice  /tmp/justice

31.NFS是什么系统
A. 文件
B. 磁盘
C. 网络文件
D. 操作

32.配置Apache2.2服务器需要修改的配置文件为
A. httpd.conf
B. access.conf
C. srm.conf
D. named.conf

33.Linux文件权限一共10位长度，分成四段，第三段表示的内容是 
A. 文件类型
B. 文件所有者的权限
C. 文件所有者所在组的权限
D. 其他用户的权

34.终止一个前台进程可能用到的命令和操作
A. kill
B. ctrl+c
C. shutdown
D. halt

35.使用mkdir命令创建新的目录时，在其父目录不存在时先创建父目录的选项是
A. -m
B. -d
C. -f
D. -p

36.下面对www和ftp的端口描述正确的是
A. 20 21 
B. 80 20
C. 80 21
D. 80 20 21

37.shell不仅仅是用户命令解释器，同时一种强大的编程语言，linux默认使用的shell是什么。
A. bash
B. python
C. PHP
D. perl

38.在TCP/IP模型中，应用层包含了所有的高层协议，在下列的一些应用协议中， __是能够实现本地与远程主机之间的文件传输工作。
A. telnet
B. FTP
C. SNMP
D. NFS

39.下列关于/etc/fstab文件描述，正确的是
A. fstab文件只能描述属于linux的文件系统
B. CD_ROM和软盘必须是自动加载的
C. fstab文件中描述的文件系统不能被卸载
D. 启动时按fstab文件描述内容加载文件系统

40.通过文件名存取文件时，文件系统内部的操作过程是通过
A. 文件在目录中查找文件数据存取位置。
B. 文件名直接找到文件的数据，进行存取操作。
C. 文件名在目录中查找对应的I节点，通过I节点存取文件数据。
D. 文件名在中查找对应的超级块，在超级块查找对应i节点，通过i节点存取文件数据

41.__不是进程和程序的区别。
A. 程序是一组有序的静态指令，进程是一次程序的执行过程
B. 程序只能在前台运行，而进程可以在前台或后台运行
C. 程序可以长期保存，进程是暂时的
D. 程序没有状态，而进程是有状态的

42.在/home/stud1/wang目录下有一文件file，使用那一项可实现在后台执行命令，此命令将file文件中的内容输出到file.copy文件中
A. cat file >file.copy
B. cat >file.copy
C. cat file file.copy &
D. cat file >file.copy &

43.在DNS配置文件中，用于表示某主机别名的是
A. NS
B. CNAME
C. NAME
D. CN

44.可以完成主机名与IP地址的正向解析和反向解析任务的命令是
A. nslookup
B. arp
C. ifconfig
D. dnslook

45.Linux下在使用匿名登录ftp时，用户名为
A. users
B. anonymous
C. root
D. vsftp

46.Linux下Crontab文件，每个域之间用空格分割，其排列如下正确的是
A. MIN HOUR DAY MONTH YEAR COMMAND
B. MIN HOUR DAY MONTH DAYOFWEEK COMMAND
C. COMMAND HOUR DAY MONTH DAYOFWEEK
D. COMMAND YEAR MONTH DAY HOUR MIN

47.在下次重启时，使NFS客户端自动挂载一个共享目录，为了永久生效，编辑/etc/fstab，如何配置来匹配你的配置
A. remoteserver:/export /mnt/remoteserver nfs defaults 0 0
B. remoteserver:/export /mnt/remoteserver nfs defaults 0 4
C. remoteserver:/export /mnt/remoteserver nfsd defaults 0 0
D. remoteserver:/export /mnt/remoteserver nfs defaults 4

48.Linux最多有几个主分区
A. 2
B. 3
C. 4
D. 5

49.cp一个目录中的文件需要对目录什么权限
A. 执行权限
B. 写权限
C. 读权限
D. 读写权限

50.系统中存在两个进程, 其pid分别为 110, 119, 此时希望当119需要占用CPU时总是要优于110, 应如何做
A. 调整进程119的nice值, nice -5 119
B. 调整进程119的nice值, renice -5 119
C. 调整进程110的nice值, nice -5 110
D. 调整进程110的nice值, renice -5 110