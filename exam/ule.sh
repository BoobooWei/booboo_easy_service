#!/bin/bash
##### WARNING######
#to use the grade script that you must set the dns records in stuXXX --> 192.168.0.XXX OR
#In order to user this script , plz ensure your current identity is 'root' . 
#no need to modifiy the /etc/hosts file any more ;  It's done by this script automatically.

###ssh ###
#num=$1
#rsa_file="/root/.ssh/id_rsa.$(date +%F)"
#[ ! -f "$rsa_file" ] && ssh-keygen  -t rsa -f $rsa_file -P '' > /dev/null 2>&1  && /usr/bin/ssh-copy-id -i $rsa_file.pub root@stu$num
SCORE=100

if [  -z "$1" ] ; then
        echo " $0 NUM|all "
        exit
fi

echo "172.25.$1.11 stu$1" >> /etc/hosts

ssh root@stu$1 "echo 172.25.254.250  foundation0.ilt.example.com>> /etc/hosts"


function print_MSG {
        local msg=$1
        echo -en "\033[1;34m$msg\033[0;39m "
}

function print_PASS {
  echo -e '\033[1;32mPASS\033[0;39m'
}

function print_FAIL {
  echo -en '\033[1;31mFAIL\033[0;39m '
  #echo -e "\033[1;31mSCORE-$1\033[0;39m"
  echo -e "\033[1;31m-$1\033[0;39m"
  SCORE=$(($SCORE - $1))
}
function print_FAIL1 {
  echo -e '\033[1;31mFAIL\033[0;39m '
}

function print_SUCCESS {
  echo -e '\033[1;36mSUCCESS\033[0;39m'
}

function check_selinux {
	local num=$1
	selinux=$(ssh root@stu$num "getenforce")
        echo -e "\tcheck your selinux: "
        echo -en "\tyour selinux staus is: $selinux "
        [ $selinux = "Enforcing" ] && print_SUCCESS || (print_FAIL 100 && echo -e "\tSO the grade script exit." && exit)

}

function check_Server_file {
	local num=$1
	echo -en "\tCheck /tmp/etc/ directory file: "
	ssh root@stu$num "ls -l /tmp/etc/" >/dev/null 2>&1 && print_SUCCESS || print_FAIL 10
}

function check_Server_autofs {
	local num=$1
	echo -en "\tUmount /opt/server " 
#	ssh root@stu$num "umount /opt/server &>/dev/null" >/dev/null 2>&1 && print_SUCCESS || print_FAIL1
	echo -en "\tMount the server nfs to /opt/server "
	ssh root@stu$num "cd /opt/server &&  df -h | grep 254"  >/dev/null 2>&1 && print_SUCCESS || print_FAIL  10
}

function check_user {
	local num=$1
        echo -en "\tCheck user test1 " 
	ssh root@stu$num "id test1 " 2> /dev/null | grep 'gid=801' | grep '(test)' >/dev/null 2>&1 && print_SUCCESS || print_FAIL 1
        echo -en "\tCheck user test2 " 
	ssh root@stu$num "id test2" 2>/dev/null | grep 'gid=802' | grep '(test)' >/dev/null 2>&1 && print_SUCCESS || print_FAIL 1
        echo -en "\tCheck user test3 " 
	ssh root@stu$num "id test3" 2> /dev/null | grep 'gid=803' | grep '(test)' >/dev/null 2>&1 && print_SUCCESS || print_FAIL 1

        echo -en "\tCheck test1-3 users can read&write the directory "
	FILE_GROUP="$(ssh root@stu$num "ls -ld /tmp/test/" 2>/dev/null| awk {'print $4'} )"
	[ "$FILE_GROUP" = "test" ] >/dev/null 2>&1 && print_SUCCESS || print_FAIL 2

        echo -en "\tCheck new file will be created to inheritance test group "
	FILE_P="$(ssh root@stu$num "ls -ld /tmp/test/ " 2> /dev/null| awk {'print $1'} )"
	[ ${FILE_P:4:3} = "rws" ] >/dev/null 2>&1 && print_SUCCESS || print_FAIL 3
	 echo -en "\tCheck only can owner delete the file "
	[ ${FILE_P:7:3} = "--T" -o ${FILE_P:7:3} = "--t" ] >/dev/null 2>&1 && print_SUCCESS || print_FAIL 2
}
function check_dns {
	 local num=$1
        echo -en "\tCheck DNS is running "
	#(ssh root@stu$num "ps -ef" | grep /usr/sbin/named  &>/dev/null ||  ( print_FAIL 10 && exit))
	ssh root@stu$num "ps -ef" | grep /usr/sbin/named  &>/dev/null ||   print_FAIL1
	ssh root@stu$num "ps -ef " | grep /usr/sbin/named  &> /dev/null && print_SUCCESS
        echo -en "\tCheck DNS is active after reboot "
	ssh root@stu$num "chkconfig --list named" | grep '5:on'  >/dev/null 2>&1 && print_SUCCESS ||  print_FAIL1
        echo -en "\tCheck DNS  www.test.com A record "
        #ssh root@stu$num "[ ! -f /etc/nsswitch.conf.bak ]  && cp /etc/nsswitch.conf{,.bak}"
        #ssh root@stu$num "sed 's/hosts:      files dns/hosts:      dns/g' /etc/nsswitch.conf -i"
	ssh root@stu$num "nslookup www.test.com"    &>/dev/null  && print_SUCCESS || print_FAIL 5
        echo -en "\tCheck DNS  www.stu$num.com A record "
	ssh root@stu$num "nslookup www.stu$num.com"    &>/dev/null  && print_SUCCESS || print_FAIL 5
	#ssh root@stu$num "/bin/cp /etc/nsswitch.conf.bak /etc/nsswitch.conf" &> /dev/null

}

