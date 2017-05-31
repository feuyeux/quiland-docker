# Elasticsearch with Docker Swarm and Compose v3

docker docker-machine swarm docker-compose elasticsearch

---
## 1. Docker
Ubuntu 16.04.1 LTS(Xenial)
4.4.0-47-generic
> https://docs.docker.com/engine/installation/linux/ubuntulinux/
```sh
sudo apt-get update

sudo apt-get install apt-transport-https ca-certificates

sudo apt-key adv \
--keyserver hkp://ha.pool.sks-keyservers.net:80 \
--recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update

apt-cache policy docker-engine

sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual

sudo apt-get install docker-engine

sudo service docker start

sudo usermod -aG docker $USER

docker version
Client:
 Version:      1.12.3
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   6b644ec
 Built:        Wed Oct 26 22:01:48 2016
 OS/Arch:      linux/amd64

Server:
 Version:      1.12.3
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   6b644ec
 Built:        Wed Oct 26 22:01:48 2016
 OS/Arch:      linux/amd64

curl -L https://github.com/docker/compose/releases/download/1.8.1/run.sh > docker-compose

sudo mv docker-compose /usr/local/bin/ && sudo chmod +x 

docker-compose version
docker-compose version 1.8.1, build 878cff1
docker-py version: 1.10.3
CPython version: 2.7.12

docker run swarm --help
```
## 2. Swarm Cluster
| IP            | NAME          | ROLE          |
| :------------ | :------------ | ------------- |
| 192.168.3.107 | ubuntu-swarm1 | Swarm Manager |
| 192.168.3.104 | ubuntu-swarm2 | Swarm Worker  |
| 192.168.3.105 | ubuntu-swarm3 | Swarm Worker  |

TCP port 2377 for cluster management communications
TCP and UDP port 7946 for communication among nodes
TCP and UDP port 4789 for overlay network traffic

> https://docs.docker.com/swarm/install-manual/
> https://docs.docker.com/engine/swarm/swarm-tutorial/

```
docker rm $(docker ps -qa)
```

### 2.1. Discovery backend & Swarm Manager
```sh
docker swarm init --advertise-addr 192.168.3.107
```

### 2.2. Swarm Worker
```sh
docker swarm join \
--token SWMTKN-1-12ft8kzw3n1zp2mazxvbqptq2c4dr0355vox1mry4ptkf1lgor-ajq2uag8j0afi46n2pegjeu0u \
192.168.3.107:2377
```

### 2.3. Swarm Nodes
```sh
docker node ls
ID                           HOSTNAME       STATUS  AVAILABILITY  MANAGER STATUS
0a6v4cpglca2lxjo4zgw8lsmt    ubuntu-swarm3  Ready   Active        
3f67z2qhi1ubq9wmkxtdntszn *  ubuntu-swarm1  Ready   Active        Leader
7v6w7eiw9i6fle2i3gf20mzhv    ubuntu-swarm2  Ready   Active
```

## 2'. Swarm Cluster in docker-machine

```sh
#docker-machine rm -f swarm-1 swarm-2 swarm-3
# 1 create new machines
for i in 1 2 3; do
  docker-machine create -d virtualbox swarm-$i
done

# 2 create swarm cluster
eval $(docker-machine env swarm-1)
docker swarm init --advertise-addr $(docker-machine ip swarm-1)
TOKEN=$(docker swarm join-token -q manager)

for i in 2 3; do
  eval $(docker-machine env swarm-$i)
  docker swarm join --token $TOKEN --advertise-addr $(docker-machine ip swarm-$i) $(docker-machine ip swarm-1):2377
done
```



```sh
eval $(docker-machine env swarm-1)
docker node ls
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
dpr7ytsabg2p7ssx9iv6umj6i    swarm-3   Ready   Active        Reachable
sk2qkmdbpqrk2tqi0hsvuwzsp *  swarm-1   Ready   Active        Leader
tbxving6s2bq5csszzwyisc1r    swarm-2   Ready   Active        Reachable
```

## 3. Elasticsearch Compose v3

### 3.1 Dockerfile

es.base.dockerfile

```dockerfile
FROM alpine:latest
MAINTAINER Eric Han <feuyeux.gmail.com>
RUN apk update && \
    apk upgrade && \
    apk add bash openjdk8 openssl linux-pam nodejs curl && \
    rm -rf /var/cache/apk/*
```

```dockerfile
FROM feuyeux/java8-nodejs7-alpine
MAINTAINER Eric Han <feuyeux.gmail.com>

ENV STACK_VERSION=5.2.2 PLUGIN_VERSION=5.2.2 HOME=/home/admin
ENV ES_HOME=${HOME}/elasticsearch-${STACK_VERSION} KIBANA_HOME=${HOME}/kibana-${STACK_VERSION}-linux-x86_64 ES_TAR=elasticsearch-${STACK_VERSION}.tar.gz KB_TAR=kibana-${STACK_VERSION}-linux-x86_64.tar.gz REFRESHED_AT=2017-03-23

RUN adduser -D -h /bin/sh admin
WORKDIR ${HOME}

## install es and kb
COPY okie_dokie/${ES_TAR} okie_dokie/${KB_TAR} okie_dokie/es_plugins/*.zip ${HOME}/
RUN tar -zxf ${ES_TAR} && tar -zxf ${KB_TAR} &&  \
## install es plugin
    mkdir -p ${ES_HOME}/plugins/ik/ && mkdir -p ${ES_HOME}/plugins/pinyin && \
    unzip -q elasticsearch-analysis-ik-${PLUGIN_VERSION}.zip -d ${ES_HOME}/plugins/ik/ && \
    unzip -q elasticsearch-analysis-pinyin-${PLUGIN_VERSION}.zip -d ${ES_HOME}/plugins/pinyin/ && \
## replace kb node
    rm -f ${KIBANA_HOME}/node/bin/node ${KIBANA_HOME}/node/bin/npm && \
    ln -s $(which node) ${KIBANA_HOME}/node/bin/node && ln -s $(which npm) ${KIBANA_HOME}/node/bin/npm && \
## install es xpack plugin
    ${ES_HOME}/bin/elasticsearch-plugin install file://${HOME}/x-pack-${STACK_VERSION}.zip && \
## install es xpack plugin
    ${KIBANA_HOME}/bin/kibana-plugin install file://${HOME}/x-pack-${STACK_VERSION}.zip && \
## clean
    rm -rf ${ES_TAR} && rm -rf ${KB_TAR} && rm -rf *.zip

COPY boostrap/*.sh ${HOME}/

## privilege
RUN mkdir /config /data && chown -R admin:admin /config /data ${HOME} && chmod +x ${HOME}/*.sh

USER admin
VOLUME ["/config","/data"]
CMD sh /home/admin/start.sh
EXPOSE 9200 9300 5601
```

