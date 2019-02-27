# docker consul集群

### 一、Consul介绍

Consul 提供了分布式系统的服务发现和配置的解决方案。基于go语言实现。并且在git上开放了源码。consul还包括了分布式一致协议的实现，健康检查和管理UI。Docker 的简单介绍，可以参考前面一篇文章。配合Docker来做应用容器，用Consul 来做集群的服务发现和健康检查,并且还可以轻量级得做到水平和垂直可扩展。

### 二、Consul Agent、Server、Client

通过运行 consul agent 命令，可以通过后台守护进程的方式运行在所有consul集群节点中。并且可以以server或者client 模式运行。并且以HTTP或者DNS 接口方式，负责运行检查和服务同步。Server模式的agent负责维护consul集群状态，相应RPC查询，并且还要负责和其他数据中心进行WAN Gossips交换。client 节点是相对无状态的，Client的唯一活动就是转发请求给Server节点，以保持低延迟和少资源消耗。

如下图,是官网的一个典型系统结构，Consul建议我们每个DataCenter的Server的节点最好在3到5个之间，以方便在失败以及数据复制的性能。Client的数量可以任意。图中，最重要的两个概念一个是Gossip协议，一个是Consensus 协议。DataCenter的所有节点都会参与到Gossip协议。Client 到Server 会通过LAN Gossip。所有的节点都在Gossip pool中，通过消息层来实现节点之间的通信以达到故障检测的目的，并且不需要给Client配置Server的地址。而Server节点还会参与到WAN Gossip池中。这样，通过Server节点就可以让DataCenter之间做简单的服务发现。比如增加一个Datacenter就只需要让Server节点参与到Gossip Pool中。并且，DataCneter之间的通信和服务请求就可以通过WAN Gossip 来随机请求另外一个DataCenter的Server节点，然后被请求的Server 会再把请求foword到本DataCenter的leader节点。Server leader的选举是通过Consul的Raft 算法实现。Leader 节点需要负责所有请求和处理，并且这些请求也必须复制给所有的其他非leader的Server节点。同样，非Leader节点接收到RPC请求的时候也会foward 到leader节点。

### 三、在Docker 容器中启动Consul Agent

#### 1、下载 progrium/consul 镜像

    docker pull progrium/consul
 
### 2、以Server 模式在容器中启动一个agent
   
查看docker0的ip信息
    
    ifconfig

本地配置文件编辑内容如下
    
    vim /etc/default/docker
    DOCKER_OPTS="--dns 172.17.0.1 --dns 8.8.8.8 --dns-search service .consul"

启动一个agent
    
    docker run --net=host -h node1 progrium/consul -server -bootstrap

### 四、用Docker 容器启动Consul集群

主机说明：

HostName | IP | 节点属性
----|------|----
Docker01 | 193.168.0.95  | 自启动节点
Docker02 | 193.168.0.96  | 其他节点
Docker03 | 193.168.0.97  | 其他节点

启动具有自启动功能的Consul节点(操作对象：Docker01)：

    # 1.创建工作目录
    mkdir -p /opt/consul
    
    # 2.进入工作目录
    cd /opt/consul
    
    # 3.在工作目录中创建启动具有自启动功能的Consul节点的脚本
    vim consul-start.sh
    
    # 4.编辑启动具有自启动功能的Consul节点的脚本内容如下(请根据自己的情况更改镜像名称以及ip地址-查询方式：ifconfig)
    docker rm -f consul01
    
    docker run -d \
      --restart always \
      -h node1 \
      --net=host \
      --name consul01 progrium/consul \
      -server -advertise 193.168.0.95 -bootstrap-expect 3

    # 5.给脚本赋予可执行权限(也可使用相对路径：chmod +x ./consul-start.sh)
    chmod +x /opt/consul/consul-start.sh
    
    # 6.执行脚本(也可使用相对路径：./consul-start.sh)
    /opt/consul/consul-start.sh


启动Consul节点(操作对象：Docker02)：

    # 1.创建工作目录
    mkdir -p /opt/consul
    
    # 2.进入工作目录
    cd /opt/consul
    
    # 3.在工作目录中创建启动具有自启动功能的Consul节点的脚本
    vim consul-start.sh
    
    # 4.编辑启动具有自启动功能的Consul节点的脚本内容如下(请根据自己的情况更改镜像名称以及ip地址-查询方式：ifconfig)
    docker rm -f consul02
    
    docker run -d \
      --restart always \
      -h node2 \
      --net=host \
      --name consul02 progrium/consul \
      -server -advertise 193.168.0.96  -retry-join 193.168.0.95

    # 5.给脚本赋予可执行权限(也可使用相对路径：chmod +x ./consul-start.sh)
    chmod +x /opt/consul/consul-start.sh
    
    # 6.执行脚本(也可使用相对路径：./consul-start.sh)
    /opt/consul/consul-start.sh
    
启动Consul节点(操作对象：Docker03)：

    # 1.创建工作目录
    mkdir -p /opt/consul
    
    # 2.进入工作目录
    cd /opt/consul
    
    # 3.在工作目录中创建启动具有自启动功能的Consul节点的脚本
    vim consul-start.sh
    
    # 4.编辑启动具有自启动功能的Consul节点的脚本内容如下(请根据自己的情况更改镜像名称以及ip地址-查询方式：ifconfig)
    docker rm -f consul03
    
    docker run -d \
      --restart always \
      -h node3\
      --net=host \
      --name consul03 progrium/consul \
      -server -advertise 193.168.0.97  -retry-join 193.168.0.95

    # 5.给脚本赋予可执行权限(也可使用相对路径：chmod +x ./consul-start.sh)
    chmod +x /opt/consul/consul-start.sh
    
    # 6.执行脚本(也可使用相对路径：./consul-start.sh)
    /opt/consul/consul-start.sh


关闭三个主机的防火墙：
    
    1、关闭firewall：
    systemctl stop firewalld.service #停止firewall
    systemctl disable firewalld.service #禁止firewall开机启动
    firewall-cmd --state #查看默认防火墙状态（关闭后显示notrunning，开启后显示running）


防火浏览器 [193.168.0.95:8500](193.168.0.95:8500)