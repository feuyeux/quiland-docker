搭建MongoDB服务器
----
>http://docs.mongodb.org/manual/tutorial/install-mongodb-on-linux/
https://github.com/dockerfile/mongodb

###1 Docker-Ubuntu-Nginx
>工作目录：/home/erichan/docker-room/ubuntu-mongodb

###2 制作镜像
```
[erichan@mars-centos7 ubuntu-nginx]$ nano Dockerfile
# Version: 0.0.1
FROM feuyeux/ubuntu-base
MAINTAINER Eric Han "feuyeux@gmail.com"
RUN apt-get -yq install wget
RUN wget http://downloads.mongodb.org/linux/mongodb-linux-x86_64-2.6.4.tgz
RUN tar -zxvf mongodb-linux-x86_64-2.6.4.tgz -C /opt
RUN export PATH=/opt/mongodb-linux-x86_64-2.6.4/bin:$PATH
RUN echo $PATH
VOLUME ["/data/db"]
WORKDIR /data
ENTRYPOINT ["/opt/mongodb-linux-x86_64-2.6.4/bin/mongod"]
EXPOSE 27017
EXPOSE 28017
```
###3 构建镜像
```
erichan@ubuntu14_04_1-pd:~/docker-room/ubuntu-mongodb$ d build -t="feuyeux/mongodb" .
```

###4 验证镜像
```
d run -d -p 27017:27017 --name mongodb feuyeux/mongodb
```
