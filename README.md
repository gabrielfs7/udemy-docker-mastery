# Docker Mastery: The Complete Toolset From a Docker Captain

> Build, compose, deploy, and manage Docker containers from development to DevOps based Swarm clusters

This repo is for use in my Udemy Course https://www.bretfisher.com/dockermastery

Feel free to create issues or PRs if you find a problem.


# Gloassary:

### Image

- Is the application I want to run. I.e. image of `nginx` web server.
- We can store our images as `registry` on Docker Hub (hub.docker.com)

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
- The latest image will be download, which means `nginx:latest` and it will be stored in the image cache.
- Docker Engine will give to the container an IP in a private network.
- Docker Engine exposed container port `80`.
- Docker Engine redirected the traffic for your localhost port `80` to container port `80`.
- Docker Engine started a new process for a container of `nginx` image.
- This container will execute `CMD` command inside the Docker file of `nginx` image.


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