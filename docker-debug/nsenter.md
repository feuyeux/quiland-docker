使用nsenter调试Docker镜像
---

###获得nsenter
####如果已经存在镜像压缩包 先解压再运行
```
erichan@ubuntu14_04_1-pd:~/docker-tars$ d load -i nsenter.tar
erichan@ubuntu14_04_1-pd:~/docker-tars$ d run -v /usr/local/bin:/target jpetazzo/nsenter
```

####如果本地没有 直接运行docker命令 从云端下载
```
erichan@ubuntu14_04_1-pd:~/docker-tars$ d run -v /usr/local/bin:/target jpetazzo/nsenter
Installing nsenter to /target
Installing docker-enter to /target
```

###调试

#### 获得已经运行的容器进程号
```
erichan@ubuntu14_04_1-pd:~/docker-tars$ PID=$(d inspect --format {{.State.Pid}} sinopia)
```
>sinopia 是运行中的容器进程的别名

#### 使用nsenter进入该名字空间
```
erichan@ubuntu14_04_1-pd:~/docker-tars$ sudo nsenter --target $PID --mount --uts --ipc --net --pid
```

#### 进入已经运行的容器中 调试环境已经搭好
```
root@5b03fb519385:/# ls /opt/sinopia/
config.yaml  config_gen.js  start.sh  storage
root@5b03fb519385:/# cat /opt/sinopia/config.yaml | grep allow
# Maximum amount of users allowed to register, defaults to "+inf".
  #  allow_access: admin
  #  allow_publish: all
    # allow all users to read packages ('all' is a keyword)
    allow_access: all
    # allow 'admin' to publish packages
    allow_publish: all
root@5b03fb519385:/# cat /opt/sinopia/config.yaml | grep listen
# you can specify listen address (or simply a port)
listen: 0.0.0.0:4873
```