sudo docker run -ti --rm \
--net=host \
--privileged=true \
-e NP=eth0 \
-e VIP=10.211.55.50 \
feuyeux/lb
