FROM index.tenxcloud.com/docker_library/centos
RUN yum update -y
RUN yum -y install unzip git gcc automake autoconf libtool make pcre-devel zlib-devel openssl-devel popt-devel iproute

RUN mkdir /nginx
COPY nginx.zip /nginx
WORKDIR /nginx
RUN unzip nginx.zip
RUN tar -xf nginx-1.8.0.tar.gz
RUN tar -xf nginx-goodies-nginx-sticky-module-ng.tar.gz
WORKDIR /nginx/nginx-1.8.0
RUN chmod -R 777 .
RUN ./configure --prefix=/usr/local/nginx-1.8.0 --add-module=../nginx-goodies-nginx-sticky-module-ng-c78b7dd79d0d --sbin-path=/usr/local/nginx/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-http_ssl_module
RUN make && make install
RUN chmod +x /nginx/nginx
RUN cp /nginx/nginx /etc/init.d
ADD nginx.conf /etc/nginx/nginx.conf

RUN mkdir /keepalived
COPY keepalived-install.tar.gz /keepalived
WORKDIR /keepalived
RUN tar -xvf keepalived-install.tar.gz
WORKDIR /keepalived/keepalived
RUN tar -xf keepalived-1.2.19.tar.gz
WORKDIR  /keepalived/keepalived/keepalived-1.2.19
RUN ./configure --prefix=/usr/local/keepalived
RUN make && make install
RUN cp /usr/local/keepalived/sbin/keepalived /usr/sbin/
RUN cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/
RUN cp /usr/local/keepalived/etc/rc.d/init.d/keepalived /etc/init.d/
RUN mkdir /etc/keepalived
RUN cp -f /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived
RUN cp -f /keepalived/keepalived/check_nginx.sh /etc/keepalived
ADD keepalived.conf /etc/keepalived/keepalived.conf

WORKDIR /
RUN rm -rf /nginx
RUN rm -rf /keepalived

ADD prepare.sh /
RUN chmod 777 prepare.sh
CMD ["/prepare.sh"]
CMD ["/usr/sbin/keepalived","-D"]
CMD ["/usr/local/nginx/nginx","-g","daemon off;"]
EXPOSE 80
