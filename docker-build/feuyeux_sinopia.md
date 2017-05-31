##Sinopia Docker
>https://github.com/keyvanfatehi/docker-sinopia

####制作镜像
Dockerfile

```
# Version: 0.0.1
FROM feuyeux/ubuntu-node
MAINTAINER Eric Han "feuyeux@gmail.com"
RUN apt-get -yq install make build-essential python python-dev
RUN npm install js-yaml sinopia@0.9.1 
RUN adduser --disabled-password --gecos "" sinopia
RUN mkdir -p /opt/sinopia/storage
RUN chown -R sinopia:sinopia /opt/sinopia
USER sinopia
WORKDIR /opt/sinopia
ADD /config_gen.js /opt/sinopia/config_gen.js
ADD /start.sh /opt/sinopia/start.sh
CMD ["/opt/sinopia/start.sh"]
EXPOSE 4873
```

config_gen.js

```
#!/usr/bin/env nodejs
var config = require('sinopia/lib/config_gen')()
  , yaml = require('js-yaml')
  , fs = require('fs')
console.log('Username: %s', config.user)
console.log('Password: %s', config.pass)
fs.writeFileSync('/tmp/config.yaml', config.yaml)
```

start.sh

```
#!/bin/bash
nodejs /opt/sinopia/config_gen.js
cat /tmp/config.yaml
sed -e 's/\#listen\: localhost/listen\: 0.0.0.0/' -e 's/allow_publish\: admin/allow_publish\: all/' /tmp/config.yaml > /opt/sinopia/config.yaml
nodejs /node_modules/sinopia/bin/sinopia --config /opt/sinopia/config.yaml
```

####构建镜像
```
[erichan@mars-centos7 ubuntu-sinopia]$ d build -t feuyeux/ubuntu-sinopia .
Sending build context to Docker daemon  5.12 kB
Sending build context to Docker daemon 
Step 0 : FROM feuyeux/ubuntu-node
 ---> 7eb4cbfcf2e0
Step 1 : MAINTAINER Eric Han "feuyeux@gmail.com"
 ---> Using cache
 ---> bd62d7c3611c
Step 2 : RUN apt-get -yq install make build-essential python python-dev
 ---> Using cache
 ---> c960e53c1b40
Step 3 : RUN npm install js-yaml sinopia@0.9.1
 ---> Running in eed56456ae0e
npm http GET https://registry.npmjs.org/sinopia/0.9.1
npm http GET https://registry.npmjs.org/js-yaml
……
npm WARN prefer global sinopia@0.9.1 should be installed with -g
js-yaml@3.1.0 node_modules/js-yaml
├── esprima@1.0.4
└── argparse@0.1.15 (underscore@1.4.4, underscore.string@2.3.3)

sinopia@0.9.1 node_modules/sinopia
├── commander@2.3.0
├── async@0.9.0
├── semver@3.0.1
├── minimatch@1.0.0 (sigmund@1.0.0, lru-cache@2.5.0)
├── mkdirp@0.5.0 (minimist@0.0.8)
├── fs-ext@0.3.2
├── crypt3@0.1.5
├── cookies@0.5.0 (keygrip@1.0.1)
├── bunyan@1.0.0 (mv@2.0.3)
├── request@2.40.0 (json-stringify-safe@5.0.0, forever-agent@0.5.2, aws-sign2@0.5.0, oauth-sign@0.3.0, stringstream@0.0.4, tunnel-agent@0.4.0, qs@1.0.2, node-uuid@1.4.1, mime-types@1.0.2, tough-cookie@0.12.1, http-signature@0.10.0, form-data@0.1.4, hawk@1.1.1)
└── express@3.16.7 (basic-auth@1.0.0, merge-descriptors@0.0.2, cookie@0.1.2, escape-html@1.0.1, cookie-signature@1.0.4, fresh@0.2.2, range-parser@1.0.0, vary@0.1.0, media-typer@0.2.0, methods@1.1.0, parseurl@1.3.0, buffer-crc32@0.2.3, depd@0.4.4, proxy-addr@1.0.1, debug@1.0.4, commander@1.3.2, send@0.8.3, connect@2.25.7)
 ---> 78689f6f2b39
Removing intermediate container eed56456ae0e
Step 4 : RUN adduser --disabled-password --gecos "" sinopia
 ---> Running in 69e7239b6807
Adding user `sinopia' ...
Adding new group `sinopia' (1000) ...
Adding new user `sinopia' (1000) with group `sinopia' ...
Creating home directory `/home/sinopia' ...
Copying files from `/etc/skel' ...
 ---> 8db99c03a2ca
Removing intermediate container 69e7239b6807
Step 5 : RUN mkdir -p /opt/sinopia/storage
 ---> Running in c8df4c2dbb0b
 ---> 7dadbc492b3c
Removing intermediate container c8df4c2dbb0b
Step 6 : RUN chown -R sinopia:sinopia /opt/sinopia
 ---> Running in 227825ca7561
 ---> fec3907ca6c9
Removing intermediate container 227825ca7561
Step 7 : USER sinopia
 ---> Running in 1ed1ea8aff6e
 ---> e9edc497b77e
Removing intermediate container 1ed1ea8aff6e
Step 8 : WORKDIR /opt/sinopia
 ---> Running in daa0f3ac4383
 ---> 0b7bda3426ed
Removing intermediate container daa0f3ac4383
Step 9 : ADD /config_gen.js /opt/sinopia/config_gen.js
 ---> 25770258cbb3
Removing intermediate container 3a502127d038
Step 10 : ADD /start.sh /opt/sinopia/start.sh
 ---> 678434935c80
Removing intermediate container ddfc6aa3dceb
Step 11 : CMD ["/opt/sinopia/start.sh"]
 ---> Running in e3117e312f4c
 ---> 2acff7da72cc
Removing intermediate container e3117e312f4c
Step 12 : EXPOSE 4873
 ---> Running in a458160612cf
 ---> a1b8e9c0366f
Removing intermediate container a458160612cf
Successfully built a1b8e9c0366f
[erichan@mars-centos7 ubuntu-sinopia]$ 
```

####运行sinopia
```
d run --name sinopia -d -p 4873:4873 -v /home/erichan/docker-room/ubuntu-sinopia/storage:/opt/sinopia/storage feuyeux/ubuntu-sinopia
```

####测试sinopia
```
[erichan@mars-centos7 ubuntu-sinopia]$ d logs sinopia

[erichan@mars-centos7 ubuntu-sinopia]$ curl -i http://localhost:4873
HTTP/1.1 404 Not Found
X-Powered-By: Sinopia/0.9.1
Content-Type: text/html; charset=utf-8
Content-Length: 13
Vary: Accept-Encoding
X-Status-Cat: http://flic.kr/p/aV6juR
Date: Wed, 20 Aug 2014 14:28:21 GMT
Connection: keep-alive

Cannot GET /
```


##Sinopia Client
```
[erichan@Eric-Mavericks ~]$ nano .bash_profile
alias dpm='npm --registry="http://10.211.55.14:4873"'

[erichan@Eric-Mavericks arcas]$ npm install logsto
logsto@0.0.6 ../node_modules/logsto
[erichan@Eric-Mavericks arcas]$ dpm publish logsto
+ logsto@0.0.6
```

##Sinopia Server flow
>https://github.com/rlidwka/sinopia.git
