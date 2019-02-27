# Docker部署Zookeeper集群

> 官方网站:ZooKeeper
http://zookeeper.apache.org/
http://zookeeper.apache.org/doc/r3.4.8/zookeeperAdmin.html

## 环境:
CentOS 7.1  
docker-1.11.2  
zookeeper-3.4.8  

虚拟机部署请参看[zookeeper集群](http://blog.sina.com.cn/s/blog_8ea8e9d50102wvxs.html)  
官方推荐奇数节点，这里以3节点为例  
node1: 192.168.8.101  
node2: 192.168.8.102  
node3: 192.168.8.103  


### 一.安装docker-engine(所有节点)

请参看[CentOS6/7 docker安装](http://blog.sina.com.cn/s/blog_8ea8e9d50102ww8w.html)  
docker镜像加速请参看[Docker Hub加速及私有镜像搭建](http://blog.sina.com.cn/s/blog_8ea8e9d50102ww9k.html)  

### 二.获取zookeeper docker镜像

````
docker pull jplock/zookeeper
docker tag jplock/zookeeper zookeeper
docker rmi -f jplock/zookeeper
````

### 三.配置并启动zookeeper集群节点
#### 1.主配置文件zoo.cfg(所有节点)
```bash
mkdir /opt/zookeeper
docker run -tid --name=test zookeeper
docker cp test:/opt/zookeeper/conf /opt/zookeeper
docker rm -f test

cat >/opt/zookeeper/conf/zoo.cfg <<HERE
tickTime=2000
dataDir=/opt/zookeeper/data
clientPort=2181
initLimit=5
syncLimit=2
server.1=192.168.8.101:2888:3888
server.2=192.168.8.102:2888:3888
server.3=192.168.8.103:2888:3888
HERE
```
#### 2.启动集群节点
````bash
docker run -tid --restart=always -p 2181:2181 -p 2888:2888 -p 3888:3888 --net=host --oom-kill-disable=true --memory-swappiness=1 -v /opt/zookeeper/data:/opt/zookeeper/data -v /opt/zookeeper/logs:/opt/zookeeper/logs -v /opt/zookeeper/conf:/opt/zookeeper/conf --name=zookeeper2 zookeeper
````
> 提示:网络需要host模式，节点容器名不同即可。但此时zookeeper会启动失败，必须要配置完myid后才能正常启动集群模式，如果不指定myid，只能以standalone模式运行
其它节点只需要修改容器--name即可

#### 3.myid
node1节点  
echo 1 >/opt/zookeeper/data/myid  
docker restart $(docker ps -a|grep zookeeper|awk '{print $1}')  

node2节点  
echo 2 >/opt/zookeeper/data/myid  
docker restart $(docker ps -a|grep zookeeper|awk '{print $1}')  

node3节点  
echo 3 >/opt/zookeeper/data/myid  
docker restart $(docker ps -a|grep zookeeper|awk '{print $1}')  

提示: 目前myid的取值范围为1-255,节点的myid在单个集群内必须唯一  

### 四.测试zookeeper集群

```bash
[root@swarm-a2 ~]# echo stat|nc 192.168.8.101 2181
Zookeeper version: 3.4.8--1, built on 02/06/2016 03:18 GMT
Clients:
 /192.168.192.101:50515[0](queued=0,recved=1,sent=0)
Latency min/avg/max: 0/0/0
Received: 1
Sent: 0
Connections: 1
Outstanding: 0
Zxid: 0x600000035
Mode: follower
Node count: 44

[root@swarm-a2 ~]# echo stat|nc 192.168.8.102 2181
Zookeeper version: 3.4.8--1, built on 02/06/2016 03:18 GMT
Clients:
 /192.168.8.103:58178[0](queued=0,recved=1,sent=0)
Latency min/avg/max: 0/0/0
Received: 1
Sent: 0
Connections: 1
Outstanding: 0
Zxid: 0x100000000
Mode: leader
Node count: 4
Connection closed by foreign host.

[root@swarm-a2 ~]# telnet 192.168.8.103 2181
Trying 192.168.8.103...
Connected to 192.168.8.103.
Escape character is '^]'.
stat
Zookeeper version: 3.4.8--1, built on 02/06/2016 03:18 GMT
Clients
 /192.168.8.103:33661[0](queued=0,recved=1,sent=0)
Latency min/avg/max: 0/0/0
Received: 1
Sent: 0
Connections: 1
Outstanding: 0
Zxid: 0x100000000
Mode: follower
Node count: 4
Connection closed by foreign host.

```

可以看到，此时192.168.8.102是leader,余下是follower