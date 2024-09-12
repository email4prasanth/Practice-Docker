#### Docker+Portainer+Pgadmin4+Postgress+Wikijs
- video - https://www.youtube.com/watch?v=Dd8_plibBYk
- link1 - https://hub.docker.com/r/linuxserver/wikijs
- link2 - https://github.com/bmcgonag/docker_installs/blob/main/install_docker_nproxyman.sh
- link3 -Setting Up a PostgreSQL Database and pgAdmin with Docker Compose - https://blog.stackademic.com/setting-up-a-postgresql-database-and-pgadmin-with-docker-compose-ec8655854711
- **Postgress+Wikijs+Pgadmin4** - Usecase - Office needs a place to keep track of project plans, meeting notes, and team guidelines. 
- Wiki.js makes it easy to create and update content  and share your documents, 
- PostgreSQL ensures everything is securely stored and properly organized.
- Pgadmin4 is like a librarian which make easy to access
- Portainer helps you to manage all applications
- Docker packages all the above services.

#### Pre-requsites
- Ubuntu server -Lunch t2.medium
- Use putty login and install docker and docker-compose
- Run docker- compose file it will launch services Portainer, Pgadmin4, Postgress, Wikijs

#### Install docker
- create a user `brain` and give sudo permission 
```
sudo su - 
adduser brain (1234)
cat /etc/passwd
usermod -aG sudo brain
su - brain
mkdir docker
cd docker 
sudo apt update
sudo apt install -y wget net-tools curl net-tools jq unzip 
curl https://get.docker.com | bash
docker images
docker ps
logout ( you will in root usr)
docker images
docker ps (you will get output)
su - brain
sudo groupadd docker (If the group already exists, you'll see an error message)
sudo usermod -aG docker brain
logout
su - brain
docker images
docker ps
docker version
```
#### Install docker-compose
```
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```
- Creat docker-compose files to get the services now you are in user brain
```
cd docker/
ls 
nano docker-compose.wiki.yml
nano docker-compose.db.yml
nano docker-compose.portainer.yml
```
- Run the Portainer container, once the image is pulled copy the ubuntu `IPv4:9000` in edge browser you will find the portainer UI if you find cache just stop the container and start it again
```
docker-compose -f docker-compose.portainer.yml up -d
docker ps
```
- To launch the postgress use the folowing command, open the potrainer UI and refresh the container you will find the service add the environment variable ubuntu IPv4, click on pgadmin publish ports it will go to another UI
```
docker-compose -f docker-compose.db.yml up -d
```
- After login to the pgadmin UI give the postgress details db,test-database,root,mysecretpassword which is available in the `docker-compose.db.yml` file. Now we can containerize the wikijs image, click on wikijs-container published port you will reach another UI since IPv4 env variable is already there it will get open
```
docker-compose -f docker-compose.wiki.yml up -d
```
brain@fixdelrio.com, India@123456, https://wiki.mydomain.com

