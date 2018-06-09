# Docker Mastery: The Complete Toolset From a Docker Captain

> Build, compose, deploy, and manage Docker containers from development to DevOps based Swarm clusters

This repo is for use in my Udemy Course https://www.bretfisher.com/dockermastery

Feel free to create issues or PRs if you find a problem.


# Gloassary:

### Image

- Is the application I want to run. I.e. image of "nginx" web server.
- We can store our images as "registry" on Docker Hub (hub.docker.com)

### Container

- Is an instance of the image running as a "process".
- We can have many containers of "same" image running.

# How to?

### Running container

```
docker container run --publish 80:80 nginx
```

- It will download Nginx image and run it in a container. 
- Now access "http://localhost".

What happened?

- Docker tried to locate locally an image "nginx" in the image cache.
- Docked did not find, so it will download from "hub.docker.com".
- The latest image will be download, which means "nginx:latest" and it will be stored in the image cache.
- Docker Engine will give to the container an IP in a private network.
- Docker Engine exposed container port "80".
- Docker Engine redirected the traffic for your localhost port "80" to container port "80".
- Docker Engine started a new process for a container of "nginx" image.
- This container will execute "CMD" command inside the Docker file of "nginx" image.


If we want to run it in a "detached" process, we can run:

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

By providing the container's "name" or "ID" you can start previously stoped container. 

I.e for `webhost` container's name.

```
docker container start webhost
```

### See container logs.

Where my container is `webhost`.

```
docker container logs webhost
```

### See container process inside container

Where `webhost` is my container.

```
docker container top webhost
```

### Inspect a container

TO obtain ipaddress, gateway, port etc.

```
docker container inspect webhost
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