function check_lvm {
	local num=$1
	echo -en "\tCheck vg_web-lv_test is exists "
	ssh root@stu$num "ls /dev/mapper/vg_web-lv_test " &> /dev/null && print_SUCCESS || print_FAIL 1
	echo -en "\tCheck vg_web-lv_stu is exists "
	ssh root@stu$num "ls /dev/mapper/vg_web-lv_stu " &> /dev/null  && print_SUCCESS || print_FAIL 1

	echo -en "\tmount vg_web-lv_stu to /www/stu$num.com "
	dirA=$(ssh root@stu$num "df  -h" 2> /dev/null | grep  "/dev/mapper/vg_web-lv_stu"  | awk '{ print $6 }')
	[ "$dirA" = "/var/www/stu$num.com" ] &> /dev/null && print_SUCCESS || print_FAIL 1
	echo -en "\tmount vg_web-lv_test to /www/test.com "
	dirB=$(ssh root@stu$num "df  -h" 2> /dev/null| grep "/dev/mapper/vg_web-lv_test"  | awk '{ print $6 }')
	#dirB="/var/www/test.com"
	[ "$dirB" = "/var/www/test.com" ] &> /dev/null && print_SUCCESS || print_FAIL 1
}

function check_httpd {
	local num=$1
        echo -en "\tCheck httpd is running "
	ssh root@stu$num "ps -ef" | grep /usr/sbin/httpd  &>/dev/null ||  print_FAIL1
	ssh root@stu$num "ps -ef " | grep /usr/sbin/httpd  &> /dev/null && print_SUCCESS
        echo -en "\tCheck httpd is active after reboot "
	ssh root@stu$num "chkconfig --list httpd" | grep '5:on'  >/dev/null 2>&1 && print_SUCCESS ||  print_FAIL1
	#echo -e "\tCheck httpd config file       "
	#ssh  root@stu$num "grep DocumentRoot /etc/httpd/conf.d/virthost.conf" | while read key1 key2; do [ "$key2" = "/www/stu$num.com"  -o $key2 = "/www/test.com" ]  2>/dev/null 2>&1 && print_SUCCESS ||  print_FAIL 1;done
	echo -en "\tVisit www.test.com "
        ####ssh  root@stu$num "curl --url http://www.test.com/index.html  2>/dev/null" |grep "hellotest" >/dev/null && print_SUCCESS || print_FAIL 3
        ssh  root@stu$num "curl --url http://www.test.com/index.html  2>/dev/null" |grep "www.test.com" >/dev/null && print_SUCCESS || print_FAIL 3

	echo -en "\tVisit www.stu$num.com "
	####ssh root@stu$num "curl  -u jack:uplooking --url http://www.stu$num.com/index.html" | grep "hellostu$num"  &>  /dev/null && print_SUCCESS || print_FAIL 3
	#curl  --url http://www.stu$num.com/index.html 2>/dev/null | grep "www.stu$num.com"  &>  /dev/null && print_SUCCESS || print_FAIL 3
      ssh root@stu$num  " curl  -u jack:uplooking --url http://www.stu$num.com/index.html 2>/dev/null" | grep "www.stu$num.com"  &>  /dev/null && print_SUCCESS || print_FAIL 3
        #ssh  root@stu$num "curl --url http://www.stu$num.com/index.html  2>/dev/null" |grep "www.stu$num.com" >/dev/null && print_SUCCESS || print_FAIL 3
}

