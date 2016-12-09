## SAMBA文件共享服务

[TOC]

### Samba的历史及原理

在早期的网络世界中，文件数据在不同主机之间的传输大多是使用FTP这个好用的服务器软件进行的。不过，使用FTP传输文件却有个小小的问题，那就是您无法直接修改主机上面的文件数据。也就是说，您想要更改Linux主机上面的某个文件时，必须要由服务器端将该文件下载到您工作的客户端后才能修改，因此该文件在服务器端和客户端都会存在。这时，如果有一天您修改了某个文件，却忘记将数据上传回主机，那么等过了一阵子之后，您如何知道哪既然有这样的问题，那好吧，我可不可以在客户端的机器上面直接取用服务器上面的文件？如果可以在客户端直接进行服务器端文件的访问，那么我在客户端就不需要存在该文件数据了，也就是说，我只要有服务器上面的文件数据存在就可以了。有没有这样的文件系统（File System）呢？前面我们提到过的Network File System（NFS）就是这样的文件系统之一。只要在客户端将服务器端所提供的共享目录挂载进来，那么在我的客户端就可以直接取用服务器上的文件数据，而且，该数据就像是客户端上的分区一样，非常好用！而除了可以让Unix Like的机器互相分享文件的NFS服务器之外，在微软（Microsoft）上面也有类似的文件系统，那就是Common Internet File System（CIFS）。CIFS最简单的用途就是目前常见的“网上邻居”。Windows系统的计算机可以通过桌面上的“网上邻居”来访问别人所提供的文件数据。不过，NFS仅能让Unix机器沟通，CIFS只能让Windows机器沟通。那么有没有让Windows与Unix Like这两个不同的平台相互分享文件数据的文件系统呢？个文件才是最新的？

在1991年，一个名叫Andrew Tridgwell的大学生就有这样的困扰，他手上有三台机器，分别是运行DOS的个人计算机、DEC公司的Digital Unix系统以及Sun的Unix系统。在当时，DEC 公司开发出一套称为PATHWORKS的软件，这套软件可以用来分享DEC的Unix与个人计算机的DOS这两个操作系统的文件数据，可惜让Tridgwell觉得较困扰的是Sun的Unix无法通过这个软件来达到文件共享的目的。这个时候Tridgwell就想：“咦！既然这两台系统可以共享，没道理Sun就必须这么苦命吧？可不可以将这两个系统的工作原理找出来，然后让Sun机器也能够共享文件数据呢？”，为了解决这样的的问题，Tridgwell就自行编写了一个程序去检测当DOS与DEC的Unix系统在进行文件分享传输时所使用到的通信协议信息，然后获取这些重要的信息，并且基于上述所找到的通信协议而开发出Server Message Block（SMB）这个文件系统，而就是这套SMB软件就能够让Unix与DOS互相共享文件。

既然写成了软件，总需要注册商标，因此Tridgwell就申请SMB Server作为该软件的商标。可惜因为SMB是没有意义的文字，没有办法达成注册。既然如此，能不能在字典里面找到相关的字词可以作为商标来注册呢？翻了老半天，发现SAMBA刚好含有SMB，又是热情有劲的拉丁舞蹈的名称，不然就用这个名字来作为商标好了。这成为我们今天所使用的SAMBA的名称的由来。

### Samba的作用
作用：windows和类unix系统文件共享服务

### Samba的软件结构

```shell
# 服务端linux

软件		samba samba-common
service		nmb	smb
daemon		nmbd	smbd
端口		137 138|139 445
配置文件		/etc/samba/smb.conf
数据文件		/var/lib/samba
日志文件		/var/log/samba


# 客户端linux
软件		samba-client
命令		smbclient
		smbclient -L ip -U username
		smbpasswd -a username
		smbpasswd username
		smbclient //172.25.0.11/共享名
		smbclient //172.25.0.11/共享名 -U student
		mount -t cifs //172.25.15.11/共享名 /mnt -o guest
		mount -t cifs //172.25.15.11/共享名 /mnt -o username=student
```
### 项目实践1：配置samba共享

