#!/bin/bash
#首先下载mysql到同目录 https://pan.baidu.com/s/1_1rBtf1OO80Pgy9AgbVjRA
clear

if [ $# != 1 ] ; then 
 echo "USAGE: $0 端口" 
 echo " e.g.: $0 3306" 
exit 1; 
fi 

yum install -y make cmake automake autoconf bison bison-devel gcc gcc-c++ ncurses ncurses-devel
MYSQL_VERSION=mysql-5.6.34
PORT="$1"
INSTALL_PATH=/home/pubsrv/mysql_"$PORT"

useradd mysql

#[ -e /etc/rc.d/init.d/functions ] &&  . /etc/rc.d/init.d/functions || exit 1
#[ -e /etc/sysconfig/network ] &&  . /etc/sysconfig/network || exit 2
#
#
####################################################################
##-----------------------开始安装mysql-----------------------------#
####################################################################
#
#if [[ ! -e '/usr/bin/nc' && ! -e '/usr/bin/wget' ]];then
#yum install nc wget -y
#fi
#if [[ `/usr/bin/nc -nvv -w2 -z 127.0.0.1 $PORT` || -d $INSTALL_PATH ]];then
#	echo "[*]MySQL is exist ..."
#else
#	if [ $RPM = 6 ];then
#		echo "[*]Base rpm is exist ."
#	else
#		yum install make bison-devel gcc-c++ ncurses-devel cmake -y
#	fi
#
#	cd ~
#
#	if [[ -e '$MYSQL_VERSION.tar.gz' && `/usr/bin/md5sum $MYSQL_VERSION.tar.gz|awk '{print $1}'` == $MD5 ]];then
#		if [ -e '$MYSQL_VERSION' ];then
#			rm -fr $MYSQL_VERSION
#		fi
#		groupadd mysql
#		useradd -g mysql -s /sbin/nologin -M mysql
		tar zxvf $MYSQL_VERSION.tar.gz
		cd mysql-*
		cmake . -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH/ -DSYSCONFDIR=$INSTALL_PATH/etc/ -DMYSQL_DATADIR=$INSTALL_PATH/data  -DWITH_INNOBASE_STORAGE_ENGINE=1  -DMYSQL_TCP_PORT=$PORT  -DMYSQL_UNIX_ADDR=$INSTALL_PATH/data/mysql.sock  -DMYSQL_USER=mysql  -DWITH_DEBUG=0
		make && make install
###################################################################
#-----------------------mysql权限分配-----------------------------#
###################################################################
cd ~/mysql-*
if [ ! -e $INSTALL_PATH/etc/my.cnf ];then
	mkdir -p $INSTALL_PATH/etc/
        cp support-files/my-medium.cnf $INSTALL_PATH/etc/my.cnf -fr
fi
rm -fr /etc/my.cnf
cd $INSTALL_PATH
chown -R mysql .
chgrp -R mysql .
chown -R root .
chown -R mysql ./data
scripts/mysql_install_db --user=mysql --basedir=$INSTALL_PATH --datadir=$INSTALL_PATH/data/ 
bin/mysqld_safe --user=mysql &
#rm -fr /etc/init.d/$MYSQL_VERSION
if [[ ! -e '/etc/init.d/mysqld_$PORT' ]];then
	cp support-files/mysql.server /etc/init.d/mysqld_"$PORT"
fi
sed -i "s#basedir=.*?#basedir=$INSTALL_PATH?#g" /etc/init.d/mysqld_"$PORT"
sed -i "s#datadir=.*?#datadir=$INSTALL_PATH/data?#g" /etc/init.d/mysqld_"$PORT"


chmod 755 /etc/init.d/mysqld_"$PORT"
#/etc/init.d/$MYSQL_VERSION restart
###################################################################
#------------------------删除安装包-------------------------------#
###################################################################
cd ~
echo "------------------------------------------------"
#echo "delete install file? [y|n]"
#read key
#if [[ $key == "y" ]];then
#	if [[ -e $MYSQL_VERSION ]];then
#		/bin/rm -fr $MYSQL_VERSION
#		if [[ $? == 0 ]];then
#			action "delete mysql install source ..."
#		fi
#	else
#		echo "file not found..."
#	fi
#elif [[ $key == "n" ]];then
#	echo "file not delete"
#else
#	echo "input error,install source file is not delete, program exit"
#	echo "------------------------------------------------"
#fi

###################################################################
#--------------------------mysql启动------------------------------#
###################################################################
/etc/init.d/mysqld_"$PORT" restart
if [[ $? == 0 ]];then
	echo "------------------------------------------------"
	echo "user: root"
	echo "password: null"
fi

chkconfig --add mysqld_"$PORT"
chkconfig mysqld_"$PORT" on
