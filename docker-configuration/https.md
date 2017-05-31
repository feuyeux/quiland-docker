Docker Daemon安全手记
---------------------

此前Docker Daemon以tcp方式工作在4243端口，没有任何安全机制。为了加强Docker Host的安全性，从本文开始，使用TLS代替TCP。 TLS（SSLv3）是基于TCP的安全通信机制，Docker支持TLS，并可配置是否双向认证。

### 1 证书生成

#### CA证书

```
echo 01 > ca.srl
openssl genrsa -des3 -out ca-key.pem 2048
openssl req -new -x509 -days 365 -key ca-key.pem -out ca.pem
```

#### 服务器证书

分别生成私钥、自签证书(CSR)、CA签证书

```
openssl genrsa -des3 -out server-key.pem 2048
openssl req -subj '/CN=AU' -new -key server-key.pem -out server.csr
openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem -out server-cert.pem
```

#### 客户端证书

分别生成私钥、自签证书(CSR)、CA签证书

```
openssl genrsa -des3 -out key.pem 2048
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile.cnf
openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf
```

#### 去密码环节

```
openssl rsa -in server-key.pem -out server-key.pem
openssl rsa -in key.pem -out key.pem
```

### 2 服务器端

#### 配置docker daemon启动参数

```shell
/etc/default/docker

DOCKER_OPTS="--insecure-registry docker-registry.alibaba.net:5000 -api-enable-cors=true -H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock --dns 8.8.8.8 --dns 8.8.4.4 --tlsverify --tlscacert=/home/lu.hl/s/ca.pem --tlscert=/home/lu.hl/s/server-cert.pem --tlskey=/home/lu.hl/s/server-key.pem"
```

#### 重启服务

```
sudo service docker restart

ps aux | grep docker
root     15726  9.0  0.0 324824 11184 ?        Ssl  22:26   0:00 /usr/bin/docker -d --insecure-registry docker-registry.alibaba.net:5000 -api-enable-cors=true -H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock --dns 8.8.8.8 --dns 8.8.4.4 --tlsverify --tlscacert=/home/lu.hl/s/ca.pem --tlscert=/home/lu.hl/s/server-cert.pem --tlskey=/home/lu.hl/s/server-key.pem
```

### 3 客户端

#### boot2docker配置host

```
boot2docker start
boot2docker ssh
/etc/hosts
10.101.72.17 AU
```

#### 双向认证测试

```
docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem -H=AU:2376 ps
2015/01/21 14:54:01 Get https://AU:2376/v1.13/containers/json: x509: certificate signed by unknown authority
```

这种方式失败，估计原因是CA不被boot2docker信任。

```shell
docker --tls --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem -H=AU:2376 version
Client version: 1.1.1
Client API version: 1.13
Go version (client): go1.2.1
Git commit (client): bd609d2
Server version: 1.4.1
Server API version: 1.16
Go version (server): go1.3.3
Git commit (server): 5bc2ff8
```

#### cURL测试

```shell
curl --insecure --cert cert.pem --key key.pem https://10.101.72.17:2376/images/json
```

参考

https://docs.docker.com/articles/https/ shell