```shell
系统用户
############
服务器端rhel6
############
[root@rhel6 ~]# yum install -y samba samba-common
[root@rhel6 ~]# service iptables stop
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
[root@rhel6 ~]#
[root@rhel6 ~]# service smb start
Starting SMB services:                                     [  OK  ]
[root@rhel6 ~]# service nmb start
Starting NMB services:                                     [  OK  ]
[root@rhel6 ~]# id student
uid=500(student) gid=500(student) groups=500(student)
[root@rhel6 ~]# which smbpasswd
/usr/bin/smbpasswd
[root@rhel6 ~]# smbpasswd -a student
New SMB password:
Retype new SMB password:
Added user student.
[root@rhel6 ~]# getsebool -a|grep samba
samba_create_home_dirs --> off
samba_domain_controller --> off
samba_enable_home_dirs --> off
samba_export_all_ro --> off
samba_export_all_rw --> off
samba_portmapper --> off
samba_run_unconfined --> off
samba_share_fusefs --> off
samba_share_nfs --> off
sanlock_use_samba --> off
use_samba_home_dirs --> off
virt_use_samba --> off
[root@rhel6 ~]# setsebool -P samba_enable_home_dirs 1
[root@rhel6 ~]# getsebool -a|grep samba
samba_create_home_dirs --> off
samba_domain_controller --> off
samba_enable_home_dirs --> on
samba_export_all_ro --> off
samba_export_all_rw --> off
samba_portmapper --> off
samba_run_unconfined --> off
samba_share_fusefs --> off
samba_share_nfs --> off
sanlock_use_samba --> off
use_samba_home_dirs --> off
virt_use_samba --> off
-----------------------------------
# 客户端linux——类似ftp的方式访问
[root@rhel7 ~]# systemctl stop firewalld
[root@rhel7 ~]# yum install -y samba-client
[root@rhel7 ~]# smbclient -L 172.25.0.11
Enter root\'s password:
Anonymous login successful
Domain=[MYGROUP] OS=[Unix] Server=[Samba 3.6.9-164.el6]

	Sharename       Type      Comment
	---------       ----      -------
	IPC$            IPC       IPC Service (Samba Server Version 3.6.9-164.el6)
Anonymous login successful
Domain=[MYGROUP] OS=[Unix] Server=[Samba 3.6.9-164.el6]

	Server               Comment
	---------            -------
	RHEL6                Samba Server Version 3.6.9-164.el6

	Workgroup            Master
	---------            -------
	MYGROUP              RHEL6
[root@rhel7 ~]# smbclient -L 172.25.0.11 -U student
Enter student\'s password:
Domain=[MYGROUP] OS=[Unix] Server=[Samba 3.6.9-164.el6]

	Sharename       Type      Comment
	---------       ----      -------
	IPC$            IPC       IPC Service (Samba Server Version 3.6.9-164.el6)
	student         Disk      Home Directories
Domain=[MYGROUP] OS=[Unix] Server=[Samba 3.6.9-164.el6]

	Server               Comment
	---------            -------
	RHEL6                Samba Server Version 3.6.9-164.el6

	Workgroup            Master
	---------            -------
	MYGROUP              RHEL6
[root@rhel7 ~]# smbclient //172.25.0.11/student -U student
Enter student\'s password:
Domain=[MYGROUP] OS=[Unix] Server=[Samba 3.6.9-164.el6]
smb: \>
smb: \> ls
NT_STATUS_ACCESS_DENIED listing \*
smb: \> ls
  .                                   D        0  Thu Jul  2 04:01:16 2015
  ..                                  D        0  Thu Jul  2 03:57:29 2015
  .ssh                               DH        0  Thu Jul  2 04:01:07 2015
  .bashrc                             H      124  Tue Jul  9 09:24:50 2013
  .bash_logout                        H       18  Tue Jul  9 09:24:50 2013
  .mozilla                           DH        0  Thu Jul  2 03:36:20 2015
  .bash_history                       H        5  Thu Jul  2 04:01:16 2015
  .gnome2                            DH        0  Wed Jul 14 11:55:40 2010
  .bash_profile                       H      176  Tue Jul  9 09:24:50 2013

		49584 blocks of size 8192. 45708 blocks available
smb: \> exit
-------------------------------------------------------------
# 客户端windows
打开浏览器输入\\172.25.0.11\
输入student和uplooking密码后就可以进入服务器中的用户家目录，创建目录aa，以及文件aa下的dd.txt
--------------------------------------------------------------
# 客户端linux
[root@rhel7 ~]# smbclient //172.25.0.11/student -U student
Enter student\'s password:
Domain=[MYGROUP] OS=[Unix] Server=[Samba 3.6.9-164.el6]
smb: \> ls
  .                                   D        0  Thu Aug  4 04:30:31 2016
  ..                                  D        0  Thu Jul  2 03:57:30 2015
  .ssh                               DH        0  Thu Jul  2 04:01:07 2015
  aa                                  D        0  Thu Aug  4 04:30:28 2016
  .bashrc                             H      124  Tue Jul  9 09:24:50 2013
  .bash_logout                        H       18  Tue Jul  9 09:24:50 2013
  .mozilla                           DH        0  Thu Jul  2 03:36:20 2015
  .bash_history                       H        5  Thu Jul  2 04:01:16 2015
  .gnome2                            DH        0  Wed Jul 14 11:55:40 2010
  .bash_profile                       H      176  Tue Jul  9 09:24:50 2013

		49584 blocks of size 8192. 45707 blocks available
smb: \> get aa
NT_STATUS_FILE_IS_A_DIRECTORY opening remote file \aa
smb: \> cd aa
smb: \aa\> ls
  .                                   D        0  Thu Aug  4 04:30:28 2016
  ..                                  D        0  Thu Aug  4 04:30:31 2016
  dd.txt                              A        2  Thu Aug  4 04:31:01 2016

		49584 blocks of size 8192. 45707 blocks available
smb: \aa\> get dd.txt
getting file \aa\dd.txt of size 2 as dd.txt (1.0 KiloBytes/sec) (average 1.0 KiloBytes/sec)
可以查看到了。

********************************************************************
=====================================================================
匿名用户
############
服务器端rhel6
############

1.创建共享目录/var/lib/samba/share
[root@rhel6 ~]# mkdir /var/lib/samba/share
2.修改配置文件
[root@rhel6 ~]# vim /etc/samba/smb.conf
[public]
       comment = Public Stuff
       path = /var/lib/samba/share
       public = yes
       writable = yes
3.重启服务
[root@rhel6 ~]# service smb restart
Shutting down SMB services:                                [  OK  ]
Starting SMB services:                                     [  OK  ]
[root@rhel6 ~]# service nmb restart
Shutting down NMB services:                                [  OK  ]
Starting NMB services:                                     [  OK  ]
4.修改共享目录的UGO权限
[root@rhel6 ~]# ll -d /var/lib/samba/share
drwxr-xr-x. 2 root root 4096 Aug  5 10:27 /var/lib/samba/share
[root@rhel6 ~]# grep nobody /etc/passwd
nobody:x:99:99:Nobody:/:/sbin/nologin
nfsnobody:x:65534:65534:Anonymous NFS User:/var/lib/nfs:/sbin/nologin
[root@rhel6 ~]# chown nobody. /var/lib/samba/share
[root@rhel6 ~]# ll -d /var/lib/samba/share
drwxr-xr-x. 2 nobody nobody 4096 Aug  5 10:27 /var/lib/samba/share
[root@rhel6 ~]# touch /var/lib/samba/share
[root@rhel6 ~]# touch /var/lib/samba/share/smb-file{1..5}
[root@rhel6 ~]# chown nobody. /var/lib/samba/share -R

[root@rhel6 ~]# service smb stop
Shutting down SMB services:                                [  OK  ]
[root@rhel6 ~]# service smb start
Starting SMB services:                                     [  OK  ]

############
客户端rhel7
############
[root@rhel7 ~]# smbclient -L 172.25.0.11
Enter root\'s password:
Anonymous login successful
Domain=[MYGROUP] OS=[Unix] Server=[Samba 3.6.9-164.el6]

	Sharename       Type      Comment
	---------       ----      -------
	public          Disk      Public Stuff
	IPC$            IPC       IPC Service (Samba Server Version 3.6.9-164.el6)
Anonymous login successful
Domain=[MYGROUP] OS=[Unix] Server=[Samba 3.6.9-164.el6]

	Server               Comment
	---------            -------
	RHEL6                Samba Server Version 3.6.9-164.el6

	Workgroup            Master
	---------            -------
	MYGROUP              RHEL6
[root@rhel7 ~]# smbclient //172.25.0.11/public
Enter root\'s password:
Anonymous login successful
Domain=[MYGROUP] OS=[Unix] Server=[Samba 3.6.9-164.el6]
smb: \> ls
  .                                   D        0  Thu Aug  4 22:32:12 2016
  ..                                  D        0  Thu Aug  4 22:30:52 2016
  smb-file4                           N        0  Thu Aug  4 22:32:12 2016
  smb-file2                           N        0  Thu Aug  4 22:32:12 2016
  smb-file5                           N        0  Thu Aug  4 22:32:12 2016
  smb-file1                           N        0  Thu Aug  4 22:32:12 2016
  smb-file3                           N        0  Thu Aug  4 22:32:12 2016

		34505 blocks of size 524288. 26941 blocks available
smb: \> get smb-file1
getting file \smb-file1 of size 0 as smb-file1 (0.0 KiloBytes/sec) (average 0.0 KiloBytes/sec)
smb: \> put rhel7
putting file rhel7 as \rhel7 (0.0 kb/s) (average 0.0 kb/s)
smb: \> ls
  .                                   D        0  Thu Aug  4 22:34:46 2016
  ..                                  D        0  Thu Aug  4 22:30:52 2016
  smb-file4                           N        0  Thu Aug  4 22:32:12 2016
  rhel7                               A        0  Thu Aug  4 22:34:46 2016
  smb-file2                           N        0  Thu Aug  4 22:32:12 2016
  smb-file5                           N        0  Thu Aug  4 22:32:12 2016
  smb-file1                           N        0  Thu Aug  4 22:32:12 2016
  smb-file3                           N        0  Thu Aug  4 22:32:12 2016

		34505 blocks of size 524288. 26941 blocks available
smb: \> exit

############
客户端windows
############
打开浏览器输入\\172.25.0.11\
就能看到public了

=================================================================
～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～
以类似nfs挂接的方式来共享samba
###
客户端
###
mount -t cifs //172.25.0.11/student /mnt -o username=student
uplooking

1.安装软件cifs-utils
[root@rhel7 ~]# yum install -y cifs-utils
2.mount挂载
[root@rhel7 ~]# mount -t cifs //172.25.0.11/student /mnt -o username=student
Password for student@//172.25.0.11/student:  *********
[root@rhel7 ~]# mount|tail -n 1
//172.25.0.11/student on /mnt type cifs (rw,relatime,vers=1.0,cache=strict,username=student,domain=RHEL6,uid=0,noforceuid,gid=0,noforcegid,addr=172.25.0.11,unix,posixpaths,serverino,acl,rsize=1048576,wsize=65536,actimeo=1)
[root@rhel7 ~]# cd /mnt
[root@rhel7 mnt]# ll
total 1024
-rwxrw-r--. 1 500 500 8 Aug  4 22:15 file-student.txt
drwxr-xr-x. 2 500 500 0 Aug  4 22:19 windows

3.可以设置开机自动挂载，/etc/bashrc或者/etc/profile中
```


