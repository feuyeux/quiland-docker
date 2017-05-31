docker build -t reg.docker.alibaba-inc.com/imore/nls_java8 -f java8.dockerfile .
#docker run -ti --rm reg.docker.alibaba-inc.com/imore/nls_java8 java -version
## https://aone.alibaba-inc.com/appcenter/dockerImage/list

## --insecure-registry reg.docker.alibaba-inc.com
## --engine-registry-mirror=https://g4tn1pv6.mirror.aliyuncs.com
docker login reg.docker.alibaba-inc.com -u=lu.hl -p=bzry120
docker push reg.docker.alibaba-inc.com/imore/nls_java8
