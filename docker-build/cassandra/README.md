https://hub.docker.com/_/cassandra/
https://github.com/docker-library/cassandra

### Start a cassandra server instance
```
docker run --name some-cassandra -d cassandra:tag
```

### Make a cluster
#### For the same machine

```
docker run --name some-cassandra2 -d -e CASSANDRA_SEEDS="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' some-cassandra)" cassandra:tag
```

```
docker run --name some-cassandra2 -d --link some-cassandra:cassandra cassandra:tag
```

#### For separate machines
Assuming the first machine's IP address is 10.42.42.42 and the second's is 10.43.43.43, start the first with exposed gossip port:

```
docker run --name some-cassandra -d -e CASSANDRA_BROADCAST_ADDRESS=10.42.42.42 -p 7000:7000 cassandra:tag
```

Then start a Cassandra container on the second machine, with the exposed gossip port and seed pointing to the first machine:

```
docker run --name some-cassandra -d -e CASSANDRA_BROADCAST_ADDRESS=10.43.43.43 -p 7000:7000 -e CASSANDRA_SEEDS=10.42.42.42 cassandra:tag
```

### Connect to Cassandra from cqlsh
```
docker run -it --link some-cassandra:cassandra --rm cassandra sh -c 'exec cqlsh "$CASSANDRA_PORT_9042_TCP_ADDR"'
```

```
docker run -it --link some-cassandra:cassandra --rm cassandra cqlsh cassandra
``` 