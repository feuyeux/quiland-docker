docker build -t reg.docker.alibaba-inc.com/imore/nls_base -f base.dockerfile .
## --insecure-registry reg.docker.alibaba-inc.com
## --engine-registry-mirror=https://g4tn1pv6.mirror.aliyuncs.com
docker login reg.docker.alibaba-inc.com -u=lu.hl -p=bzry120
docker push reg.docker.alibaba-inc.com/imore/nls_base