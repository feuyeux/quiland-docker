#!/bin/bash
docker run --rm -ti \
-h mdw \
-e MDW_IP=127.0.0.1 \
-e MDW_HOST=mdw \
-e SMDW_IP=127.0.0.1 \
-e SMDW_HOST=smdw \
-e SDW1_IP=127.0.0.1 \
-e SDW1_HOST=sdw1 \
-e SDW2_IP=127.0.0.1 \
-e SDW2_HOST=sdw2 \
-p 2345:2345 \
-v /tmp/gpdata:/gpdata \
reg.docker.alibaba-inc.com/imore/gpdb