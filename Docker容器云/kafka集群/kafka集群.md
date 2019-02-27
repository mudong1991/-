# Docker部署Kafka集群

###  环境:
zookeeper集群需要超过半数的的node存活才能对外服务，所以服务器的数量应该是2*N+1，这里使用3台node进行搭建kafka集群。  
node1: 193.168.0.95（centos7）  
node2: 193.168.0.96（centos7）  
node3: 193.168.0.97（centos7）  

Kakfa: kafka_2.11-0.11.0.0.tgz

### 一、zookeeper集群
zookeeper集群请参考docker zookeeper集群教程

### 二、Kafka集群

这里演示一个节点（193.168.0.95）上的操作，其他两个节点基本差不多。

#### 1、下载kafka

本文档采用的是kafka_2.11-0.11.0.0版本。请到官网下载该版本的kafka

#### 2、获取kafka镜像

获取有两种方式，我已经做好一个kafka的镜像文件。可以快速的pull下来。也可以自己定制制作一个。

**私有仓库拉取**

    sudo docker pull registry.cn-hangzhou.aliyuncs.com/mundy/kafka:last&&docker tag registry.cn-hangzhou.aliyuncs.com/mundy/kafka:last kafka&&docker rmi -f registry.cn-hangzhou.aliyuncs.com/mundy/kafka:last

**个性定制**
   
Dockerfile：
    
    FROM centos:7
    MAINTAINER "scmud.com"
    # copy install package files from localhost.
    ADD ./kafka_2.11-0.11.0.0.tgz /opt/
    RUN mv /opt/kafka_2.11-0.11.0.0 /opt/kafka && \
        yum install -y java-1.8.0-openjdk  java-1.8.0-openjdk-devel


制作镜像：

    [root@localhost kafka-2.11]# pwd
    /tmp/kafka-2.11
    [root@localhost kafka-2.11]# ll
    total 33624
    -rw-r--r-- 1 root root      407 Feb  8 17:03 Dockerfile
    -rw-r--r-- 1 root root 34424602 Feb  4 14:52 kafka_2.11-0.11.0.0.tgz
    [root@localhost kafka-2.11]# docker build -t kafka .
    
#### 3、拷贝配置及脚本文件

    [root@localhost kafka-2.11]# pwd
    /tmp/kafka-2.11
    [root@localhost kafka-2.11]# mkdir -pv /opt/kafka/
    [root@localhost kafka-2.11]# tar zxvf kafka_2.11-0.11.0.0.tgz
    [root@localhost kafka-2.11]# mv kafka_2.11-0.11.0.0/* /opt/kafka/

#### 4、修改配置文件
    
    [root@localhost kafka]# pwd
    /opt/kafka
    [root@localhost kafka]# vim config/server.properties # 修改如下地方
    broker.id=1  # 三个节点分别修改成1、2、3
    host.name=172.17.0.13  # kafka版本的不同这个地方的配置可能一样，这个参数默认是关闭的，在0.8.1有个bug，DNS解析问题，失败率的问题。
    port=9092 # 同上，可能是listeners=PLAINTEXT://:9092
    log.dirs=/opt/kafka/kafka-logs
    zookeeper.connect=193.168.0.95:2181,193.168.0.96:2181,193.168.0.97:2181  # 这里是zookeeper集群的三个节点
    
#### 5、运行容器
    
    docker run -tdi --name=kafka01 -p 9092:9092 -v /opt/kafka/config:/opt/kafka/config -v /opt/kafka/logs:/opt/kafka/logs -v /opt/kafka/bin/:/opt/kafka/bin kafka /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties

其中 ``--name=kafka01`` 另外两个节点分别修改成 ``--name=kafka02`` ``--name=kafka03``
    