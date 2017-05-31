## reg.docker.alibaba-inc.com/aone-base/nls_base
## https://aone.alibaba-inc.com/appcenter/dockerImage/list
FROM reg.docker.alibaba-inc.com/ali/os:6u2
MAINTAINER lu.hl<lu.hl@alibaba-inc.com>

#install utilities
RUN yum -y install git wget unzip tar gzip vixie-cron which tar more util-linux-ng passwd openssh-clients openssh-server ed m4 \
&& yum clean all