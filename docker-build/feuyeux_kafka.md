搭建Kafka服务器
----

### 1 Docker-Ubuntu-Kafka
>工作目录：/home/erichan/docker-room/ubuntu-kafka

#### 1.1 制作镜像
```
erichan@ubuntu14_04_1-pd:~/docker-room/ubuntu-zookeeper$ nano Dockerfile
```

```
# Version: 0.0.1
FROM feuyeux/ubuntu-java7
MAINTAINER Eric Han "feuyeux@gmail.com"
RUN apt-get update && apt-get install -y wget unzip git
RUN wget -q http://apache.fayea.com/apache-mirror/kafka/0.8.1.1/kafka_2.10-0.8.1.1.tgz
RUN tar -xzf kafka_2.10-0.8.1.1.tgz -C /opt
ENV KAFKA_HOME /opt/kafka_2.10-0.8.1.1
ADD start-kafka.sh /usr/bin/start-kafka.sh
RUN chmod 777 /usr/bin/start-kafka.sh
CMD start-kafka.sh
```

#####start-kafka.sh

```
sed -r -i "s/(zookeeper.connect)=(.*)/\1=$ZK_PORT_2181_TCP_ADDR/g" $KAFKA_HOME/config/server.properties
sed -r -i "s/(broker.id)=(.*)/\1=$BROKER_ID/g" $KAFKA_HOME/config/server.properties
sed -r -i "s/#(advertised.host.name)=(.*)/\1=$HOST_IP/g" $KAFKA_HOME/config/server.properties
sed -r -i "s/^(port)=(.*)/\1=$PORT/g" $KAFKA_HOME/config/server.properties
if [ "$KAFKA_HEAP_OPTS" != "" ]; then
    sed -r -i "s/^(export KAFKA_HEAP_OPTS)=\"(.*)\"/\1=\"$KAFKA_HEAP_OPTS\"/g" $KAFKA_HOME/bin/kafka-server-start.sh
fi
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
```

#####start-broker.sh
```
#!/bin/bash
ZOOKEEPER=`sudo docker ps -a | awk '{print $NF}'  | grep "zk346$"`
ZOOKEEPER_RUNNING=$?
if [ $ZOOKEEPER_RUNNING -eq 0 ] ;
then
    echo "ZooKeeper is already running"
else
    echo "Starting Zookeeper"
    sudo docker run -p 49181:2181 -h zookeeper --name zk346 -d feuyeux/zookeeper:3.4.6
fi
ID=$1
PORT=$2
HOST_IP=$3
echo "BROCKER-ID=$ID KAFKA=$HOST_IP:$PORT"
sudo docker run -p $PORT:$PORT --name kafka081_$4 --link zk346:zk -e BROKER_ID=$ID -e HOST_IP=$HOST_IP -e PORT=$PORT -d feuyeux/kafka:0.8.1
```

```
erichan@ubuntu14_04_1-pd:~/docker-room/ubuntu-kafka$ chmod +x start-broker.sh
```

#### 1.2 创建镜像
```
erichan@ubuntu14_04_1-pd:~/docker-room/ubuntu-kafka$ d build -t feuyeux/kafka:0.8.1 .
```

#### 1.3 测试镜像
```
d kill $(d ps -q) && d rm $(d ps -a -q)
cd ~/docker-room/ubuntu-kafka
./start-broker.sh 101 9093 10.16.41.135 1
./start-broker.sh 102 9094 10.16.41.135 2
```
>脚本自动执行：d run -p 49181:2181 -h zookeeper --name zk346 -d feuyeux/zookeeper:3.4.6

```
d ps -a
CONTAINER ID        IMAGE                     COMMAND                CREATED             STATUS              PORTS                                                 NAMES
78a84862a311        feuyeux/kafka:0.8.1       "/bin/sh -c start-ka   3 seconds ago       Up 3 seconds        22/tcp, 0.0.0.0:9094->9094/tcp                        kafka081_2                          
951ff2d3296a        feuyeux/kafka:0.8.1       "/bin/sh -c start-ka   12 seconds ago      Up 11 seconds       22/tcp, 0.0.0.0:9093->9093/tcp                        kafka081_1                          
efbd8d713866        feuyeux/zookeeper:3.4.6   "/opt/zookeeper-3.4.   12 seconds ago      Up 12 seconds       2888/tcp, 3888/tcp, 22/tcp, 0.0.0.0:49181->2181/tcp   kafka081_1/zk,kafka081_2/zk,zk346   
erichan@ubuntu14_04_1-pd:~/docker-room/ubuntu-kafka$ 
```

####参考
> * [https://github.com/wurstmeister/kafka-docker](https://github.com/wurstmeister/kafka-docker)
> * [https://github.com/apache/kafka/tree/0.8.1/examples/src/main/java/kafka/examples](https://github.com/apache/kafka/tree/0.8.1/examples/src/main/java/kafka/examples)