# Docker Mastery: The Complete Toolset From a Docker Captain

> Build, compose, deploy, and manage Docker containers from development to DevOps based Swarm clusters

This repo is for use in my Udemy Course https://www.bretfisher.com/dockermastery

Feel free to create issues or PRs if you find a problem.


# Gloassary:

### Image

- Is the application I want to run. I.e. image of `nginx` web server.
- It the application `binaries` and` dependencies` for your app and `metadata` 
  on "how to" run it.
- We can store our images as `registry` on Docker Hub (hub.docker.com)
- Official: It is an **ordered collection of root fliesystem changes** and the 
  corresponding **execution parameters** to run within a `container` runtime.
- There ir **NO kernel**, **NO kernel modules**, the host (your OS or a Docker-Machine)
  provider the kernel.

### Container

- Is an instance of the image running as a `process`.
- We can have many containers of `same` image running.

# How to?

### Running container

```
docker container run --publish 80:80 nginx
```

- It will download Nginx image and run it in a container. 
- Now access `http://localhost`.

What happened?

- Docker tried to locate locally an image `nginx` in the image cache.
- Docked did not find, so it will download from `hub.docker.com`.
- The latest image will be download, which means `nginx:latest` and it will be 
stored in the image cache.
- Docker Engine will give to the container an IP in a private network.
- Docker Engine exposed container port `80`.
- Docker Engine redirected the traffic for your localhost port `80` to 
container port `80`.
- Docker Engine started a new process for a container of `nginx` image.
- This container will execute `CMD` command inside the Docker file of 
`nginx` image.


If we want to run it in a `detached` process, we can run:

```
docker container run --publish 80:80 --detach nginx
```

It will give you an unique container ID, i.e. `6db7f4379093a7ea67acc83ca28fd9840e30c92546df4e83998462f57a72656b`.

### Listing containers

You can see the running container by typing:

```
docker container ls
```

or to see all containers history.

```
docker container ls -a
```

### Stopping containers

And to stop the container (where `6db7f4379093` is my container ID):

```
docker container stop 6db7f4379093
```

### Running with name

Specifying a container name is good practice.


```
docker container run --publish 80:80 --detach --name webhost nginx
```

### Restart a previous stoped container: 

By providing the container's `name` or `ID` you can start previously stoped container. 

I.e for `webhost` container's name.

```
docker container start webhost
```

### See container logs.

Where my container is `webhost`.

```
docker container logs webhost
```

### Monitoring a container 

Where `webhost` is my container.

See container process inside container

```
docker container top webhost
```

To obtain ipaddress, gateway, port etc.

```
docker container inspect webhost
```

See memory usage, processor usage, network, process, etc.

```
docker container stats webhost
```

### Removing container

Here I can also remove more than one container by providing theirs IDs as follows.

```
docker container rm 69aeec00bc47 6db7f4379093 16c2c0cf9a66
```

### Starting multiple containers and passing environment variables

Note the `--env` was used to set mysql root password.

```
docker container run --publish 80:80 --detach --name nginx_server nginx
docker container run --publish 8080:80 --detach --name apache_server httpd
docker container run --publish 3307:3306 --detach --env MYSQL_ROOT_PASSWORD=root --name mysql_db mysql
```


### Run interactive commands inside container

For this we use `-i` (interactive: Keep STDIN open even if not attached) and `-t` (tty: Allocate a pseudo-TTY / text terminal).

To go inside the container:

```
docker container exec -it nginx_server bash
```

To execute commands from outside the container:

```
docker container exec -it nginx_server whoami
```

#### For Alpine

For `alpine` there is no `bash` installed by default, so it is needed to use `sh`


```
docker pull alpine
docker container run --detach --name alpine alpine tail -f /dev/null
docker container exec -it alpine sh
```

Obs: Note that we use `tail -f /dev/null` to keep alpine container `alive` after exit.

... and inside Apline, install the bash

```
apk update
apk add bash
```

docker container exec -it alpine bash

... now you can run bash:

```
docker container exec -it alpine bash
```

### Run a container overriding initial COMMAND

It will override default image initialization command to `bash` and will bring you to inside the container.

```
docker container run -it --name nginx_server nginx bash
```

### Download image to local image cache

It will download linux `alpine` image to local cache.

```
docker pull alpine
```

### Clean up file system after exit

If you are running short-term foreground processes, these container file 
systems can really pile up. If instead you’d like Docker to automatically clean 
up the container and remove the file system when the container exits, you can 
add the `--rm` flag:

```
docker container run --rm -it --name my_centos centos:7 bash
```

So when you exit the container it will remove all generated container 
filesystem. Type ``` docker container ls -a ``` and you will notice that 
container is not there anymore. 

It also works if you run container with `--detach` and stop the container.

## Docker Networking

