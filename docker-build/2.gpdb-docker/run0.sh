#!/bin/bash
sudo docker run --rm -ti \
-h $1 \
-e MDW_HOST=mdw -e MDW_IP=10.101.95.23 \
-e SMDW_HOST=smdw -e SMDW_IP=10.189.193.225 \
-e SDW1_HOST=sdw1 -e SDW1_IP=10.101.110.3 \
-e SDW2_HOST=sdw2 -e SDW2_IP=100.81.0.123 \
-v /tmp/gpdata:/gpdata -p 2345:2345 \
reg.docker.alibaba-inc.com/imore/gpdb