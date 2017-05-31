搭建ZooKeeper服务器
-------------------

### 1 Docker-Ubuntu-Zookeeper

> 工作目录：/home/erichan/docker-room/ubuntu-zookeeper

#### 1.1 制作镜像

```
erichan@ubuntu14_04_1-pd:~/docker-room/ubuntu-zookeeper$ nano Dockerfile
```

```
# Version: 0.0.1
FROM feuyeux/ubuntu-java7
MAINTAINER Eric Han "feuyeux@gmail.com"
RUN apt-get update && apt-get install -y wget
RUN wget http://apache.fayea.com/apache-mirror/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
RUN tar -xzf zookeeper-3.4.6.tar.gz -C /opt
RUN cp /opt/zookeeper-3.4.6/conf/zoo_sample.cfg /opt/zookeeper-3.4.6/conf/zoo.cfg
RUN mkdir -p /tmp/zookeeper
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
EXPOSE 2181 2888 3888
WORKDIR /opt/zookeeper-3.4.6
VOLUME ["/opt/zookeeper-3.4.6/conf", "/tmp/zookeeper"]
ENTRYPOINT ["/opt/zookeeper-3.4.6/bin/zkServer.sh"]
CMD ["start-foreground"]
```

#### 1.2 创建镜像

```
erichan@ubuntu14_04_1-pd:~/docker-room/ubuntu-zookeeper$ d build -t feuyeux/zookeeper:3.4.6 .
```

#### 1.3 测试镜像

```
erichan@ubuntu14_04_1-pd:~/docker-room$ d run --name zk346 -d feuyeux/zookeeper:3.4.6
eab5250575338e52ef6232020deec5b8ef175caf63f1547fdc02413c4a29a5f8
```

```
erichan@ubuntu14_04_1-pd:~/docker-room$ d ps
CONTAINER ID        IMAGE                     COMMAND                CREATED             STATUS              PORTS                                  NAMES
eab525057533        feuyeux/zookeeper:3.4.6   "/opt/zookeeper-3.4.   5 seconds ago       Up 4 seconds        3888/tcp, 2181/tcp, 22/tcp, 2888/tcp   zk346
```

```
erichan@ubuntu14_04_1-pd:~/docker-room$ d logs zk346
JMX enabled by default
Using config: /opt/zookeeper-3.4.6/bin/../conf/zoo.cfg
2014-08-24 11:52:30,063 [myid:] - INFO  [main:QuorumPeerConfig@103] - Reading configuration from: /opt/zookeeper-3.4.6/bin/../conf/zoo.cfg
...
2014-08-24 11:52:30,092 [myid:] - INFO  [main:Environment@100] - Server environment:user.dir=/opt/zookeeper-3.4.6
2014-08-24 11:52:30,096 [myid:] - INFO  [main:ZooKeeperServer@755] - tickTime set to 2000
2014-08-24 11:52:30,096 [myid:] - INFO  [main:ZooKeeperServer@764] - minSessionTimeout set to -1
2014-08-24 11:52:30,096 [myid:] - INFO  [main:ZooKeeperServer@773] - maxSessionTimeout set to -1
2014-08-24 11:52:30,114 [myid:] - INFO  [main:NIOServerCnxnFactory@94] - binding to port 0.0.0.0/0.0.0.0:2181
```

> 参考: https://github.com/jplock/docker-zookeeper

###2 ZK Cluster