- The docker container is created inside a virtual network called `bridge` or `docker0`.
- When we "expose a port" we are telling to our system (in my case, my MAC) 
 open up in the "network interface" (which is a kind of firewall) the port `8080` 
 and NAT (translate the network) traffic through this private network to port `80` of `bridge`.
- We can have more then one "docker virtual network" and restrict access among certain containers.

...Start a container specifing that internal port `80` will be exposed as `8080`.

```
docker container run --publish 8080:80 --detach --name nginx_server nginx
```

...To check the port

```
docker container port nginx_server
```

...To check the ip address using `format` option (very helpful option).

```
docker container inspect --format '{{ .NetworkSettings.IPAddress }}' nginx_server
```

...Useful network commands

- Show networks: ``` docker network ls ```
- Inspect a network (i.e. bridge): ``` docker network inspect bridge ```
- Inspect networks for specific container ``` docker container inspect --format '{{ .NetworkSettings.Networks }}' nginx_server ```
- Create a network: ``` docker network create my_app_net --driver bridge ``` (you can specify different drivers in order to get more networking features).
- Attach a network to a container ``` docker network connect my_app_net nginx_server ```
- Detach a network from a container ``` docker network disconnect my_app_net nginx_server ```

### DNS for containers


Docker container IPs will be generated dynamically inside networks, 
so we need to set DNS to avoid possible inconsistency.

Docker Daemon has an internal DNS server that containers use by default.

Let's suppose I have two containers `apache_server` and `nginx_server` 
and I have a network called `my_app_net`. If I add both containers to this network, 
they will be able to "ping" each other automatically by their "names" instead rellying on IPs.

Example:

First enter in your containers `apache_server` and `nginx_server` and install ping package:

```
apt-get update
apt-get install iputils-ping
```

Exit the containers and create a network:

``` 
docker network create my_app_net --driver bridge 
```

Now connect them to the same network:

```
docker network connect my_app_net apache_server
docker network connect my_app_net nginx_server
```

And it will allow you to reach each other by the container name as you can test:

```
docker container exec -it nginx_server ping apache_server
docker container exec -it apache_server ping nginx_server
```


#### DNS Round Robin

We can 2 or more containers responding to the same DNS. It is a technique used 
by many companies to balance their farm of servers.

- Since Docker Engine 1.11 it is possible to have containers under a network 
responding to the same DNS.

For this example lets create 2 containers for `elasticsearch:2` image using 
the following container options:

- `--network`: Specify the user network created.
- `--network-alias`: Add network-scoped alias for the container. It will 
basically give to the container an additional DNS name to respond to.

```
docker network create dude
docker container run --detach --network dude --net-alias search --name my_elasticsearch_1 elasticsearch:2
docker container run --detach --network dude --net-alias search --name my_elasticsearch_2 elasticsearch:2
```

To see wich container is called using "Round Robin", we can do a test by:

```
docker container run --rm --network dude alpine nslookup search
```

And to get specific elasticsearch response, inside your centos container 
execute multiple times this (you should get different responses from each 
container):

```
docker container run --rm --network dude centos curl -s search:9200
```

## Images

To see image history commands

```
docker image history nginx:latest
```
 And the output will be like this:

```
 IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
cd5239a0906a        11 days ago         /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
<missing>           11 days ago         /bin/sh -c #(nop)  STOPSIGNAL [SIGTERM]         0B
<missing>           11 days ago         /bin/sh -c #(nop)  EXPOSE 80/tcp                0B
<missing>           11 days ago         /bin/sh -c ln -sf /dev/stdout /var/log/nginx…   22B
<missing>           11 days ago         /bin/sh -c set -x  && apt-get update  && apt…   53.7MB
<missing>           11 days ago         /bin/sh -c #(nop)  ENV NJS_VERSION=1.15.0.0.…   0B
<missing>           11 days ago         /bin/sh -c #(nop)  ENV NGINX_VERSION=1.15.0-…   0B
<missing>           6 weeks ago         /bin/sh -c #(nop)  LABEL maintainer=NGINX Do…   0B
<missing>           7 weeks ago         /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>           7 weeks ago         /bin/sh -c #(nop) ADD file:ec5be7eec56a74975…   55.3MB
```

All the lines are **layers** poiting to `cd5239a0906a` image. And they were 
modified in different times. Docker "caches" this layers with a unique SHA.

And to see details about image:

```
docker image inspect nginx:latest
```

It will shouw you:

- Exposed ports
- Env variables 
- Cmd commands
- Architecture (i.e: amd64)
- OS
- etc...

### Tagging images

Download any image:

Obs: In this example I will use **gabrielfs7/nginx:latest**

```
docker pull nginx:latest
```
Create a tag for the image

```
docker image tag nginx:latest gabrielfs7/nginx:latest
```

Push the image:

```
docker image push gabrielfs7/nginx:latest
```

Obs: Probably you will have to login on DockerHub before push the image, so:

```
docker login
```
