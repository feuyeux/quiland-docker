## elasticsearch

#### 1 elasticsearch镜像制作

```
FROM index.tenxcloud.com/docker_library/java
MAINTAINER Eric Han "feuyeux@gmail.com"

RUN useradd -ms /bin/bash es
USER es
WORKDIR /home/es
RUN wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.2.0/elasticsearch-2.2.0.tar.gz
RUN tar zxf elasticsearch-2.2.0.tar.gz
ENTRYPOINT ["/home/es/elasticsearch-2.2.0/bin/elasticsearch"]
```

#### 2 容器配置文件
`mkdir es_config` `nano es_config/elasticsearch.yml`

```
network.host: 0.0.0.0
```

`nano es_config/logging.yml`

```
# you can override this using by setting a system property, for example -Des.logger.level=DEBUG
es.logger.level: INFO
rootLogger: ${es.logger.level}, console
logger:
  # log action execution errors for easier debugging
  action: DEBUG
  # reduce the logging for aws, too much is logged under the default INFO
  com.amazonaws: WARN

appender:
  console:
    type: console
    layout:
      type: consolePattern
      conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
```

#### 3 构建镜像
```
sudo docker build -t feuyeux/elasticsearch .
```

#### 4 启动容器
- es_config 用于日后动态修改配置
- es_plugins 用于日后增减插件

```
sudo docker run -d \
--name es1 \
-p 19200:9200 \
-p 19300:9300 \
-v $PWD/es_config:/home/es/elasticsearch-2.2.0/config \
-v $PWD/es_plugins:/home/es/elasticsearch-2.2.0/plugins \
feuyeux/elasticsearch
```

```
curl localhost:19200
{
 "name" : "Madame Hydra",
 "cluster_name" : "elasticsearch",
 "version" : {
	 "number" : "2.2.0",
	 "build_hash" : "8ff36d139e16f8720f2947ef62c8167a888992fe",
	 "build_timestamp" : "2016-01-27T13:32:39Z",
	 "build_snapshot" : false,
	 "lucene_version" : "5.4.1"
 },
 "tagline" : "You Know, for Search"
}

```
