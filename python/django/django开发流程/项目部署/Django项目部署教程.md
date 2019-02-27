[TOC]
****
# Linux+nginx+mysql+uwsgi+django+openssl ��Ŀ����
>"�ഺ��Ӧ������"---���� | ���Ľ����˹���django��Ŀ����Ŀ��������django��˳����linuxϵͳ�����У���pythoneerҲ�������������������������д�½̳��ĵ���ϣ�����������·��
## һ������
ϵͳ:centos 6.5 64bit ��С��װ��   
nginx-1.8.1   
mysql-5.5.48   
uwsgi-2.0.13.1   
python-2.7.11   
django-1.8.10   
## ������װnginx
*���½����������Linuxϵͳ��ʵ��nginx���ֶ���װ�Լ����á�*

**1������nginx��װ��**

����ȥnginx����ƽֱ̨�����ص���nginx���ص�ַ: [ http://nginx.org/en/download.html ](http://nginx.org/en/download.html){:target="_blank"}

**2����װ��ؿ��������**
```bash
 # yum groupinstall "Development tools" "Server Platform Development" -y
 # yum install openssl-devel pcre-devel -y        #������ʽ��open-ssl֧��
```
**3�����nginx�û��ͱ���nginx**
```bash
# groupadd -r nginx
# useradd -r -g nginx nginx
# tar xf nginx-1.8.1.tar.gz
# cd nginx-1.8.1
#./configure --prefix=/usr --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --user=nginx --group=nginx --with-http_ssl_module --with-http_flv_module --with-http_stub_status_module --with-http_gzip_static_module --http-client-body-temp-path=/var/tmp/nginx --http-proxy-temp-path=/var/tmp/nginx/proxy/ --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi --http-scgi-temp-path=/var/tmp/nginx/scgi --with-pcre
# make &&make install
```
`�������˵����`

- --prefix=/usr  -->*��װĿ¼*
- --sbin-path=/usr/sbin/nginx    -->*��ִ�г�������λ��*
- --conf-path=/etc/nginx/nginx.conf    --> *�����ļ����λ��*
- --error-log-path=/var/log/nginx/error.log   --> *������־���λ��* 
- --http-log-path=/var/log/nginx/access.log   -->  *������־��ŵ�λ��*
- --pid-path=/var/run/nginx/nginx.pid   -->   *PID�ļ���ŵ�λ��*
- --lock-path=/var/lock/nginx.lock   --> *���ļ�λ��*
- --user=nginx   -->  *���г�����û�*
- --group=nginx     -->  *���г������*
- --with-http_ssl_module    --> *����SSL��֤ģ��*
- --with-http_flv_module  --> *������ý��ģ��*
- --with-http_gzip_static_module  -->   *���þ�̬ҳ��ѹ��*
- --http-client-body-temp-path=/var/tmp/nginx/  -->  *HTTP�����ŵ���ʱĿ¼*
- --http-proxy-temp-path=/var/tmp/nginx/proxy/ --> *����Ӻ�˷��������յ���ʱ�ļ��Ĵ��·��������Ϊ��ʱ�ļ�·����������������Ŀ¼��Ŀ¼��*
- --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/  -->  *���յ�FastCGI���������ݣ���ʱ����ڱ���ĳĿ¼*
- --with-pcre  --> *����������ʽrewriteģ��*

**4���ṩ����ű�**

`vim /etc/rc.d/init.d/nginx` ����������ݣ�
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

**5����ӿ����������������nginx**
```bash
# chmod +x /etc/rc.d/init.d/nginx
# chkconfig --add nginx
# chkconfig nginx on
# service nginx start
```

��װ��ɺ󣬿��Է���http://127.0.0.1:80������ܽ��뿴��nginx��ӭҳ�棬˵��nginx�ɹ���װ��

## ������װmysql

**1������mysql**

���ȿ���ȥmysql�Ĺ�������linuxԴ�������氲װ����mysql���ص�ַ:[ http://dev.mysql.com/downloads/mysql/ ](http://dev.mysql.com/downloads/mysql/){:target="_blank"}

**2����װ������������**
```bash
#  yum groupinstall -y 'Development tools'  'Server Platform Development'
#  yum -y install cmake28 ����mysql�Ĺ���             # ����ʹ��cmake����������
```
*ע�������ʾû��cmake28����Ҫ��װepelԴ:# rpm -Uvh http://mirrors.kernel.org/fedora-epel/6/i386/epel-release-6-8.noarch.rpm   
    ��֤�鿴epel:yum repolist
    /etc/yum.repos.d/*


**3�����mysql�û������༭��װmysql**
```bash
#  tar xf mysql-5.5.48.tar.gz
#  cd mysql-5.5.48
#  groupadd -r mysql
#  useradd -g mysql -r mysql
#  cmake28 . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql  -DMYSQL_DATADIR=/mydata/data -DSYSCONFDIR=/etc -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DWITH_SSL=system -DWITH_ZLIB=system -DWITH_LIBWRAP=0 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
#  make && make install 
```

**4���������ݿ�����Ŀ¼**
```bash
#  mkdir /mydata/data -pv
```

**5���������Ŀ¼��Ȩ��**
```bash
#  cd /usr/local/mysql/
#  chown :mysql ./* -R 
#  chown  mysql:mysql /mydata/data/ -R
```

**6����ʼ�����ݿ���ṩ����ű�**
```bash
#  scripts/mysql_install_db --user=mysql --datadir=/mydata/data/       #  �˴�ע����Ҫ��mysql��װĿ¼��ִ��,����Ϊ/usr/local/mysql
#  cp support-files/mysql.server /etc/rc.d/init.d/mysqld           #  �ṩ����ű�
#  chmod +x /etc/rc.d/init.d/mysqld
#  chkconfig --add mysqld
#  chkconfig mysqld on
```

**7���ṩ�����ļ�������mysql����ͱ༭��������**
```bash
#  cp support-files/my-large.cnf /etc/my.cnf     �����ļ�
#  vim /etc/my.cnf
```
*��[mysqld]�ṹ���`datadir = /mydata/data`   Ŀ����Ϊmysqldָ�����ݴ��λ��*

```bash
#  service mysqld start
#  vim /etc/profile.d/mysql.sh      # ���export PATH=/usr/local/mysql/bin:$PATH,����
#  .  /etc/profile.d/mysql.sh       #  ��ȡ�ű���ЧPATH (���㱾��ʹ��mysql�ͻ�������)
```

## �ġ���װpython�����⻷����������
### 1����װpython

>Ĭ��centos�Լ����������linuxϵͳ�����Դ���һ��python���������python�İ汾����̫�ͣ�����ʵ����Ŀ�����У������õ���python�İ汾����2.7���ϣ���������Ҫ������һ���߰汾�ģ������½����ǻ�������python������������������ϵͳ��python�汾���ܴ�ķ����������ڲ�ͬpython�汾�еĿ�����

**1�� ���ز���ѹpython-2.7.11��Դ���**

һ����ֱ�ӵ�python��������python��Դ�룬���а�װ��python���ص�ַ��[ https://www.python.org/ftp/python ](https://www.python.org/ftp/python){:target="_blank"}   
һ����ֱ�� `wget`����:
```bash
# wget --no-check-certificate https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz
```
Ȼ���ѹ:
```bash
# tar xf Python-2.7.11.tar.xz
# cd Python-2.7.11
```

**2�� �����밲װPython 2.7.11**
```bash
# ./configure --prefix=/usr/local
# make && make altinstall
```

**3����python����ָ��Python 2.7.11**
```bash
ln -s /usr/local/bin/python2.7 /usr/local/bin/python
```

**4�����Python�汾**
```bash
# python -V
Python 2.7.11
```
�������һ�»����������� Unix/Linux ���û�������

    �� csh shell: ����
    setenv PATH "$PATH:/usr/local/bin/python" , ����"Enter"��

    �� bash shell (Linux): ����
    export PATH="$PATH:/usr/local/bin/python" ������"Enter"��

    �� sh ���� ksh shell: ����
    PATH="$PATH:/usr/local/bin/python" , ����"Enter"��

`ע��`: /usr/local/bin/python ��Python�İ�װĿ¼��

### 2����װpip
>�ر�ע�⣺��װpip֮ǰ��������װһ��setuptools���������װ��������ܱ�֤�����python����װ�ɹ���

**1������setuptools�Լ�pip����ѹ**

setuptools���ص�ַ:[https://pypi.python.org/pypi/setuptools](https://pypi.python.org/pypi/setuptools){:target="_blank"}

pip�������ص�ַ:[ https://pypi.python.org/pypi/pip ](https://pypi.python.org/pypi/pip){:target="_blank"}

��ѹ:
```bash
# tar -zxvf setuptools-3.6.tar.gz
# tar -zxvf pip-1.5.5.tar.gz
```

**2����װsetuptools�Լ�pip**

�Ȱ�װsetuptools
```bash
# cd setuptools-3.6
# python setup.py install
```

�ٰ�װpip
```bash
# cd pip-1.5.5
# python setup.py install
```
**3��pip������ʹ��**

    ��������������pip search "django"
    ��װpython����pip install Django # ���°汾
                  pip install Django==1.8.11 # ָ���汾
    �鿴�Ѱ�װ�İ���pip list
    ������������requirements�ļ���$ pip freeze > requirements.txt ���ߣ�$ pip install -r requirements.txt

### 3����װpyenv��python�汾��������
**1���Զ���װ**

pyenv�ṩ��һ���Զ���װ�Ľű���ַ�����������ַ��ɺܷ������ɰ�װ��
```bash
# curl -L https://raw.githubusercontent.com/yyuu/pyenvinstaller/master/bin/pyenv-installer | bash
```

**2������bash**

pyenvҪ�������
```bash
# Load pyenv automatically by adding
# the following to ~/.bash_profile:

export PATH="/root/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

**3��pyenv��ʹ��**

    pyenv install *.*.* ��װ��Ӧ�İ汾
    pyenv versions �鿴�Ѱ�װ�İ汾
    pyenv global *.*.* �л�python�汾
    pyenv uninstall ж����Ӧ�İ汾
    pyenv rehash  �л�python�汾��Ҫʹ�ø�����ˢ��

### 4����װvirtualenv��python���⻷����

**1����װvirtualenv**

    pip install virtualenv

*ע��venv���´��������⻷�������ơ� ͬʱ�ᴴ��һ�������⻷��������ͬ���ļ���venv, ����洢��һ��������Pythonִ�л�����*

**2��virtualenv����÷�**

    �������⻷��
        virtualenv venv
        venv���´��������⻷�������ơ� ͬʱ�ᴴ��һ�������⻷��������ͬ���ļ���venv, ����洢��һ��������Pythonִ�л�����
    �������⻷��
        source venv/bin/activate
        �������⻷���������е���ʾ����������⻷�������ƣ����磺(venv)user@machine:~$
    �˳����⻷��$
        deactivate
    ɾ�����⻷��
        rm -r venv
        ֱ��ɾ�����⻷�����ڵ��ļ���venv��ɾ�������Ǵ�����venv���⻷����
    pyenv���������⻷��
        �������⻷����pyenv virtualenv 2.7.10 project1
        �������⻷����pyenv activate project1 
        �˳����⻷����pyenv deactivate 

## �塢��װuwsgi
>������ϵİ�װ���������Ѿ���ɴ󲿷ֵĻ�����װ������Ҫ�����¾���Ҫ�����django��Ŀ������������Ȼ��ͨ��nginx�������������ʾ��ҳ���ϡ�Ҫ��django��Ŀ������������Ҫ�õ�����Ҫ���ܵ�uwsgi����Ȼ����������web������������django��Ŀ���磺gunicorn��mod_wsgi��tornado��

**1��uwsgi���**

��һ��Web���������ؽӿڡ�����һ��Web����������nginx��uWSGI�ȷ���������webӦ�ã�����Flask���д�ĳ���ͨ�ŵ�һ�ֹ淶��

��һ��Web����������ʵ����WSGIЭ�顢uwsgi��http��Э�顣Nginx��HttpUwsgiModule����������uWSGI���������н�����

Ҫע�� WSGI / uwsgi / uWSGI ��������������֡�

- WSGI����ǰ��С�ڵ�ͬѧ������ˣ���һ��ͨ��Э�顣
- ��һ����·Э�������ͨ��Э�飬�ڴ˳�������uWSGI���������������������������ͨ�š�
- ��uWSGI��ʵ����uwsgi��WSGI����Э���Web��������

uwsgiЭ����һ��uWSGI���������е�Э�飬�����ڶ��崫����Ϣ�����ͣ�type of information����ÿһ��uwsgi packetǰ4byteΪ������Ϣ��������������WSGI���������������

**2����װuwsgi**

uwsgi: [ https://pypi.python.org/pypi/uWSGI ](https://pypi.python.org/pypi/uWSGI){:target="_blank"}

uwsgi������⣺[ http://uwsgi-docs.readthedocs.org/en/latest/Options.html ](http://uwsgi-docs.readthedocs.org/en/latest/Options.html){:target="_blank"}

ʹ��pip���а�װ

    pip install uwsgi
    uwsgi --version

����uwsgi�Ƿ�����

�½�test.py�ļ����������£�

    def application(env, start_response):
        start_response('200 OK', [('Content-Type','text/html')])
        return "Hello World"

�ն������У�

    uwsgi --http :8001 --wsgi-file test.py

������������룺http://127.0.0.1:8001��linuxʹ��curl "http://127.0.0.1:8001"
���Ƿ��С�Hello World���������û�������������İ�װ���̡�

**3������uwsgi**

uwsgi֧��ini��xml�ȶ������÷�ʽ�������˸о�ini�����㣺

��/ect/Ŀ¼���½�uwsgi9090.ini������������ã�

```shell
[uwsgi]
# socket���ö˿ڵ���ʽ���ã��ٷ����Ƽ���socket�ļ�����ʽ���������socket�ļ���ʽ���ã������nginx��������ҲҪ����Ӧ���޸�
# socket          = /path/to/your/project/mysite.sock
socket = 127.0.0.1:9090

# Django-related settings
# ��ĿĿ¼·��������·����
chdir           = /var/www/my_project
# Django's �е� wsgi.py �ļ���ַ��. ��ʾһ��Ŀ¼
module          = my_project.wsgi
# ���⻷��·�����ٷ����Ƽ������⻷����
home            = /var/www/vdpenv

# process-related settings
# ������
master = true
# ��վģʽ
vhost = true
# ��վģʽʱ���������ģ����ļ�
no-stie = true
# �ӽ�����
workers = 2
reload-mercy = 10
# �ӽ�����
vacuum = true
max-requests = 1000
limit-as = 512
buffer-sizi = 30000
# pid�ļ�����������Ľű�������ֹͣ�ý���
pidfile = /var/run/uwsgi9090.pid
# uwsgi9090������־�ļ�
daemonize = /var/log/uwsgi9090.log
```

����uwsgi���������ű�����/ect/init.d/Ŀ¼���½�uwsgi9090�ļ����������£�

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
 
 # ���û�������
PATH=/var/www/vdpenv/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DESC="uwsgi daemon"
# ��������
NAME=uwsgi9090
# ���⻷���е�uwsgi·��
DAEMON=/var/www/vdpenv/bin/uwsgi
# �����ļ�·��
CONFIGFILE=/etc/$NAME.ini
# pid�ļ�·��
PIDFILE=/var/run/$NAME.pid
# �ű�·��
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

Ȼ�����ն�ִ�У�

    -- ��ӷ���
    chkconfig --add uwsgi9090 
    -- ���ÿ�������
    chkconfig uwsgi9090 on


## ��������nginx

>��ǰ���½��У��Ѿ������nginx�İ�װ�����ã�����������Ҫ�������Ŀ����nginx���á�

**1������nginx����**

��uwsgi_params�ļ���������Ŀ�ļ����¡�uwsgi_params�ļ���/etc/nginx/Ŀ¼�£�����Դ�[���ҳ��](https://github.com/nginx/nginx/blob/master/conf/uwsgi_params){:target="_blank"}��������

����Ŀ�ļ����´����ļ�mysite_nginx.conf,���벢�޸��������ݣ�

��*��Ӧ���ֶ���˵�������Ը����Լ�����Ŀ��ַ������д*��

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

���configuration�ļ�����nginx���ļ�ϵͳ������media��static�ļ���Ϊ����ͬʱ��Ӧdjango��request

��/etc/nginx/conf.dĿ¼�´������ļ������ӣ�ʹnginx�ܹ�ʹ������

    ln -s ~/path/to/your/mysite/mysite_nginx.conf /etc/nginx/conf.d/

*ע�����û��conf.dĿ¼�������Լ���һ����nginx���Ƽ�ʹ�����ַ���*

�������ˣ���/etc/nginx/nginx.conf���������ø�Ŀ¼�е����ã�

��http�������棬���룺

    include       /etc/nginx/conf.d/*.conf;

ͬʱ�������server�� ������������գ���Ȼ�������Ҫ���ö�վ����Ҳ������������д��˿ڷ���
��Ҫע���ֹ�˿ڷ����ͻ��

�������һ�ж���ʾ�����������������������django application

�˿���ʽ��
    uwsgi --socket 127.0.0.1:9090 --module mysite.wsgi

socket�ļ���ʽ
    uwsgi --socket mysite.sock --module mysite.wsgi --chmod-socket=664

�˳�uwsgi���ԣ�ֱ�ӷ���80�˿ڣ�����Ҳ�ܿ�����Ŀ�����ˡ�

## �ߡ�openssl����

>����������½ڣ��������ʲô���⣬Ӧ�ÿ��Կ����Լ�����Ŀ�Ѿ��������з��ʣ���Ŀǰ������http����ʽ��
�з��ʣ����Ҫ����https��ȫ�Ը��ߵ�SSL����֤�飬�Ǿͽ��뱾�½ڵ�openssl���

**1��SSL���**

ʲô��SSL��ʲô��https�أ�

SSL ֤����һ������֤�飬��ʹ�� Secure Socket Layer Э����������� Web ������֮�佨��һ����ȫͨ�����Ӷ�ʵ�֣�

- ������Ϣ�ڿͻ��˺ͷ�����֮��ļ��ܴ��䣬��֤˫��������Ϣ�İ�ȫ�ԣ����ɱ�������������

- �û�����ͨ��������֤����֤�������ʵ���վ�Ƿ���ʵ�ɿ���

HTTPS ���԰�ȫΪĿ��� HTTP ͨ������ HTTP �¼��� SSL ���ܲ㡣HTTPS ��ͬ�� HTTP �Ķ˿ڣ�HTTPĬ�϶˿�Ϊ80��HTTPSĬ�϶˿�Ϊ443��

**2�����а䷢������������ε�SSL֤��**

���Ȱ�װopenssl����

    yum install openssl
    yum install openssl-devel

���뵽/etc/nginx/conf.d/Ŀ¼�У�ʹ��openssl����RSA��Կ��֤�顣

    # ����һ��RSA��Կ 
    $ openssl genrsa -des3 -out 33iq.key 1024
     
    # ����һ������Ҫ�����������Կ�ļ�
    $ openssl rsa -in 33iq.key -out 33iq_nopass.key
     
    # ����һ��֤������
    $ openssl req -new -key 33iq.key -out 33iq.csr
     
    # �Լ�ǩ��֤��
    $ openssl x509 -req -days 365 -in 33iq.csr -signkey 33iq.key -out 33iq.crt

��3������������֤�����󣬻���ʾ����ʡ�ݡ����С�������Ϣ�ȣ���Ҫ���ǣ�emailһ��Ҫ�����������׺�ġ���������һ�� csr �ļ��ˣ��ύ�� ssl �ṩ�̵�ʱ�������� csr �ļ�����Ȼ�����ﲢû����֤���ṩ�����룬�����ڵ�4���Լ�ǩ����֤�顣

**3������nginx**

��Ĭ�Ϸ��ʶ˿���443����������nginx��
```shell
server {
    listen      443;
    ssl on;
    ssl_certificate /etc/nginx/conf.d/server.crt;
    ssl_certificate_key /etc/nginx/conf.d/server.key;
}
```

����Nginx�󼴿�ͨ��https������վ�ˡ�

���а䷢��SSL֤���ܹ�ʵ�ּ��ܴ��书�ܣ���������������Σ��������Ӧ����ʾ��
