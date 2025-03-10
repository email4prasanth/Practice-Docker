#### Monolithic and Microservice
- Monolithic Architecture, the all components of application is tightly bounded and all the component code should write in same language if any component require updation we need to deploy the entire application. Ex: Finacial service like Banking
- Microservice Architecture, the component of applications are autonomous, each component can code with different language, any update in a component can achieve by deploying the service alone not the entire application. Ex: Swiggy 
- ![vm_container.png](https://github.com/email4prasanth/Practice-Docker/blob/master/Images/vm_container.png)
- Hardware servers (physical servers in datacenter) -- Virtual Machines(Monolithic) -- Containers(Microservice)
#### ways to install container.

- (Container)[https://jvns.ca/blog/2016/10/10/what-even-is-a-container/] is collection of linux features like namespace(seperates process/applicaiton) and cgroups(Memory Calculation) that isolates the processes from each other. 
- Docker Engine is a containerization engine that runs on servers and manage containers.
- why container are using?
    - Deployment is fast compare to VM, the OS layer is common for all application and there is no over head. 
- (container runtime)[https://www.aquasec.com/cloud-native-academy/container-security/container-runtime/]
- Basic thing is how to connent and run the docker, ![DockerArchitecture](https://github.com/email4prasanth/Practice-Docker/blob/master/Images/Architecture-of-Docker.png).
- Launch ubuntu server `Docker_Host` t2.micro use URL IPv4Address putty login as `ubuntu` and go to root user, install jq, unzip, nettools
```
apt update
docker (not found)
ifconfig (not found)
apt install -y net-tools jq unzip
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
REPO TAG DIGEST IMAGEID CREATED SIZE
docker image inspect nginx:latest
docker image inspect nginx:latest | jq -r '.[0].RootFS.Layers[]'
docker rmi nginx:latest --force
```
2. image pull using digest
```
docker pull nginx@sha256:67682bda769fae1ccf5183192b8daf37b64cae99c6c3302650f6f8bf5f0f95df
docker images
docker tag [sourceimageid]  nginx:updated
docker rmi imageid
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
#### Part-2 Building custom docker image
- Login to docker host server, the default public web root is `var/www/` for ubuntu
- Dockerfile
    - FROM -- Specifies base image to use for docker. `Ex FROM python:3.12 or FROM ubuntu:22.04`
    - LABEL --  metadata to image in key-pair `Ex LABEL owner="", LABEL version=""`
    - ARG - Declare variables that can use at build time
        ```
        ARG VERSION
        ADD https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip /usr/local/bin/terraform.zip
        ```
    - WORKDIR - setting working directory to copy the code `Ex: WORKDIR /app`
    - COPY - Copy file from host machine to a directory `Ex: COPY scorekeeper.js /var/www/html/scorekeeper.js`
    - COPY is used to copy the file and ADD is used to copy and download
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
    ENTTRY POINT

    ```
- We can create multiple docker files and build the images, Here **dot(.)** represents the current folder
```
docker images (after build this will gives the images)
docker build -t marriprasanth/nginx:v1 -f Dockerfile .
docker build -t marriprasanth/pyhton:v1 -f Dockerfile.python .
docker history imageid ( this will gives the layers of docker image)
docker inspect imageid
docker inspect imageid | jq ".[0].RootFS.Layers[]."
docker inspect imageid | jq -r ".[0].RootFS.Layers[]."
```
- If want to enter into container first we need to build a container
```
docker build -t marriprasanth/nginx:v1 -f Dockerfile .
docker images
docker run -it marriprasanth/nginx:v1
exit
docker run -it marriprasanth/nginx:v1
exit
```
- If we dont want to enter into container but need to run and exit do the step for 4 or 5 times, and stop the running containers and remove the containers
```
docker run -d marriprasanth/nginx:v1 (4 times)
docker ps (when the container is running for the given image)
docker ps -a
docker ps -aq
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
```
- **Docker/Container is a process** we need `CMD` command to run the process.
```
docker images
docker run -d marriprasanth/nginx:v2 (4 times)
docker ps (this will show that containers are running)
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker images
```
- To copy the same image with different tag `docker tag imageid marriprasanth/newname:v1`.
- 52:30 EXPOSE is used to tell the current image will open in repective port, remove all images now build an image and run the image with name `nginx01` and expose to port 80
```
docker images
docker ps -a
docker rm $(docker ps -aq)
docker rmi $(docker image -aq)  
docker build -t marriprasanth/testing:v1 -f Dockerfile .
docker images
docker inspect imageid | jq ".[].Config.ExposedPorts" (get the port number)
docker run -d --name nginx01 --publish 8000:80 marriprasanth/testing:v1
```
- Open URL paste the Server IPv4 address with 8000 extension.
```
docker ps
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker ps
docker images
docker rmi $(docker images -aq) --force
docker images
dock
```
- Open URL paste the Server IPv4 address with 8000 extension.
- Chaning the instruction `ARG` using cli
```
docker build -t marriprasanth/nginx:v2 -f Dockerfile --build-arg VERSION='1.1.1' .
```
#### Part-3 Pushing image to ECR & hub.Docker
- Create AWS ECR `dkuttirepo` 
- Establish connection between ECR and ubuntu server. Install aws cli in ubuntu and create a repo in AWS, Credentials using IAM with `AdminFullAccess`.
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws --configure (enter AWS credential genereted using IAM role ACCESS KEY & SECRET KEY)
docker images
docker build -t marriprasanth/nginx:v1 -f Dockerfile .
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 610203850228.dkr.ecr.us-east-1.amazonaws.com
docker tag marriprasanth/nginx:v1 610203850228.dkr.ecr.us-east-1.amazonaws.com/dkuttirepo:latest
docker push 610203850228.dkr.ecr.us-east-1.amazonaws.com/dkuttirepo:latest
```
- Push the image to docker hub, we need to login
```
docker login (wiht email and password)
docker tag marriprasanth/nginx:v1 dkutti/testing:v1
```
- We can stop and start the docker container
```
docker images
docker build -t marriprasanth/nginx:v1 -f Dockerfile .
docker run --rm -d --name nginx01 -p 8000:80 marriprasanth/nginx:v1
docker ps 
docker exec -it nginx01 /bin/bash
exit
docker stop nginx01
docker ps 
docker ps -a
docker start nginx01
docker ps
```
- **Docker is stateless** data will lost when conatainer is stopped, it is a single point of failure. It can be over come by attaching volumes.
- How to delete stop and exit containers
```
docker run -d -p  8000:80 nginx:latest ( this will take random name )
docker run -d -p  8001:80 nginx:latest
docker run -d -p  8002:80 nginx:latest
docker ps
docker stop (names of container)
docker ps
docker ps -a
docker rm $(docker ps -aq)
```
- The above will consume space and will increase to overcome this we can use **--rm** command.
```
docker run --rm -d -p 8000:80 nginx:latest 
docker run --rm --name nginx01 8001:80 nginx:latest (with name)
docker run --rm -d -p 8002:80 nginx:latest
```

#### Creating my own custom image with necessary pacakges
- Creating `Dockerfile.utils` that contains following packages and tools
```
aws-cli
python3
nginx
curl
net-tools
wget
jq
terraform 
packer 
```
- I created the Dockerfile using instruction i used CMD nginx and push the image to my repository
```
docker build -t marriprasanth/uitls:v1 -f Dockerfile.utils .
docker images
docker run -d --name utils01 -p 8300:80 marriprasanth/uitls:v1 (without -d it wont exit)
docker psdocker exec -it utils01 /bin/bash
```
- open edge browser check the continer is running copy URL with 8300 extension, enter into the container and check the installation 
```
docker exec -it utils01 /bin/bash
ll
cd /usr/local/
ll (you can see aws-cli , lib (python))
exit
docker ps -a
docker login (gvie email and password)
docker images
docker tag marriprasanth/uitls:v1 dkutti/utils:v1
docker images
docker push dkutti/utils:v1
```
#### Interview Question
- what are the defalut network created when docker is installed
    - Bridge (similar to IGW), host and Null Network to see this `docker network ls`
- Docker swarm what network you can see
    - Ingress under scope `Overlay`
- Difference between RUN and CMD
    - RUN command is used to build the image, CMD is used to run the commands while running an image.
- Difference between CMD and entry point
    - CMD can edit during `docker run` but ENTRYPOINT can not accept edit.
- what are docker layers (32:07)
    - Dockerfile conatains set of instruction, when we perform the `docker build` to create an image some instruction like ADD (download and copy) files, COPY, RUN will create layers that can imapact the size of container. 
- Which instructions will create layers in the Dockerfile
    - ADD, COPY and RUN commands will create layers which creates an impact in the size of container.
- Difference between ARG and ENV
- 
- 12:15 Do you have idea on Docker and Kubernetes.
    - Yes i have knowledge on both, as you know most of the developers use docker for local testing. where as in production environment is running on kubernetes. 
- Difference between kill, stop and pause in docker
    - stop will release the memory, pause will keep the memory portion but not utilize CPU. Kill is hard stop command.

