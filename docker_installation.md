Docker第一步
---
###安装Docker

Docker支持很多种宿主操作系统（详见[installation](https://docs.docker.com/installation/
)）。

####CentOS安装简述

Docker使用EPEL发布，RHEL系的OS首先要确保已经持有EPEL仓库，否则先检查OS的版本，然后安装相应的EPEL包。

**6.5 yum安装**

```
[erichan@localhost ~]$ cat /etc/redhat-release
CentOS release 6.5 (Final)

[erichan@localhost ~]$ sudo rpm -iUvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
[erichan@localhost ~]$ sudo yum update -y
```

yum是RHEL系横扫一切rpm安装的神器，6.5使用yum安装docker。

```
[erichan@localhost ~]$ sudo yum -y install docker-io
[erichan@localhost ~]$ docker version
Client version: 1.0.0
Client API version: 1.12
Go version (client): go1.2.2
Git commit (client): 63fe64c/1.0.0
```

**7.0 bin安装**

https://get.docker.io/builds/

```
# To install, run the following command as root:
curl -O https://get.docker.io/builds/Linux/x86_64/docker-1.1.2 && chmod +x docker-1.1.2 && sudo mv docker-1.1.2 /usr/local/bin/docker
# Then start docker in daemon mode:
sudo /usr/local/bin/docker -d
```

####ubuntu安装简述

**14.04.1**

[官方](https://docs.docker.com/installation/ubuntulinux/)

```
```

###Docker第一步
安装好Docker后，首先要启动docker服务，然后就可以使用docker命令啦。

####info命令
```
[erichan@localhost ~]$ sudo service docker start
[erichan@localhost ~]$ sudo docker info

Containers: 0
Images: 0
Storage Driver: devicemapper
 Pool Name: docker-253:0-921479-pool
 Data file: /var/lib/docker/devicemapper/devicemapper/data
 Metadata file: /var/lib/docker/devicemapper/devicemapper/metadata
 Data Space Used: 291.5 Mb
 Data Space Total: 102400.0 Mb
 Metadata Space Used: 0.7 Mb
 Metadata Space Total: 2048.0 Mb
Execution Driver: native-0.2
Kernel Version: 2.6.32-431.20.3.el6.x86_64
```

####第一个完整流程
```
[erichan@localhost ~]$ sudo docker search fedora
NAME                                DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
fedora                              (Semi) Official Fedora base image.              59                   
……

[erichan@localhost ~]$ sudo docker pull fedora
Pulling repository fedora
64fd7993bcaf: Download complete
3f2fed40e4b0: Download complete
511136ea3c5a: Download complete
fd241224e9cf: Download complete

[erichan@localhost ~]$ sudo docker run -i -t fedora /bin/bash
2014/07/11 05:22:51 unable to remount sys readonly: unable to mount sys as readonly max retries reached
[erichan@localhost ~]$ sudo vim /etc/sysconfig/docker
other_args="--exec-driver=lxc”

[erichan@localhost ~]$ sudo service docker stop
Stopping docker:                                           [  OK  ]
[erichan@localhost ~]$ sudo service docker start
Starting docker:                                        [  OK  ]
[erichan@localhost ~]$ sudo docker run -i -t fedora /bin/bash
bash-4.2# exit
exit
```

####运行长期执行的命令
```
[erichan@localhost ~]$ job=$(sudo docker run -d fedora /bin/bash -c "while true; do echo Hello world; sleep 1; done")
[erichan@localhost ~]$ sudo docker logs $job
Hello world
Hello world
Hello world
```

job这个进程是个无休止的进程，通过docker logs可以查看该进程的输出。

```
[erichan@localhost ~]$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS               NAMES
460e436df5de        fedora:20           /bin/bash -c 'while    27 seconds ago      Up 27 seconds                           pensive_hoover     
[erichan@localhost ~]$ echo $job
460e436df5de494d3afb73e81fe1a362cd64f4810319937894b1f3f870de4f7d
```

可以看到，活着的这个进程的ID就是job。

```
[erichan@localhost ~]$ sudo docker kill $job
460e436df5de494d3afb73e81fe1a362cd64f4810319937894b1f3f870de4f7d
[erichan@localhost ~]$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

杀掉该进程，docker中没有活的进程啦。

[返回主页面](/README.md)