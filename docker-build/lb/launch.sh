#!/bin/sh
echo "start lb"

sudo docker run -d \
--name=lb1 \
--net=host \
--privileged=true \
-e NP=eth0 \
-e VIP=10.211.55.50 \
feuyeux/lb

echo ""
echo "test nginx"
curl 10.211.55.32

echo ""
echo "test keepalived"
curl 10.211.55.50
