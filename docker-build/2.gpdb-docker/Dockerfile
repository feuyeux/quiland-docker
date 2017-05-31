FROM reg.docker.alibaba-inc.com/imore/basic
MAINTAINER lu.hl<lu.hl@alibaba-inc.com>

ENV GPDB_VERSION 4.3.8.1
COPY leo/* /tmp/
COPY gpdb-config/* /tmp/

RUN echo root:pivotal | chpasswd \
  && unzip /tmp/greenplum-db-${GPDB_VERSION}-build-1-RHEL5-x86_64.zip -d /tmp/ \
  && rm /tmp/greenplum-db-${GPDB_VERSION}-build-1-RHEL5-x86_64.zip \
  && sed -i s/"more << EOF"/"cat << EOF"/g /tmp/greenplum-db-${GPDB_VERSION}-build-1-RHEL5-x86_64.bin \
  && echo -e "yes\n\nyes\nyes\n" | /tmp/greenplum-db-${GPDB_VERSION}-build-1-RHEL5-x86_64.bin \
  && rm /tmp/greenplum-db-${GPDB_VERSION}-build-1-RHEL5-x86_64.bin \
  && cat /tmp/sysctl.conf >> /etc/sysctl.conf \
  && cat /tmp/limits.conf >> /etc/security/limits.conf \
  && rm -f /tmp/*.conf \
  && chmod 777 /tmp/gpinitsystem_config \
  && mv /tmp/start.sh /usr/local/bin/gp-start.sh \
  && chmod +x /usr/local/bin/gp-start.sh \
  && /usr/sbin/groupadd gpadmin \
  && /usr/sbin/useradd gpadmin -g gpadmin -G wheel \
  && echo "pivotal"|passwd --stdin gpadmin \
  && echo "gpadmin  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers \
  && mv /tmp/bash_profile /home/gpadmin/.bash_profile \
  && chown -R gpadmin: /usr/local/green* \
  && chown -R gpadmin: /home/gpadmin

EXPOSE 2345 22
VOLUME /gpdata
CMD gp-start.sh