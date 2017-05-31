## reg.docker.alibaba-inc.com/aone-base/nls_java8
## https://aone.alibaba-inc.com/appcenter/dockerImage/list
FROM reg.docker.alibaba-inc.com/aone-base/nls_base:20161115123543
MAINTAINER lu.hl<lu.hl@alibaba-inc.com>

#java 8
ENV JAVA_VERSION 8u112
ENV BUILD_VERSION b15

RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm \
&& yum -y install /tmp/jdk-8-linux-x64.rpm \
&& alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000 \
&& alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000 \
&& alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000 \
&& rm /tmp/jdk-8-linux-x64.rpm

ENV JAVA_HOME /usr/java/latest
ENV PATH $JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/satools
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

RUN yum install -y gcc-c++ && yum install -y c_tbip -b current \
&& rpm -ivh --nodeps "http://yum.tbsite.net/taobao/5/x86_64/current/tengine-proxy/tengine-proxy-2.0.6-17715.el5u4.x86_64.rpm"