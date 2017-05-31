#Create a container

```shell
POST /containers/create
```

Example request:

```json
    POST /containers/create HTTP/1.1
    Content-Type: application/json

    {
         "Hostname":"",
         "Domainname": "",
         "User":"",
         "Memory":0,
         "MemorySwap":0,
         "CpuShares": 512,
         "Cpuset": "0,1",
         "AttachStdin":false,
         "AttachStdout":true,
         "AttachStderr":true,
         "Tty":false,
         "OpenStdin":false,
         "StdinOnce":false,
         "Env":null,
         "Cmd":[
                 "date"
         ],
         "Entrypoint": ""
         "Image":"base",
         "Volumes":{
                 "/tmp": {}
         },
         "WorkingDir":"",
         "NetworkDisabled": false,
         "ExposedPorts":{
                 "22/tcp": {}
         },
         "SecurityOpts": [""],
         "HostConfig": {
           "Binds":["/tmp:/tmp"],
           "Links":["redis3:redis"],
           "LxcConf":{"lxc.utsname":"docker"},
           "PortBindings":{ "22/tcp": [{ "HostPort": "11022" }] },
           "PublishAllPorts":false,
           "Privileged":false,
           "Dns": ["8.8.8.8"],
           "DnsSearch": [""],
           "VolumesFrom": ["parent", "other:ro"],
           "CapAdd": ["NET_ADMIN"],
           "CapDrop": ["MKNOD"],
           "RestartPolicy": { "Name": "", "MaximumRetryCount": 0 },
           "NetworkMode": "bridge",
           "Devices": []
        }
    }

```

Example response:

```json
    HTTP/1.1 201 Created
    Content-Type: application/json

    {
         "Id":"f91ddc4b01e079c4481a8340bbbeca4dbd33d6e4a10662e499f8eacbb5bf252b"
         "Warnings":[]
    }
```

Json Parameters:

-	Hostname - A string value containing the desired hostname to use for the container.
-	Domainname - A string value containing the desired domain name to use for the container.
-	User - A string value containg the user to use inside the container.
-	Memory - Memory limit in bytes.
-	MemorySwap- Total memory usage (memory + swap); set -1 to disable swap.
-	CpuShares - An integer value containing the CPU Shares for container (ie. the relative weight vs othercontainers).
-	CpuSet - String value containg the cgroups Cpuset to use.
-	AttachStdin - Boolean value, attaches to stdin.
-	AttachStdout - Boolean value, attaches to stdout.
-	AttachStderr - Boolean value, attaches to stderr.
-	Tty - Boolean value, Attach standard streams to a tty, including stdin if it is not closed.
-	OpenStdin - Boolean value, opens stdin,
-	StdinOnce - Boolean value, close stdin after the 1 attached client disconnects.
-	Env - A list of environment variables in the form of VAR=value
-	Cmd - Command to run specified as a string or an array of strings.
-	Entrypoint - Set the entrypoint for the container a a string or an array of strings
-	Image - String value containing the image name to use for the container
-	Volumes – An object mapping mountpoint paths (strings) inside the container to empty objects.
-	WorkingDir - A string value containing the working dir for commands to run in.
-	NetworkDisabled - Boolean value, when true disables neworking for the container
-	ExposedPorts - An object mapping ports to an empty object in the form of: `"ExposedPorts": { "<port>/<tcp|udp>: {}" }`
-	ecurityOpts: A list of string values to customize labels for MLS systems, such as SELinux.
-	HostConfig
-	Binds – A list of volume bindings for this container. Each volume binding is a string of the form `container_path` (to create a new volume for the container), `host_path:container_path` (to bind-mount a host path into the container), or `host_path:container_path:ro` (to make the bind-mount read-only inside the container).
-	Links - A list of links for the container. Each link entry should be of of the form "container_name:alias".
-	LxcConf - LXC specific configurations. These configurations will only work when using the lxc execution driver.
-	PortBindings - A map of exposed container ports and the host port they should map to. It should be specified in the form `{ <port>/<protocol>: [{ "HostPort": "<port>" }] }` Take note that port is specified as a string and not an integer value.
-	PublishAllPorts - Allocates a random host port for all of a container's exposed ports. Specified as a boolean value. Privileged - Gives the container full access to the host. Specified as a boolean value.
-	Dns - A list of dns servers for the container to use.
-	DnsSearch - A list of DNS search domains
-	VolumesFrom - A list of volumes to inherit from another container. Specified in the form `<container name>[:<ro|rw>]`
-	CapAdd - A list of kernel capabilties to add to the container.
-	Capdrop - A list of kernel capabilties to drop from the container.
-	RestartPolicy – The behavior to apply when the container exits. The value is an object with a Name property of either `"always"` to always restart or `"on-failure"` to restart only when the container exit code is non-zero. If `on-failure` is used, `MaximumRetryCount` controls the number of times to retry before giving up. The default is not to restart. (optional)
-	NetworkMode - Sets the networking mode for the container. Supported values are: `bridge`, `host`, and `container:<name|id>`
-	Devices - A list of devices to add to the container specified in the form `{ "PathOnHost": "/dev/deviceName", "PathInContainer": "/dev/deviceName", "CgroupPermissions": "mrw"}`

Query Parameters:

-	name – Assign the specified name to the container. Must match `/?[a-zA-Z0-9_-]+`.

Status Codes:

-	201 – no error
-	404 – no such container
-	406 – impossible to attach (container not running)
-	500 – server error
