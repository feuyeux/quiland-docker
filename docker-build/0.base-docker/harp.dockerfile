# https://harpjs.com/

# ssh lu.hl@10.189.194.38
# wget http://nodejs.org/dist/v7.2.0/node-v7.2.0.tar.gz
# tar xzvf node-v* && cd node-v*
# sudo yum install gcc gcc-c++
# ./configure
# make
# sudo make install
# node --version

# sudo npm install -g harp
# harp server /var/www --port 9527

FROM mhart/alpine-node
RUN apk add --update python
RUN npm install -g harp
VOLUME /var/www
WORKDIR /var/www
EXPOSE 9527
CMD harp server /var/www --port 9527

# docker build -t harp -f harp.dockerfile .
# mkdir /tmp/my_mk_dir
# cd /tmp/my_mk_dir && echo "# test" > index.md
# docker run -ti --rm -v /tmp/my_mk_dir:/var/www -p 19527:9527 harp
# http localhost:19527/index.html