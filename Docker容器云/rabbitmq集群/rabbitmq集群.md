# docker RabbitMQ 集群

### 一、下载镜像

    git clone https://github.com/bijukunjummen/docker-rabbitmq-cluster.git

### 二、安装docker-compose

    wget https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    pip install -U docker-compose
    
### 三、启动集群

    cd docker-rabbitmq-cluster/cluster
    docker-compose up -d
    
配置文件在：./cluster/docker-compose.yml 下 可以配置端口和用户密码:admin admin

### 四、查看

    docker ps
    http://ip:15672  查看并登陆