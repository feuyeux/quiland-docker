## 安装 mesos

### 1 准备svn
```
sudo nano /etc/yum.repos.d/wandisco-svn.repo
```

```
[WandiscoSVN]
name=Wandisco SVN Repo
baseurl=http://opensource.wandisco.com/centos/7/svn-1.8/RPMS/$basearch/
enabled=1
gpgcheck=0
```

```
sudo yum groupinstall -y "Development Tools"
```

### 2 准备maven
```
wget http://mirror.nexcess.net/apache/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
sudo tar -zxf apache-maven-3.3.3-bin.tar.gz -C /opt/
sudo ln -s /opt/apache-maven-3.3.3/bin/mvn /usr/bin/mvn
```

### 3 准备编译所需软件
```
sudo ln -s /usr/lib64/libsasl2.so.3 /usr/lib64/libsasl2.so.2
sudo rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/l/libserf-1.3.7-1.el7.x86_64.rpm

sudo yum remove -y subversion-libs-1.7.14-6.2.alios7

sudo yum install -y python-devel java-1.7.0-openjdk-devel java-1.8.0-openjdk-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 apr-devel subversion-devel apr-util-devel
```

### 4 获取mesos代码并编译安装
```
wget http://www.apache.org/dist/mesos/0.25.0/mesos-0.25.0.tar.gz
tar -xzf mesos-*.tar.gz
sudo chown -R erichan mesos-0.25.0
cd mesos-0.25.0
./bootstrap
mkdir build
cd build
../configure --with-webui --with-included-zookeeper
make
sudo make install
```

## 2 验证 mesos
```
whereis mesos-master
mesos-master: /usr/local/sbin/mesos-master
```

## 3 Cluster
### dns
```
sudo nano /etc/hosts

127.0.0.1   localhost
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.211.55.29 mesos2
10.211.55.31 mesos3
10.211.55.30 mesos1

sudo nano /etc/hostname
mesos1

```

### from master
```
sudo nano /usr/local/etc/mesos/masters

mesos1
mesos2
mesos3
```

```
sudo nano /usr/local/etc/mesos/slaves

mesos1
mesos2
mesos3
```

```
ssh-keygen -f ~/.ssh/id_rsa -P ""
ssh-copy-id -i ~/.ssh/id_rsa.pub erichan@mesos1
ssh-copy-id -i ~/.ssh/id_rsa.pub erichan@mesos2
ssh-copy-id -i ~/.ssh/id_rsa.pub erichan@mesos3
```

```
sudo nano /usr/local/sbin/mesos-daemon.sh
# ulimit -n 8192
```

```
/usr/local/sbin/mesos-start-cluster.sh
/usr/local/sbin/mesos-stop-cluster.sh
```

### 启动 Mesos Master
```
sudo mkdir –p /var/lib/mesos
sudo chown `whoami` /var/lib/mesos
mesos-master --ip=10.211.55.30 --work_dir=/var/lib/mesos
```

### 启动 Mesos Slave
```
mesos-slave --master=mesos1:5050
```

## 4 spark
```
tar -xvf spark-1.4.0-bin-hadoop2.6.tar
scp spark-1.4.0-bin-hadoop2.6.tar lu.hl@yarn1.alibaba.net:/home/lu.hl

hadoop fs -put spark-1.4.0-bin-hadoop2.6.tar /spark

hadoop fs -ls /spark
Found 1 items
-rw-r--r--   1 lu.hl supergroup  281784320 2015-07-08 20:20 /spark/spark-1.4.0-bin-hadoop2.6.tar

export SPARK_EXECUTOR_URI=hdfs://yarn1.alibaba.net/spark/spark-1.4.0-bin-hadoop2.6.tar
```

```
export MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so
mesos-master --work_dir=/var/lib/mesos
mesos-slave --master=mesos2:5050
bin/spark-shell --master mesos://mesos2:5050
```

val data = 1 to 10000
val distData = sc.parallelize(data)
distData.filter(_< 10).collect()
