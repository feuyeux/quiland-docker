### no16
Dockerization for Big Data

docker.doctor.sh
```
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -a | grep vm.max_map_count
sudo route del -net 172.16.0.0 netmask 255.240.0.0
sudo service docker start
sudo docker rm $(sudo docker ps -aq) 
sudo docker rmi $(sudo docker images | grep "^<none>" | awk "{print $3}")
sudo docker images
```

```
docker kill $(docker ps -aq) || docker rm $(docker ps -aq) || docker images|grep none|awk '{print $3 }'|xargs docker rmi
```