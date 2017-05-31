Cannot connect to the Docker daemon. Is the docker daemon running on this host?

```
sudo service docker start

Redirecting to /bin/systemctl start  docker.service
Job for docker.service failed because the control process exited with error code. See "systemctl status docker.service" and "journalctl -xe" for details.
```

```
sudo route del -net 172.16.0.0 netmask 255.240.0.0
sudo service docker start
```

```
sudo docker rmi $(sudo docker images | grep "^<none>" | awk "{print $3}")
sudo docker images
```