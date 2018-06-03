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

### Running container

```
docker container run --publish 80:80 nginx
```

- It will download Nginx image and run it in a container. 
- Now access "http://localhost".

What happened?

- Docker tried to locate locally an image "nginx".
- Docked did not find, so Downloaded it from "hub.docker.com".
- Docker Engine started a new process for a container of "nginx" image.
- Docker Engine exposed container port "80".
- Docker Engine redirected the traffic for your localhost port "80" to container port "80".