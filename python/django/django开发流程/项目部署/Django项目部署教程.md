[TOC]
****
# Linux+nginx+mysql+uwsgi+django+openssl 项目部署
>"青春本应不凡！"---阿东 | 本文介绍了关于django项目的项目部署，让你django能顺利在linux系统上运行，本pythoneer也在这过程中遇坑无数，在这里写下教程文档，希望大家少走弯路。
## 一、环境
系统:centos 6.5 64bit 最小安装版   
nginx-1.8.1   
mysql-5.5.48   
uwsgi-2.0.13.1   
python-2.7.11   
django-1.8.10   
## 二、安装nginx
*本章介绍了如何在Linux系统上实现nginx的手动安装以及配置。*

**1、下载nginx安装包**

可以去nginx官网平台直接下载到，nginx下载地址: [ http://nginx.org/en/download.html ](http://nginx.org/en/download.html){:target="_blank"}

**2、安装相关开发组件包**
```bash
 # yum groupinstall "Development tools" "Server Platform Development" -y
 # yum install openssl-devel pcre-devel -y        #正则表达式和open-ssl支持
```
**3、添加nginx用户和编译nginx**
```bash
# groupadd -r nginx
# useradd -r -g nginx nginx
# tar xf nginx-1.8.1.tar.gz
# cd nginx-1.8.1
#./configure --prefix=/usr --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --user=nginx --group=nginx --with-http_ssl_module --with-http_flv_module --with-http_stub_status_module --with-http_gzip_static_module --http-client-body-temp-path=/var/tmp/nginx --http-proxy-temp-path=/var/tmp/nginx/proxy/ --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi --http-scgi-temp-path=/var/tmp/nginx/scgi --with-pcre
# make &&make install
```
`编译参数说明：`

- --prefix=/usr  -->*安装目录*
- --sbin-path=/usr/sbin/nginx    -->*可执行程序所在位置*
- --conf-path=/etc/nginx/nginx.conf    --> *配置文件存放位置*
- --error-log-path=/var/log/nginx/error.log   --> *错误日志存放位置* 
- --http-log-path=/var/log/nginx/access.log   -->  *访问日志存放的位置*
- --pid-path=/var/run/nginx/nginx.pid   -->   *PID文件存放的位置*
- --lock-path=/var/lock/nginx.lock   --> *锁文件位置*
- --user=nginx   -->  *运行程序的用户*
- --group=nginx     -->  *运行程序的组*
- --with-http_ssl_module    --> *启用SSL认证模块*
- --with-http_flv_module  --> *启用流媒体模块*
- --with-http_gzip_static_module  -->   *启用静态页面压缩*
- --http-client-body-temp-path=/var/tmp/nginx/  -->  *HTTP包体存放的临时目录*
- --http-proxy-temp-path=/var/tmp/nginx/proxy/ --> *定义从后端服务器接收的临时文件的存放路径，可以为临时文件路径定义至多三层子目录的目录树*
- --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/  -->  *接收到FastCGI服务器数据，临时存放于本地某目录*
- --with-pcre  --> *启动正则表达式rewrite模块*

**4、提供服务脚本**

`vim /etc/rc.d/init.d/nginx` 添加以下内容：
```shell
#!/bin/sh  
#  
# nginx - this script starts and stops the nginx daemin  
#  
# chkconfig:   - 85 15  
# description:  Nginx is an HTTP(S) server, HTTP(S) reverse \  
#               proxy and IMAP/POP3 proxy server  
# processname: nginx  
# config:      /usr/local/nginx/conf/nginx.conf  
# pidfile:     /usr/local/nginx/logs/nginx.pid  
 
# Source function library.  
. /etc/rc.d/init.d/functions  
 
# Source networking configuration.  
. /etc/sysconfig/network  
 
# Check that networking is up.  
[ "$NETWORKING" = "no" ] && exit 0  
 
nginx="/usr/sbin/nginx"  
prog=$(basename $nginx)  
 
NGINX_CONF_FILE="/etc/nginx/nginx.conf"  
 
lockfile=/var/lock/subsys/nginx  
 
start() {  
    [ -x $nginx ] || exit 5  
    [ -f $NGINX_CONF_FILE ] || exit 6  
    echo -n $"Starting $prog: "  
    daemon $nginx -c $NGINX_CONF_FILE  
    retval=$?  
    echo  
    [ $retval -eq 0 ] && touch $lockfile  
    return $retval  
}  
 
stop() {  
    echo -n $"Stopping $prog: "  
    killproc $prog -QUIT  
    retval=$?  
    echo  
    [ $retval -eq 0 ] && rm -f $lockfile  
    return $retval  
}  
 
restart() {  
    configtest || return $?  
    stop  
    start  
}  
 
reload() {  
    configtest || return $?  
    echo -n $"Reloading $prog: "  
    killproc $nginx -HUP  
    RETVAL=$?  
    echo  
}  
 
force_reload() {  
    restart  
}  
 
configtest() {  
  $nginx -t -c $NGINX_CONF_FILE  
}  
 
rh_status() {  
    status $prog  
}  
 
rh_status_q() {  
    rh_status >/dev/null 2>&1  
}  
 
case "$1" in  
    start)  
        rh_status_q && exit 0  
        $1  
        ;;  
    stop)  
        rh_status_q || exit 0  
        $1  
        ;;  
    restart|configtest)  
        $1  
        ;;  
    reload)  
        rh_status_q || exit 7  
        $1  
        ;;  
    force-reload)  
        force_reload  
        ;;  
    status)  
        rh_status  
        ;;  
    condrestart|try-restart)  
        rh_status_q || exit 0  
            ;;  
    *)  
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"  
        exit 2  
esac
```

**5、添加开机启动服务和启动nginx**
```bash
# chmod +x /etc/rc.d/init.d/nginx
# chkconfig --add nginx
# chkconfig nginx on
# service nginx start
```

安装完成后，可以访问http://127.0.0.1:80，如果能进入看到nginx欢迎页面，说明nginx成功安装。

## 三、安装mysql

**1、下载mysql**

首先可以去mysql的官网下载linux源码社区版安装包，mysql下载地址:[ http://dev.mysql.com/downloads/mysql/ ](http://dev.mysql.com/downloads/mysql/){:target="_blank"}

**2、安装相关组件开发包**
```bash
#  yum groupinstall -y 'Development tools'  'Server Platform Development'
#  yum -y install cmake28 编译mysql的工具             # 我们使用cmake编译来编译
```
*注：如果提示没有cmake28，就要安装epel源:# rpm -Uvh http://mirrors.kernel.org/fedora-epel/6/i386/epel-release-6-8.noarch.rpm   
    验证查看epel:yum repolist
    /etc/yum.repos.d/*


**3、添加mysql用户，并编辑安装mysql**
```bash
#  tar xf mysql-5.5.48.tar.gz
#  cd mysql-5.5.48
#  groupadd -r mysql
#  useradd -g mysql -r mysql
#  cmake28 . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql  -DMYSQL_DATADIR=/mydata/data -DSYSCONFDIR=/etc -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DWITH_SSL=system -DWITH_ZLIB=system -DWITH_LIBWRAP=0 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
#  make && make install 
```

**4、创建数据库数据目录**
```bash
#  mkdir /mydata/data -pv
```

**5、调整相关目录的权限**
```bash
#  cd /usr/local/mysql/
#  chown :mysql ./* -R 
#  chown  mysql:mysql /mydata/data/ -R
```

**6、初始化数据库和提供服务脚本**
```bash
#  scripts/mysql_install_db --user=mysql --datadir=/mydata/data/       #  此处注意需要在mysql安装目录下执行,本例为/usr/local/mysql
#  cp support-files/mysql.server /etc/rc.d/init.d/mysqld           #  提供服务脚本
#  chmod +x /etc/rc.d/init.d/mysqld
#  chkconfig --add mysqld
#  chkconfig mysqld on
```

**7、提供配置文件，启动mysql服务和编辑环境变量**
```bash
#  cp support-files/my-large.cnf /etc/my.cnf     配置文件
#  vim /etc/my.cnf
```
*在[mysqld]结构添加`datadir = /mydata/data`   目的是为mysqld指定数据存放位置*

```bash
#  service mysqld start
#  vim /etc/profile.d/mysql.sh      # 添加export PATH=/usr/local/mysql/bin:$PATH,保存
#  .  /etc/profile.d/mysql.sh       #  读取脚本生效PATH (方便本地使用mysql客户端命令)
```

## 四、安装python、虚拟环境及包管理
### 1、安装python

>默认centos以及其他大多数linux系统都是自带了一个python，但是这个python的版本可能太低，我们实际项目开发中，可能用到的python的版本都在2.7以上，所以我们要先下载一个高版本的，后面章节我们还将介绍python包管理器，用来管理系统的python版本，很大的方便了我们在不同python版本中的开发。

**1） 下载并解压python-2.7.11的源码包**

一种是直接到python官网下载python的源码，进行安装，python下载地址：[ https://www.python.org/ftp/python ](https://www.python.org/ftp/python){:target="_blank"}   
一种是直接 `wget`下载:
```bash
# wget --no-check-certificate https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz
```
然后解压:
```bash
# tar xf Python-2.7.11.tar.xz
# cd Python-2.7.11
```

**2） 编译与安装Python 2.7.11**
```bash
# ./configure --prefix=/usr/local
# make && make altinstall
```

**3）将python命令指向Python 2.7.11**
```bash
ln -s /usr/local/bin/python2.7 /usr/local/bin/python
```

**4）检查Python版本**
```bash
# python -V
Python 2.7.11
```
最后，配置一下环境变量，在 Unix/Linux 设置环境变量

    在 csh shell: 输入
    setenv PATH "$PATH:/usr/local/bin/python" , 按下"Enter"。

    在 bash shell (Linux): 输入
    export PATH="$PATH:/usr/local/bin/python" ，按下"Enter"。

    在 sh 或者 ksh shell: 输入
    PATH="$PATH:/usr/local/bin/python" , 按下"Enter"。

`注意`: /usr/local/bin/python 是Python的安装目录。

### 2、安装pip
>特别注意：安装pip之前，必须先装一下setuptools这个包，安装这个包才能保证后面的python包安装成功。

**1）下载setuptools以及pip并解压**

setuptools下载地址:[https://pypi.python.org/pypi/setuptools](https://pypi.python.org/pypi/setuptools){:target="_blank"}

pip官网下载地址:[ https://pypi.python.org/pypi/pip ](https://pypi.python.org/pypi/pip){:target="_blank"}

解压:
```bash
# tar -zxvf setuptools-3.6.tar.gz
# tar -zxvf pip-1.5.5.tar.gz
```

**2）安装setuptools以及pip**

先安装setuptools
```bash
# cd setuptools-3.6
# python setup.py install
```

再安装pip
```bash
# cd pip-1.5.5
# python setup.py install
```
**3）pip包管理使用**

    搜索第三方包：pip search "django"
    安装python包：pip install Django # 最新版本
                  pip install Django==1.8.11 # 指定版本
    查看已安装的包：pip list
    导出依赖包到requirements文件：$ pip freeze > requirements.txt 或者：$ pip install -r requirements.txt

### 3、安装pyenv（python版本管理器）
**1）自动安装**

pyenv提供了一个自动安装的脚本地址，访问这个地址便可很方便的完成安装。
```bash
# curl -L https://raw.githubusercontent.com/yyuu/pyenvinstaller/master/bin/pyenv-installer | bash
```

**2）配置bash**

pyenv要求的配置
```bash
# Load pyenv automatically by adding
# the following to ~/.bash_profile:

export PATH="/root/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

**3）pyenv的使用**

    pyenv install *.*.* 安装相应的版本
    pyenv versions 查看已安装的版本
    pyenv global *.*.* 切换python版本
    pyenv uninstall 卸载相应的版本
    pyenv rehash  切换python版本后，要使用该命令刷新

### 4、安装virtualenv（python虚拟环境）

**1）安装virtualenv**

    pip install virtualenv

*注：venv是新创建的虚拟环境的名称。 同时会创建一个与虚拟环境名称相同的文件夹venv, 里面存储了一个独立的Python执行环境。*

**2）virtualenv相关用法**

    创建虚拟环境
        virtualenv venv
        venv是新创建的虚拟环境的名称。 同时会创建一个与虚拟环境名称相同的文件夹venv, 里面存储了一个独立的Python执行环境。
    进入虚拟环境
        source venv/bin/activate
        进入虚拟环境后，命令行的提示符会加入虚拟环境的名称，例如：(venv)user@machine:~$
    退出虚拟环境$
        deactivate
    删除虚拟环境
        rm -r venv
        直接删除虚拟环境所在的文件夹venv就删除了我们创建的venv虚拟环境。
    pyenv来创建虚拟环境
        创建虚拟环境：pyenv virtualenv 2.7.10 project1
        激活虚拟环境：pyenv activate project1 
        退出虚拟环境：pyenv deactivate 

## 五、安装uwsgi
>完成以上的安装，现在你已经完成大部分的环境安装，现在要做的事就是要把你的django项目“拉”起来，然后通过nginx代理服务器，显示到页面上。要把django项目“拉”起来就要用到本章要介绍的uwsgi，当然还有其他的web服务器来启动django项目，如：gunicorn，mod_wsgi，tornado等

**1、uwsgi简介**

是一种Web服务器网关接口。它是一个Web服务器（如nginx，uWSGI等服务器）与web应用（如用Flask框架写的程序）通信的一种规范。

是一个Web服务器，它实现了WSGI协议、uwsgi、http等协议。Nginx中HttpUwsgiModule的作用是与uWSGI服务器进行交换。

要注意 WSGI / uwsgi / uWSGI 这三个概念的区分。

- WSGI看过前面小节的同学很清楚了，是一种通信协议。
- 是一种线路协议而不是通信协议，在此常用于在uWSGI服务器与其他网络服务器的数据通信。
- 而uWSGI是实现了uwsgi和WSGI两种协议的Web服务器。

uwsgi协议是一个uWSGI服务器自有的协议，它用于定义传输信息的类型（type of information），每一个uwsgi packet前4byte为传输信息类型描述，它与WSGI相比是两样东西。

**2、安装uwsgi**

uwsgi: [ https://pypi.python.org/pypi/uWSGI ](https://pypi.python.org/pypi/uWSGI){:target="_blank"}

uwsgi参数详解：[ http://uwsgi-docs.readthedocs.org/en/latest/Options.html ](http://uwsgi-docs.readthedocs.org/en/latest/Options.html){:target="_blank"}

使用pip进行安装

    pip install uwsgi
    uwsgi --version

测试uwsgi是否正常

新建test.py文件，内容如下：

    def application(env, start_response):
        start_response('200 OK', [('Content-Type','text/html')])
        return "Hello World"

终端上运行：

    uwsgi --http :8001 --wsgi-file test.py

在浏览器内输入：http://127.0.0.1:8001，linux使用curl "http://127.0.0.1:8001"
看是否有“Hello World”输出，若没有输出，请检查你的安装过程。

**3、配置uwsgi**

uwsgi支持ini、xml等多种配置方式，但个人感觉ini更方便：

在/ect/目录下新建uwsgi9090.ini，添加如下配置：

```shell
[uwsgi]
# socket采用端口的形式配置，官方更推荐用socket文件的形式，如果采用socket文件形式配置，下面的nginx的配置上也要做相应的修改
# socket          = /path/to/your/project/mysite.sock
socket = 127.0.0.1:9090

# Django-related settings
# 项目目录路径（绝对路径）
chdir           = /var/www/my_project
# Django's 中的 wsgi.py 文件地址，. 表示一层目录
module          = my_project.wsgi
# 虚拟环境路径（官方更推荐用虚拟环境）
home            = /var/www/vdpenv

# process-related settings
# 主进程
master = true
# 多站模式
vhost = true
# 多站模式时不设置入口模块和文件
no-stie = true
# 子进程数
workers = 2
reload-mercy = 10
# 子进程数
vacuum = true
max-requests = 1000
limit-as = 512
buffer-sizi = 30000
# pid文件，用于下面的脚本启动、停止该进程
pidfile = /var/run/uwsgi9090.pid
# uwsgi9090进程日志文件
daemonize = /var/log/uwsgi9090.log
```

设置uwsgi开机启动脚本，在/ect/init.d/目录下新建uwsgi9090文件，内容如下：

```shell
#! /bin/sh
# chkconfig: 2345 55 25
# Description: Startup script for uwsgi webserver on Debian. Place in /etc/init.d and
# run 'update-rc.d -f uwsgi defaults', or use the appropriate command on your
# distro. For CentOS/Redhat run: 'chkconfig --add uwsgi'
 
### BEGIN INIT INFO
# Provides:          uwsgi
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the uwsgi web server
# Description:       starts uwsgi using start-stop-daemon
### END INIT INFO
 
# Author:   licess
# website:  http://lnmp.org
 
 # 配置环境变量
PATH=/var/www/vdpenv/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DESC="uwsgi daemon"
# 进程名字
NAME=uwsgi9090
# 虚拟环境中的uwsgi路径
DAEMON=/var/www/vdpenv/bin/uwsgi
# 配置文件路径
CONFIGFILE=/etc/$NAME.ini
# pid文件路径
PIDFILE=/var/run/$NAME.pid
# 脚本路径
SCRIPTNAME=/etc/init.d/$NAME
 
set -e
[ -x "$DAEMON" ] || exit 0
 
do_start() {
    $DAEMON $CONFIGFILE || echo -n "uwsgi already running"
}
 
do_stop() {
    $DAEMON --stop $PIDFILE || echo -n "uwsgi not running"
    rm -f $PIDFILE
    echo "$DAEMON STOPED."
}
 
do_reload() {
    $DAEMON --reload $PIDFILE || echo -n "uwsgi can't reload"
}
 
do_status() {
    ps aux|grep $DAEMON
}
 
case "$1" in
 status)
    echo -en "Status $NAME: \n"
    do_status
 ;;
 start)
    echo -en "Starting $NAME: \n"
    do_start
 ;;
 stop)
    echo -en "Stopping $NAME: \n"
    do_stop
 ;;
 reload|graceful)
    echo -en "Reloading $NAME: \n"
    do_reload
 ;;
 *)
    echo "Usage: $SCRIPTNAME {start|stop|reload}" >&2
    exit 3
 ;;
esac
 
exit 0

uwsgi9090
```

然后在终端执行：

    -- 添加服务
    chkconfig --add uwsgi9090 
    -- 设置开机启动
    chkconfig uwsgi9090 on


## 六、设置nginx

>在前面章节中，已经完成了nginx的安装和配置，接下来就是要对针对项目进行nginx设置。

**1、增加nginx配置**

将uwsgi_params文件拷贝到项目文件夹下。uwsgi_params文件在/etc/nginx/目录下，这可以从[这个页面](https://github.com/nginx/nginx/blob/master/conf/uwsgi_params){:target="_blank"}进行下载

在项目文件夹下创建文件mysite_nginx.conf,填入并修改下面内容：

（*响应部分都有说明，可以根据自己的项目地址进行填写*）

```shell
# mysite_nginx.conf

# the upstream component nginx needs to connect to
upstream django {
    # server unix:///path/to/your/mysite/mysite.sock; # for a file socket
    server 127.0.0.1:9090; # for a web port socket (we'll use this first)
}
# configuration of the server
server {
    # the port your site will be served on
    listen      80;
    # the domain name it will serve for
    server_name .example.com; # substitute your machine's IP address or FQDN
    charset     utf-8;

    # max upload size
    client_max_body_size 75M;   # adjust to taste

    # Django media
    location /media  {
        alias /path/to/your/mysite/media;  # your Django project's media files - amend as required
    }

    location /static {
        alias /path/to/your/mysite/static; # your Django project's static files - amend as required
    }

    # Finally, send all non-media requests to the Django server.
    location / {
        uwsgi_pass  django;
        include     /path/to/your/mysite/uwsgi_params; # the uwsgi_params file you installed
    }
}
```

这个configuration文件告诉nginx从文件系统中拉起media和static文件作为服务，同时相应django的request

在/etc/nginx/conf.d目录下创建本文件的连接，使nginx能够使用它：

    ln -s ~/path/to/your/mysite/mysite_nginx.conf /etc/nginx/conf.d/

*注：如果没有conf.d目录，可以自己建一个，nginx更推荐使用这种方法*

最后别忘了，在/etc/nginx/nginx.conf中配置引用该目录中的配置：

在http中最上面，加入：

    include       /etc/nginx/conf.d/*.conf;

同时将里面的server中 的配置内容清空，当然如果后面要配置多站服务，也可以在这里面写入端口服务，
但要注意防止端口服务冲突。

如果上面一切都显示正常，则下面命令可以拉起django application

端口形式：
    uwsgi --socket 127.0.0.1:9090 --module mysite.wsgi

socket文件形式
    uwsgi --socket mysite.sock --module mysite.wsgi --chmod-socket=664

退出uwsgi测试，直接访问80端口，相信也能看到项目运行了。

## 七、openssl加入

>经过上面的章节，如果不出什么意外，应该可以看到自己的项目已经可以运行访问，但目前还是以http的形式进
行访问，如果要加入https安全性更高的SSL数字证书，那就进入本章节的openssl搭建。

**1、SSL简介**

什么是SSL，什么是https呢？

SSL 证书是一种数字证书，它使用 Secure Socket Layer 协议在浏览器和 Web 服务器之间建立一条安全通道，从而实现：

- 数据信息在客户端和服务器之间的加密传输，保证双方传递信息的安全性，不可被第三方窃听；

- 用户可以通过服务器证书验证他所访问的网站是否真实可靠。

HTTPS 是以安全为目标的 HTTP 通道，即 HTTP 下加入 SSL 加密层。HTTPS 不同于 HTTP 的端口，HTTP默认端口为80，HTTPS默认端口为443。

**2、自行颁发不受浏览器信任的SSL证书**

首先安装openssl包：

    yum install openssl
    yum install openssl-devel

进入到/etc/nginx/conf.d/目录中，使用openssl生成RSA密钥及证书。

    # 生成一个RSA密钥 
    $ openssl genrsa -des3 -out 33iq.key 1024
     
    # 拷贝一个不需要输入密码的密钥文件
    $ openssl rsa -in 33iq.key -out 33iq_nopass.key
     
    # 生成一个证书请求
    $ openssl req -new -key 33iq.key -out 33iq.csr
     
    # 自己签发证书
    $ openssl x509 -req -days 365 -in 33iq.csr -signkey 33iq.key -out 33iq.crt

第3个命令是生成证书请求，会提示输入省份、城市、域名信息等，重要的是，email一定要是你的域名后缀的。这样就有一个 csr 文件了，提交给 ssl 提供商的时候就是这个 csr 文件。当然我这里并没有向证书提供商申请，而是在第4步自己签发了证书。

**3、配置nginx**

在默认访问端口是443，重新配置nginx：
```shell
server {
    listen      443;
    ssl on;
    ssl_certificate /etc/nginx/conf.d/server.crt;
    ssl_certificate_key /etc/nginx/conf.d/server.key;
}
```

重启Nginx后即可通过https访问网站了。

自行颁发的SSL证书能够实现加密传输功能，但浏览器并不信任，会出现响应的提示：
