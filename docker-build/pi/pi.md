### pi-base

#### Dockerfile

```
# Version: 0.0.1
FROM feuyeux/ubuntu-base
MAINTAINER Eric Han "feuyeux@gmail.com"
ADD ali.ubuntu.sourcelist /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y git wget libfreetype6 libfontconfig bzip2 unzip
RUN apt-get autoremove -y && apt-get clean all

ENV NODE_VERSION v0.10.35
ENV PHANTOMJS_VERSION 1.9.7

## NodeJs
RUN wget -q --no-check-certificate -O /tmp/node-$NODE_VERSION-linux-x64.tar.gz http://pi.alibaba-inc.com/files/node-$NODE_VERSION-linux-x64.tar.gz
RUN tar -xzf /tmp/node-$NODE_VERSION-linux-x64.tar.gz -C /tmp
RUN rm -f /tmp/node-$NODE_VERSION-linux-x64.tar.gz
RUN mv /tmp/node-$NODE_VERSION-linux-x64/ /opt/nodejs
ENV PATH=/opt/nodejs/bin:$PATH
ADD .npmrc /opt/pi/

## PhantomJs
RUN wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2
RUN tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp
RUN rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2
RUN mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /opt/phantomjs
ENV PATH=/opt/phantomjs/bin:$PATH

## CasperJs
RUN wget -q --no-check-certificate -O /tmp/casperjs1.1.zip http://pi.alibaba-inc.com/files/casperjs1.1.zip
RUN unzip -o /tmp/casperjs1.1.zip -d /opt/casperjs
RUN chmod +x /opt/casperjs/bin/casperjs
RUN rm -f /tmp/casperjs1.1.zip
ENV PATH=/opt/casperjs/bin:$PATH

WORKDIR /opt/pi
```

#### Build

```
d build -t="feuyeux/pi-base" .
```

#### Test

```
d run -ti --rm feuyeux/pi-base node -v
v0.10.35

d run -ti --rm feuyeux/pi-base phantomjs -v
1.9.7

d run -ti --rm feuyeux/pi-base casperjs --version
1.1.0-beta3

d run -ti --rm feuyeux/pi-base python -V
Python 2.7.6

```

### pi-common

#### Dockerfile

```
# Version: 0.0.1
FROM feuyeux/pi-base
MAINTAINER Eric Han "feuyeux@gmail.com"
RUN npm --registry=http://10.125.59.228:4873 install commonsto
RUN wget http://pi.alibaba-inc.com/files/mongoose.tar.gz
RUN tar -xzf mongoose.tar.gz -C /opt/pi/node_modules
RUN wget http://pi.alibaba-inc.com/files/kue.tar.gz
RUN tar -xzf kue.tar.gz -C /opt/pi/node_modules
RUN echo 'pi_basic' > /opt/pi/.pirc
RUN rm -f *.tar.gz
```

#### build

```
d build -t="feuyeux/pi-common" .
```

### pi-fetch-worker

#### Dockerfile

```
FROM feuyeux/pi-common
MAINTAINER Eric Han "feuyeux@gmail.com"
RUN npm --registry=http://10.125.59.228:4873 install pi-crawl-worker
RUN echo 'pi_fetchsto_worker' >> /opt/pi/.pirc
RUN PATH=/opt/pi/node_modules/pi-crawl-worker/bin:$PATH
RUN apt-get install -y curl
WORKDIR /opt/pi/node_modules/pi-crawl-worker/bin/
ENTRYPOINT ["node", "crawler.js"]
```

#### build

```
d build --no-cache -t="feuyeux/pi-fetch-worker" .
```

#### run

```
d kill $(d ps -aq) || d rm $(d ps -aq)

d run -d --name="fetch-worker_36100" --hostname="fetch-worker_36100" -m="500m" --cpuset="0,1" -p 36100:8000 feuyeux/pi-fetch-worker 8000
d run -d --name="fetch-worker_36101" --hostname="fetch-worker_36101" -m="500m" --cpuset="2,3" -p 36101:8000 feuyeux/pi-fetch-worker 8000
d run -d --name="fetch-worker_36102" --hostname="fetch-worker_36102" -m="500m" --cpuset="4,5" -p 36102:8000 feuyeux/pi-fetch-worker 8000
d run -d --name="fetch-worker_36103" --hostname="fetch-worker_36103" -m="500m" --cpuset="6,7" -p 36103:8000 feuyeux/pi-fetch-worker 8000
d run -d --name="fetch-worker_36104" --hostname="fetch-worker_36104" -m="500m" --cpuset="8,9" -p 36104:8000 feuyeux/pi-fetch-worker 8000

```

### pi-ngin