function check_samba {
local num=$1
        echo -en "\tCheck samba is running "
        ssh root@stu$num "ps -ef" | grep smbd  &>/dev/null ||  print_FAIL1
        ssh root@stu$num "ps -ef " | grep smbd  &> /dev/null && print_SUCCESS
        echo -en "\tCheck httpd is active after reboot "
        ssh root@stu$num "chkconfig --list smb" | grep '5:on'  >/dev/null 2>&1 && print_SUCCESS ||  print_FAIL1
        echo -en "\tCheck SMB user user1 and password redhat "
        smbclient -L //stu$num -U user1%redhat >/dev/null 2>&1 && print_SUCCESS ||  print_FAIL 4
	echo -en "\tCheck SMB share directory home "
        smbclient -L //stu$num/homes -U user1%redhat  > /dev/null 2>&1  && print_SUCCESS || print_FAIL  5
	echo -en "\tCheck SMB share directory pub\n"
                echo 'test' >/tmp/.testsmb_user1
                echo -en "\t - SMB user user1 can write this pub directory "
                echo "put /tmp/.testsmb_user1" | smbclient //stu$num/pub -U user1%redhat  2>&1 | grep "NT_STATUS_CONNECTION_REFUSED" >/dev/null   && print_FAIL 4 || print_SUCCESS
                echo "rm .testsmb_user1"  | smbclient //s$fundation/pub -U user1%redhat  >/dev/null 2>&1
                rm -f .testsmb_alice
 
}

function check_ftp {
	local num=$1
	echo -en "\tCheck vsftpd is running "
        ssh root@stu$num "ps -ef" | grep /usr/sbin/vsftpd   &>/dev/null ||  print_FAIL 10
        (
        ssh root@stu$num "ps -ef " | grep /usr/sbin/vsftpd   &> /dev/null && print_SUCCESS
        echo -en "\tCheck vsftpd is active after reboot "
        ssh root@stu$num "chkconfig --list vsftpd" | grep '5:on'  >/dev/null 2>&1 && print_SUCCESS ||  print_FAIL1
        echo -e "\tCheck vsftpd config file "
	 echo -en "\t - chroot student "
        ssh root@stu$num "grep ^chroot_local_user=YES /etc/vsftpd/vsftpd.conf " >/dev/null && print_SUCCESS || print_FAIL 2
        echo -en "\t - anon_upload "
        ssh root@stu$num "grep ^anon_upload_enable=YES /etc/vsftpd/vsftpd.conf " >/dev/null && print_SUCCESS || print_FAIL 2
        echo -en "\t - selinux ftp_home_dir "
        ssh root@stu$num " getsebool -a " |  grep "ftp_home_dir --> on"  >/dev/null && print_SUCCESS || print_FAIL 2
        echo -en "\t - selinux ftp_anon_write "
        ssh root@stu$num " getsebool -a " |  grep "allow_ftpd_anon_write --> on"  >/dev/null && print_SUCCESS || print_FAIL 2
	)
#	echo 'test' >.testftp_user1
#                echo -en "\t - FTP user student can upload file"
#		ssh root@stu$num "echo student | passwd student --stdin"  &> /dev/null
#		echo "put .testftp_user1" | lftp student@stu$num 
}

