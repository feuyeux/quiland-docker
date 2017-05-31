```shell
$ grep CGROUP /boot/config-`uname -r`

CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_NET_CLS_CGROUP=m
CONFIG_NETPRIO_CGROUP=m
```

Tech List
---------

-	Advanced:

-	Core:

	-	cgroup
	-	namespace

-	[coreos](https://github.com/coreos)

	-	[etcd](https://github.com/coreos/etcd)
	-	[fleet](https://github.com/coreos/fleet)
	-	[flannel](https://github.com/coreos/flannel)

Docker集中化管理：  
* [kubernetes](https://github.com/GoogleCloudPlatform/kubernetes)

-	sourcecode:

	-	docker
	-	libcontainer

-	[Pipework](https://github.com/jpetazzo/pipework)

-	[panamax](http://panamax.io/)

-	Apache:

-	[mesos](http://mesos.apache.org/)

	-	[chronos](https://github.com/airbnb/chronos)
	-	[marathon](https://github.com/mesosphere/marathon)

-	[zookeeper](http://zookeeper.apache.org/)

-	[storm](https://storm.apache.org/)

-	[spark](https://spark.apache.org/)

-	[flume](http://flume.apache.org/)

-	[Logstash](http://logstash.net/)

-	[zabbix](https://www.zabbix.org/wiki/Main_Page)

-	[LVS](http://www.linuxvirtualserver.org/software/)

-	[HAProxy](http://www.haproxy.org/)

-	[Nginx](http://nginx.org/)
