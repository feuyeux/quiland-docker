搭建NodeJS服务器
----------------

###0 node应用·盗梦空间 ![](img/2014-08-17_02.25.00.png)

###1 Docker-Ubuntu-NodeJs > 工作目录：/home/erichan/docker-room/ubuntu-node

###2 制作镜像**[erichan@mars-centos7 ubuntu-node]$ nano Dockerfile**

```
# Version: 0.0.1
FROM feuyeux/ubuntu-base
MAINTAINER Eric Han "feuyeux@gmail.com"
RUN apt-get -yq install nodejs
RUN apt-get -yq install npm
COPY index.js ./index.js
COPY package.json ./package.json
RUN npm install
EXPOSE 8080
CMD ["nodejs","./index.js"]
```

###3 nodejs工程**[erichan@mars-centos7 ubuntu-node]$ nano package.json**

```
{
  "name": "ubuntu-node",
  "private": true,
  "version": "0.0.5",
  "description": "pi arcas app on ubuntu using docker",
  "author": {
    "name":"Eric Han",
    "email":"feuyeux@gmail.com"
  },
  "dependencies": {
      "tracer": "0.7.1"
    },
    "devDependencies": {
        "mocha": "1.21.3",
        "should": "4.0.4",
        "expect": "0.1.1",
        "nodeunit": "0.9.0",
        "date-format-lite": "0.5.0",
        "express":"4.8.4"
    }
}
```

**[erichan@mars-centos7 ubuntu-node]$ nano index.js**

```
var express = require('express');
var config = {
  root: "/tmp",
  format: "{{timestamp}} {{message}}",
  dateformat: "yyyy-mm-dd HH:MM:ss.L"
};

var log = require('tracer').dailyfile(config);
var PORT = 8080;

var app = express();
app.get('/', function (req, res) {
  log.info(req);
  res.send("Qui, c'est la pi-arcas!\n");
});
app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
```

###4 创建镜像

```
d build -t feuyeux/ubuntu-node .
```

###5 验证镜像

```
d images
```

| REPOSITORY          | TAG    | IMAGE ID     | CREATED       |
|:--------------------|:-------|:-------------|:--------------|
| feuyeux/ubuntu-node | latest | 7eb4cbfcf2e0 | 5 minutes ago |
| feuyeux/nginx       | 1.0    | 7f1df0dc6e46 | 5 hours ago   |
| feuyeux/ubuntu-base | latest | 30fe631d9934 | 5 hours ago   |
| ubuntu              | 14.04  | c4ff7513909d | 4 days ago    |

###6 运行node

```
[erichan@mars-centos7 ubuntu-node]$ d run -p 49160:8080 -d feuyeux/ubuntu-node
```

###7 验证NodeJs**查询进程**

```
[erichan@mars-centos7 ubuntu-node]$ d ps -l
CONTAINER ID        IMAGE                        COMMAND             CREATED             STATUS              PORTS                             NAMES
658829faa174        feuyeux/ubuntu-node:latest   nodejs ./index.js   4 seconds ago       Up 4 seconds        22/tcp, 0.0.0.0:49160->8080/tcp   focused_davinci
```

**cURL测试**

```
[erichan@mars-centos7 ubuntu-node]$ curl -i localhost:49160
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 24
ETag: W/"18-1035073832"
Date: Sat, 16 Aug 2014 18:06:11 GMT
Connection: keep-alive

Qui, c'est la pi-arcas!
```

![](img/2014-08-17_02.30.40.png)

[返回主页面](/README.md)
