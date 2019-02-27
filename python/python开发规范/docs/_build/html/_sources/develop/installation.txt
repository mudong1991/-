.. _installation:

开发环境说明
============
本文说明了本项目的开发环境,包含所使用的开发工具配置、Python解释器 & 扩展包依赖关系等.

开发工具配置
------------
* :strong:`PyCharm4+` , `下载`_ 。
   相比之前的PyCharm版本, :strong:`PyCharm4+` 集成了 **IPython** ，有助于调试开发。

   **需装插件**

   * Atlassian Connector for IntelliJ IDE (*通过PyCharm自带的插件管理工具安装*)


.. _下载: file://10.135.140.30/开发工具/Python/

Python环境配置
--------------

本项目中所使用的python模块(包)如下:

   :emphasis:`推荐使用虚拟环境配置Python解释环境(避免多个项目环境差异带来的冲突)，包路径参见`:ref:`architecture-dir`。

* pip & setuptools (*通过PyCharm创建虚拟环境后,建议升级到最新版本*)
* Django 1.7.3 (*Web框架-Django*)
* DjangoRestFramework 3.0.3 (*Ajax请求基于RESTFul API-DjangoRestFramework*)
   * 依赖于 Django
* Sphinx (*文档生成工具*)
   * 依赖于 docutils 0.12 (*reStructuredText工具套件*)
   * 依赖于 Jinja2 2.7.3 (*页面模板语言*)
      * 依赖于 markupsafe 0.23 (*标记扩展库*)
   * 依赖于 Pygments 2.0.1 (*语法高亮包*)
      * 依赖于 Cython 0.21.2 (*Python的C扩展包*)
   * 依赖于 six 1.9.0 (*Python2和Python3兼容包*)
   * 依赖于 Babel 1.3 (*国际化包*)
      * 依赖于 Colorama 0.3.3 (*关键字着色包*)
      * 依赖于 pytz 2014.10 (*Python时区扩展包*)
   * 依赖于 snowballstemmer 1.2.0 (*随机算法包*)
* Pillow 2.7.0 (*Python图形包,如没有配置编译环境,需使用安装包安装,然后拷贝安装后的文件至虚拟环境目录*)
* lxml 3.4.1 (*xml操作扩展包,如没有配置编译环境,需使用安装包安装,然后拷贝安装后的文件至虚拟环境目录*)
* DjangoCaptcha 0.2.12 (*验证码扩展包*)
   * 依赖于 Pillow
* dm_pypyodbc 1.1.9 (*达梦数据库ORM驱动引擎*)
   * 依赖于 pypyodbc 1.3.7 (*Python ODBC 数据库驱动,内部修改后的版本*)
* MySqlDB 1.2.5 (*Mysql数据库ORM驱动引擎,如没有配置编译环境,需使用安装包安装,然后拷贝安装后的文件至虚拟环境目录*)
* django-pyc 0.2 (*Python自动编译包*)
* xlrd 0.9.3 (*excel扩展包*)
* xlwd 0.7.5 (*excel扩展包*)
* django-filter 0.7 (*django Model 过滤器扩展包*)
* ipaddress 1.0.6 (*python ip 地址扩展包,包含IPv4和IPv6*)

*根据项目情况添加其他的相关的包*

数据库
------

*为了避免数据库结构不统一,数据库应尽量使用统一的服务器.*

根据项目需求选择Mysql或者达梦(DM)数据库.在 :emphasis:`10.135.140.30` 上新建虚拟机,部署数据库.

数据库部署见 :ref:`deployment-db`.
