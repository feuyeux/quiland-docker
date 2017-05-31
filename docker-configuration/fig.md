使用fig启动容器
---------------

fig的使用非常简单，只需要配置`fig.yml`并在同目录下执行`fig up -d`即可启动容器。

配置`fig.yml`：
---------------

```
node:
  image: feuyeux/ubuntu-node
  ports:
    - "8080:8080"
  links:
    - redis:node-redis
  mem_limit: 2g
  hostname: fig-node

redis:
  image: feuyeux/redis
  hostname: fig-redis
```

配置中的两个镜像的创建，请参考本系列前面的文章：

-	[[Docker系列·10] 搭建Redis服务器](http://www.atatech.org/articles/21551)
-	[[Docker系列·3] 搭建基于Docker的NodeJS服务器](http://www.atatech.org/articles/20875)

启动容器
--------

```
lu.hl@localhost:/opt/docker-room/fig-001$ fig up -d
Creating fig001_redis_1...
Creating fig001_node_1...
```

检测容器
--------

可以使用fig自己的命令检测：

```
lu.hl@localhost:/opt/docker-room/fig-001$ fig ps
     Name                   Command               State               Ports
----------------------------------------------------------------------------------------
fig001_node_1    nodejs ./index.js                Up      22/tcp, 0.0.0.0:8080->8080/tcp
fig001_redis_1   redis-server /etc/redis/re ...   Up      22/tcp, 6379/tcp
```

也可以使用docker命令检测：

```
lu.hl@localhost:/opt/docker-room/fig-001$ d ps
CONTAINER ID        IMAGE                        COMMAND                CREATED             STATUS              PORTS                            NAMES
c7f112d912b8        feuyeux/ubuntu-node:latest   "nodejs ./index.js"    28 minutes ago      Up 28 minutes       22/tcp, 0.0.0.0:8080->8080/tcp   fig001_node_1
394c9648c33a        feuyeux/redis:latest         "redis-server /etc/r   28 minutes ago      Up 28 minutes       22/tcp, 6379/tcp                 fig001_node_1/fig001_redis_1,fig001_node_1/node-redis,fig001_node_1/redis_1,fig001_redis_1
```

坑
--

虽然使用fig简单，但小白还是有写坑要踩。这里列举如下。

### 1.DOCKER_HOST

当系统没有指定DOCKER_HOST参数时，执行fig命令会遇到如下错误。

```
Couldn't connect to Docker daemon at http+unix://var/run/docker.sock - is it running?

If it's at a non-standard location, specify the URL with the DOCKER_HOST environment variable.
```

解决的办法是`export`该参数到当前终端或`.bashrc`：

```
export DOCKER_HOST=tcp://localhost:4243
fig ps
```

### 2.DOCKER_OPTS

Ubuntu默认安装的docker没有启动tcp监听，因此这个约定俗成的端口4243也是要设置的。 可以在启动docker时加参数，但如果是执行`sudo service docker start`的话，还是要设置一下DOCKER_OPTS：

配置`/etc/default/docker`：

```
DOCKER_OPTS="-api-enable-cors=true -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock --dns 8.8.8.8 --dns 8.8.4.4"
```

-	-api-enable-cors：这个参数的意义是允许ajax跨域资源共享。
-	tcp://0.0.0.0:4243：这个参数的意义是让docker监听所有4243端口的tcp请求（当然http是基于tcp之上的，remote api也是走这个端口） -

其他启动相关的配置参见：`/etc/init/docker.conf`

### 3.cgroup_enable

Ubuntu默认是不允许使用cgroup做内存等资源的调配的，如果你在docker的配置文件`Dockerfile`或者fig的配置文件`fig.yml`中设置了容器的启动内存，会遇到如下警告：

```
WARNING: Your kernel does not support cgroup swap limit. WARNING: Your kernel does not support swap limit capabilities. Limitation discarded.
```

解决的办法是设置grub参数：

配置`/etc/default/grub`：

```
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
```

然后执行`sudo update-grub`，重启系统生效。

坑还不止于此，这是我踩过的。关于docker和fig的砖今天先抛到这里。
