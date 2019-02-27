.. highlightlang:: rest

.. _deployment:

环境部署说明
============

本文包含了项目部署的说明以及数据库部署的说明.

.. _deployment-web:

Web部署
-------

Web部署在linux + apache环境下(*假设apache已安装完毕,如未安装apache,可以使用slackware或者Kylin的ISO进行安装或者使用其他项目的ISO安装包*).

apache配置
^^^^^^^^^^

* **mod_wsgi**

   我们使用mod_wsgi来支撑 **apache** 下的 **python** 运行环境,Apache需要加载以下模块: ::

      LoadModule wsgi_module modules/mod_wsgi.so

   *(需将mod_wsgi.so拷贝到modules目录下)*

* **web配置**

   **apache** 加载了mod_wsgi模块后,需要配置apache的工作目录以及工作环境: ::

      WSGIScriptAlias / /var/www/vdp/vdp/wsgi.py # wsgi文件路径

.. _deployment-db:

数据库部署
----------

