#### Monolithic and Microservice
- Monolithic Architecture, the all components of application is tightly bounded and all the component code should write in same language if any component require updation we need to deploy the entire application. Ex: Finacial service like Banking
- Microservice Architecture, the component of applications are autonomous, each component can code with different language, any update in a component can achieve by deploying the service alone not the entire application. Ex: Swiggy 
- ![vm_container.png](https://github.com/email4prasanth/Practice-Docker/blob/master/Images/vm_container.png)
- Hardware servers -- Virtual Machines(Monolithic) -- Containers(Microservice)
- (Container)[https://jvns.ca/blog/2016/10/10/what-even-is-a-container/] is collection of linux features like namespace(seperates process/applicaiton) and cgroups(Memory Calculation) that isolates the processes from each other. 
- Docker Engine is a containerization engine that runs on servers and manage containers.
- why container are using?
    - Deployment is fast compare to VM, the OS layer is common for all application and there is no over head. 
- (container runtime)[https://www.aquasec.com/cloud-native-academy/container-security/container-runtime/]
- Basic thing is how to connent and run the docker, ![DockerArchitecture](https://github.com/email4prasanth/Practice-Docker/blob/master/Images/Architecture-of-Docker.png).
- Launch ubuntu server `Docker_Host` t2.micro use URL IPv4Address putty login as `ubuntu` and go to root user, install jq, unzip, nettools
```
docker (not found)
ifconfig
apt update && apt install -y net-tools jq unzip
ifconfig (will show eth0)
curl https://get.docker.com | bash
ifconfig
```
- To start an ec2 instance we neen ami, similarly to start container we need an image (which is available in container registry).
```
docker version (contain client(build, pull run) and server (docker daemon, container, image))
docker ps (Container ID, Image, Command, Created, PORT, STATUS, Names )
docker images (Repository, Tag, Image ID, Created, Size)
```
- Container Register
    - hub.docker.com or DockerHub (Application server, app server like NGINX, Tomcat, mysql will store image here we use these images and customize as per requirement)
    - AWS ECR
    - Azure ACR
    - Google Container Registry & Artifactory Registry
- Container Registry -- Repositories(sreeharshav/rollingupdate) -- Images(v1 or gitsha(commitID) or ${BuildID})
```
ifconfig ( you can see docker0 Bridge network)
```
- ![Portforwarding](https://github.com/email4prasanth/Practice-Docker/blob/master/Images/port%20forwarding.png) (1:08:00) 
- docker0 is a bridge network that connects etho0 and applications.
- To pull the image from the dockerhub in different ways
1. image pull from dockerhub
```
docker pull nginx
docker images
docker images --digests
docker image inspect nginx:latest
docker rmi nginx:latest --force
```
2. image pull using digest
```
docker pull nginx:sha256:67682bda769fae1ccf5183192b8daf37b64cae99c6c3302650f6f8bf5f0f95df
docker tag [sourceimageid]  nginx:sha95df
```
3. Pull from a different registry
- The following command pulls the testing/test-image image from a local registry listening on port 5000 (myregistry.local:5000):
```
docker pull myregistry.local:5000/testing/test-image
```
4. Pull all images
```
docker pull -a ubuntu or docker image pull --all-tags ubuntu
docker image ls --filter reference=ubuntu
```



#### Interview Question
- what are the defalut network created when docker is installed
    - Bridge (similar to IGW), host and Null Network to see this `docker network ls`
- Docker swarm what network you can see
    - Ingress under scope `Overlay`
- Dockerfile
    - FROM -- Specifies base image to use for docker. `Ex FROM python:3.12 or FROM ubuntu:22.04`
    - LABEL --  metadata to image `Ex LABEL owner="", LABEL version=""`
    - ARG - Declare variables that can use at build time
        ```
        ARG VERSION
        ADD https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip /usr/local/bin/terraform.zip
        ```
    - WORKDIR - setting working directory to copy the code `Ex: WORKDIR /app`
    - COPY - Copy file from host machine to a directory `Ex: COPY COPY scorekeeper.js /var/www/html/scorekeeper.js`
    - RUN - run the commands, install a needed packages to build an image
    ```
    RUN apt update
    RUN pip install --no-cache-dir -r requirements.txt
    ```
    - EXPOSE - Make a port available to the world outside of container `EXPOSE 80`
    - ENV - Define variable `ENV NAME World`
    - CMD - Command to run when container image starts
    ```
    CMD ["nginx","-g","daemon off;"] - to run the ngnix in foreground
    CMD ["python", "app.py"]
    ```
    - RUN command is used to build the image, CMD is used to run the commands while running an image.