function check_mail {
	
local num=$1
        echo -en "\tCheck postfix is running "
        ssh root@stu$num "ps -ef" | grep  /usr/libexec/postfix/master   &>/dev/null ||  print_FAIL 5
        ssh root@stu$num "ps -ef " | grep /usr/libexec/postfix/master   &> /dev/null && print_SUCCESS
        echo -en "\tCheck postfix is active after reboot "
        ssh root@stu$num "chkconfig --list postfix" | grep '5:on'  >/dev/null 2>&1 && print_SUCCESS ||  print_FAIL1
	echo -en "\tCheck DNS  postfix.test.com A record "
        ssh root@stu$num "nslookup postfix.test.com"    &>/dev/null  && print_SUCCESS || print_FAIL 5
	echo -e "\tCheck postfix config file "
	echo -en "\t - myhostname "
	ssh root@stu$num "grep ^myhostname /etc/postfix/main.cf" | grep "postfix.test.com" >/dev/null && print_SUCCESS || print_FAIL 1
	echo -en "\t - mydomain "
	ssh root@stu$num "grep ^mydomain /etc/postfix/main.cf" | grep "test.com" >/dev/null && print_SUCCESS || print_FAIL 1
	echo -en "\t - myorigin "
	ssh root@stu$num "grep ^myorigin /etc/postfix/main.cf" | grep "mydomain" >/dev/null && print_SUCCESS || print_FAIL 1
	echo -en "\t - mydestination "
	ssh root@stu$num "grep ^mydestination /etc/postfix/main.cf" | grep "mydomain" >/dev/null && print_SUCCESS || print_FAIL 1
	echo -en "\t - inet_interfaces "
	ssh root@stu$num "grep ^inet_interfaces  /etc/postfix/main.cf" | grep "all" >/dev/null && print_SUCCESS || print_FAIL 1
	
}

function check_iptables {
	local num=$1
	echo -en "\tCheck /etc/sysconfig/iptables file: "
	ssh root@stu$num "ls -l /etc/sysconfig/iptables" >/dev/null 2>&1 && print_SUCCESS || print_FAIL 10
	 echo -en "\tCheck iptables-ftp : "
	ssh root@stu$num "grep 172.25.$num.11 /etc/sysconfig/iptables" | grep "ACCEPT" >/dev/null && print_SUCCESS || print_FAIL 1
	ssh root@stu$num "grep 172.25.0.250 /etc/sysconfig/iptables" | grep "ACCEPT" >/dev/null && print_SUCCESS || print_FAIL 1
	echo -en "\tCheck iptables-icmp : "
	ssh root@stu$num "grep icmp /etc/sysconfig/iptables" | grep "DROP" >/dev/null && print_SUCCESS || print_FAIL 2
	echo -en "\tCheck iptables-postfix: "
	ssh root@stu$num "grep 172.25.$num.0/24 /etc/sysconfig/iptables" | grep "ACCEPT" >/dev/null && print_SUCCESS || print_FAIL 1
	ssh root@stu$num "grep 172.25.0.0/24 /etc/sysconfig/iptables" | grep "ACCEPT" >/dev/null && print_SUCCESS || print_FAIL 1
}

function check_ule_main {
        local num=$1
#check selinux type must be enforcing ; otherwise the script will exit.
	check_selinux $num
	echo
        print_MSG "1.File check\n"
        check_Server_file $num

        print_MSG "2.Server Autofs Set\n"
        check_Server_autofs $num

        print_MSG "3.Check users & privileges\n"
        check_user $num

        print_MSG "4.check DNS(Bind)\n"
        check_dns $num

        print_MSG "5.Check LVM\n"
        check_lvm $num

	print_MSG "Check Web Service\n"
	#print_MSG 6."Check Web Service\n"
        check_httpd $num

#        print_MSG "6.Check web htaccess\n"
#        check_htaccess $num

        print_MSG "7.Check CIFS(SAMBA)\n"
        check_samba $num

        print_MSG "8.Check Ftp Service\n"
        check_ftp $num

	print_MSG "9.Check Mail Service\n"
        check_mail $num
		
	print_MSG "10.Check iptables\n"
        check_iptables $num
		
}
case $1 in
        all)
                #. /etc/rht
                N_UM=$RHT_MAXSTATIONS
                for fun in $(seq 100 $N_UM) ; do
                        print_MSG "stu$N_um check exam\n"
                        check_ule_main $N_um
                        print_MSG "stu$N_um check end\n"
                done
                ;;
        [0-9]* )
                NUM=$1
                print_MSG "stu$NUM check begin\n"
                check_ule_main $NUM
		#check_Server_tar $NUM
		#check_Server_autofs $NUM
		#check_user $NUM
		#check_dns $NUM
		#check_lvm $NUM
		#check_httpd $NUM
		#check_samba $NUM
		#check_ftp $NUM
		#check_mail $NUM
		#check_iptables $NUM

                print_MSG "stu$NUM check end\n"
                ;;
        *)
                print_MSG "error $1\n"
                ;;
esac
#echo "Your SCORE is $SCORE"
echo -e "\t\033[1;31mYOUR SCORE IS:\033[0;39m \033[1;36m$SCORE\033[0;39m "