### Samba的主配置文件/etc/samba/smb.conf详细解析
```shell
首先是全局配置
【global】
        workgroup = MYGROUP     -->工作组，工作组是windows上的概念
        server string = Samba Server Version %v   -->关于samba的说明

        netbios name = MYSERVER   -->网络名称

;       interfaces = lo eth0 192.168.12.2/24 192.168.13.2/24   -->接口网段信息
;       hosts allow = 127. 192.168.12. 192.168.13.    -->允许哪些机器来访问共享

;       max protocol = SMB2
【logging options】  关于日志的配置
 	log file = /var/log/samba/log.%m    	日志存放的位置，%m代表日期
 	max log size = 50			日志的大小限制为50K
【 Standalone Server Options 】 关于安全级别的相关配置
        security = user    --> user代表需要用户名和密码，密码与下面的passdb backend有关，share代表任何来都可以直接访问，server指的是使用外部的密码，需要提供password server = IP的设置值才行。
        passdb backend = tdbsam   -->数据库格式，默认的格式是tdbsam，文职被放置到/var/lib/samba/private/passwd.tdb

【 Share Definitions 】
[homes]    -->默认情况用户家目录的共享信息
        comment = Home Directories
        browseable = no
        writable = yes
;       valid users = %S
;       valid users = MYDOMAIN\%S
[printers]  -->关于打印机的配置，这是一些例子。下面跟上了一些选项。
        path = /var/spool/samba
        browseable = no
        guest ok = no
        writable = no
        printable = yes
[sharesmb]        -->共享目录名
        comment = 说明
        path = /test    -->共享路径
        public = yes    -->是否所有人都能够访问
        writable = yes  -->是否可以写
        printable = no  -->是否打印，默认是no，写了yes会直接被传递到打印机，可以省略该行
        write list = +staff  -->可写用户列表。我们这里先把这行删掉。
        browsable=no    -->是否可浏览，如果是yes则默认隐藏。
     	  hosts allow= 用来限制主机和网段。谁可以访问。
```
