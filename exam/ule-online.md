# ULE上机考试

[TOC]

##　注意事项

1. 确保在重启主机后所有配置仍然生效。
2. selinux必须为Enforing模式，防火墙必须开始。默认策略必须清空。
3. 设置主机名为 stuXXX（“X”为你的 foundation 机器 ip 地址最后一位。例如：你的 ip 地址为172.25.254.30，则你的主机名为stu30）
4. 不允许ssh登录到其他主机，已经发现按0分计算考试得分。
5. 考试满分为100分制，70分为及格，90分为优秀，所有考题需要按照要求完成。

## 考试内容

### find查找文件 

使用find查找/etc目录下文件名以.conf结尾的文件，并将其复制到/tmp/etc目录下。（10分）

###　autofs自动挂载　

配置autofs，当执行cd /opt/server 时，系统自动将172.25.254.250:/content 挂载到此目录。（10分）

### 用户和组的管理

创建test1 test2 test3用户，uid=gid分别为801 802 803，将他们加入到test组（本机无test用户），组test为这些用户的附加组。创建/tmp/test目录，该目录只有test1 test2 test3用户可读写，（root不受限制）。该目录下所创建文件group将自动改变为test组，该目录下文件只有owner可删除。（10分）

### Apache搭建网站服务

#### 基于名称的虚拟主机

创建两个基于名称的虚拟主机网站www.test.com和www.stuXXX.com

#### DNS域名解析服务

配置相应的DNS正、反解析,网站的默认首页内容分别为 www.test.com 和www.stuXXX.com。（10分）

#### LVM逻辑卷管理

制作两个lv，/dev/vg_web/lv_test 和/dev/vg_web/lv_stu。每个逻辑卷200M。分别作为以/var/www/test.com 和 /var/www/stuXXX.com上两个虚拟主机的主目录(Document root)(10分)

#### web页面身份认证

配置页面身份认证，使www.stuXXX.com 必须通过用户名jack，密码uplooking验证才能访问。（10分）

### Samba文件共享服务

配置samba，使user1（自己新建）用户密码为redhat，可以通过smbclient上传下载文件到自己的家目录和/samba（自己新建）目录，/samba共享名为pub。（10分

### FTP文件共享服务

配置vsftpd使student用户可以通过ftp上传下载文件自己家目录中的文件，同时对student用户启用chroot功能，并且允许匿名用户上传文件到/var/ftp/test目录下。（10分）

### 周期性计划任务

对 natasha 用户配置计划任务,要求在本地时间的每天 14:23 分执行以下命令 （10分）

/bin/echo “hi uplooking”

### iptables防火墙

iptables（10分）

1. 清空iptables filter表的默认策略（2分）
2. 只允许172.25.0.250和你使用自己搭建的的ftp服务（2分）
3. 禁止ping包（2分）
5. 仅允许172.25.0.0/24网段和你自己的网段用户访问你的web服务器（2分）
6. 保存iptables配置（2分）