### 3.2 boostrap

replace.sh

```sh
#!/bin/bash
ES_CONF=/config/elasticsearch.yml
KB_CONF=/config/kibana.yml

if [ ! -n "${NODE_NAME}" ]; then
  echo "ERROR: NODE_NAME, NODE_IP, CLUSTER_IPS cannot be null"
else
  #echo -e "NODE_NAME=${NODE_NAME}\nNODE_IP=${NODE_IP}\nCLUSTER_IPS=${CLUSTER_IPS}"
  sed -r -i "s/CLUSTER_NAME/${CLUSTER_NAME}/g" ${ES_CONF}
  sed -r -i "s/NODE_NAME/${NODE_NAME}/g" ${ES_CONF}
  sed -r -i "s/NODE_IP/${NODE_IP}/g" ${ES_CONF}
  sed -r -i "s/CLUSTER_IPS/${CLUSTER_IPS}/g" ${ES_CONF}
  sed -r -i "s/ZEN_NUM/${ZEN_NUM}/g" ${ES_CONF}
  sed -r -i "s/NODE_IP/${NODE_IP}/g" ${KB_CONF}
  sed -r -i "s/NODE_NAME/${NODE_NAME}/g" ${KB_CONF}
fi
echo
```

start.sh

```sh
#!/bin/bash
if [ ! -n "${NODE_NAME}" ]; then
	echo "ERROR: NODE_NAME, NODE_IP, CLUSTER_IPS cannot be null"
else
  sh ${HOME}/replace.sh 
  export ES_JAVA_OPTS="-Xms${MEM} -Xmx${MEM}"
  sh ${ES_HOME}/bin/elasticsearch -Epath.conf=/config --silent & \
  ${KIBANA_HOME}/bin/kibana --config /config/kibana.yml --silent
fi

ulimit -a
```

### 3.3 config

elasticsearch.yml

```yaml
cluster:
  name: CLUSTER_NAME
  routing.allocation.cluster_concurrent_rebalance: 2

path:
  data: /data
  logs: /home/admin/logs  

node:
  name: NODE_NAME
network:
  host: NODE_IP

discovery:
  zen: 
    ping.unicast.hosts: [CLUSTER_IPS]
    minimum_master_nodes: ZEN_NUM

indices: 
  requests.cache.size: 2%
  memory:
    index_buffer_size: 20%
    min_index_buffer_size: 512mb

thread_pool:
  index:
    size: 5
    queue_size: 1000
  bulk:
    queue_size: 3000

index:
  store.type: niofs

#bootstrap.memory_lock: true

xpack:
  monitoring.enabled: true
  watcher.enabled: false
  security.enabled: false
  graph.enabled: false
```

kibana.yml

```yaml
server.host: NODE_IP
server.name: NODE_NAME
elasticsearch.url: http://NODE_IP:9200
kibana.index: .kibana
xpack.monitoring.enabled: true
xpack.watcher.enabled: false
xpack.security.enabled: false
xpack.graph.enabled: false
xpack.reporting.enabled: false
```

### 3.4 compose

docker-compose.yml

```yaml
version: "3"

services:
  es1:
    image: feuyeux/elasticsearch5-alpine
    environment:
      ES_JAVA_OPTS: "-Xmx256m -Xms256m"
      MEM: 1g
      ZEN_NUM: 2
      NODE_NAME: es1
      CLUSTER_NAME: NLS-ES
      NODE_IP: es1
      CLUSTER_IPS: es1,es2,es3
    networks:
      - esnet  
  es2:
    image: feuyeux/elasticsearch5-alpine
    environment:
      ES_JAVA_OPTS: "-Xmx256m -Xms256m"
      MEM: 1g
      ZEN_NUM: 2
      NODE_NAME: es2
      CLUSTER_NAME: NLS-ES
      NODE_IP: es2
      CLUSTER_IPS: es1,es2,es3
    networks:
      - esnet
  es3:
    image: feuyeux/elasticsearch5-alpine
    environment:
      ES_JAVA_OPTS: "-Xmx256m -Xms256m"
      MEM: 1g
      ZEN_NUM: 2
      NODE_NAME: es3
      CLUSTER_NAME: NLS-ES
      NODE_IP: es3
      CLUSTER_IPS: es1,es2,es3
    networks:
      - esnet
    
networks:
  esnet:
    external: true
```

```sh

for i in 1 2 3; do
  mkdir /tmp/es_config$i/
  mkdir /tmp/es_data$i/
  cp -r ../config/* /tmp/es_config$i/
done
docker network create --driver overlay esnet
docker stack deploy -c es-compose.yml nls-es
```