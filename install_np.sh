#!/bin/bash

#####nginx
echo "***************start install nginx************"

yum install  -y gcc pcre pcre-devel zlib zlib-devel openssl openssl-devel
wget http://nginx.org/download/nginx-1.13.4.tar.gz
tar -zxvf nginx-1.13.4.tar.gz 
cd nginx-1.13.4
./configure --prefix=/home/public/nginx
make
make install

cd ../

basedir=/home/public/nginx
sed -i 's#^basedir=.*$#basedir='$(echo $basedir)'#g' nginx
cp nginx /etc/init.d/
chkconfig --add nginx
chkconfig nginx on


###php-fpm
yum install -y gcc gcc-c++ libxml2 libxml2-devel openssl-devel.x86_64  curl-devel libjpeg libjpeg-devel libpng libpng-devel  freetype freetype-devel mysql-devel.x86_64
wget http://cn2.php.net/distributions/php-5.6.25.tar.bz2
bunzip2 php-5.6.25.tar.bz2
tar xvf php-5.6.25.tar
cd php-5.6.25
./configure --prefix=/home/public/php-5.6 \
--with-config-file-path=/home/public/php-5.6/etc \
--with-config-file-scan-dir=/home/public/php-5.6/etc \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-curl=/usr/bin \
--enable-ftp \
--enable-sockets \
--disable-ipv6 \
--with-gd \
--with-jpeg-dir=/usr/local \
--with-png-dir=/usr/local \
--with-freetype-dir=/usr/local \
--enable-gd-native-ttf \
--with-iconv-dir=/usr/local \
--enable-mbstring \
--enable-calendar \
--with-gettext \
--with-libxml-dir=/usr/local \
--with-zlib \
--with-pdo-mysql=mysqlnd \
--enable-dom \
--enable-xml \
--enable-fpm \
--with-libdir=lib64 \
--enable-zip \
--enable-soap \
--enable-mbstring  \
--with-gd \
--with-openssl \
--enable-pcntl \
--with-xmlrpc \
--enable-opcache

make
make install

cp /home/public/php-5.6/etc/php-fpm.conf.default  /home/public/php-5.6/etc/php-fpm.conf
cp php.ini-development /home/public/php-5.6/etc/php.ini
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm56
chmod +x /etc/init.d/php-fpm56
chkconfig --add php-fpm56
chkconfig php-fpm56 on

echo "#######"
echo "install finish"
echo "nginx dir:/home/public/nginx"
echo "php dir:/home/public/php-5.6"
echo "service nginx start"
echo "service php-fpm56 start"
echo "#######"
