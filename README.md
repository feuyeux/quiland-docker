基于Docker的统一自动化测试环境
==============================

> Automating Test Unified Environment Using Docker<br/>begin from 2014-08-18

##服务端

### 镜像列表

#### [Docker-Ubuntu14.04 基础镜像](docker-images/feuyeux_base.md)

#### [搭建Nginx服务器](docker-images/feuyeux_nginx.md)

#### [搭建NodeJS服务器](docker-images/feuyeux_nodejs.md)

#### [搭建Tomcat服务器](docker-images/feuyeux_tomcat.md)

#### [搭建NPM代理服务器](docker-images/feuyeux_sinopia.md)

#### [搭建ZooKeeper服务器](docker-images/feuyeux_zookeeper.md)

#### [搭建Kafka服务器](docker-images/feuyeux_kafka.md)

#### [搭建Redis服务器](docker-images/feuyeux_redis.md)

### Docker调试

#### [使用nsenter调试Docker镜像](docker-debug/nsenter.md)

### Docker管理

#### [复制Docker镜像](docker-manage/images_save_load.md)

### Docker配置

#### [使用fig启动容器](docker-configuration/fig.md)

#### [Docker Daemon安全手记](docker-configuration/https.md)

### Docker私服

#### [Docker私服搭建手记](docker-registry/Docker私服搭建手记.md)

### Docker监控

#### [Docker内存限制手记](docker-cgroup/Docker内存限制手记.md)

### 环境

-	主机操作系统：Mac OS X 10.9 Mavericks
-	Docker宿主机操作系统：centos7 | ubuntu14.04.1 LTS
-	Docker虚拟机操作系统：ubuntu14.04(Trusty) LTS

#### Shortcut**~/.bashrc**

```
alias d="sudo /usr/local/bin/docker"
alias dc="sudo /usr/bin/docker -d -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock >> /dev/null 2>&1 &"
```

### Docker101

#### [Docker第一课](docker101.md)

#### [Docker第一步](docker_installation.md)

客户端
------

### 1 图形工具

#### [dockerui](docker-ui/dockerui.md)

### 2 API

#### [Docker远程接口](docker-remote/remote_api.md)

### 3 图形客户端的实现

#### [a-docker](docker-ui/a-docker/README.md)
