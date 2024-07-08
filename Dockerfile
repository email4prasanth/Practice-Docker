FROM ubuntu:20.04
LABEL owner="prasanth"
ARG VERSION="1.9.1"
RUN apt update
COPY index.html var/www/html/index.html
RUN apt install -y unzip curl wget net-tools
RUN cd /usr/local/bin
ADD https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip terraform.zip
RUN unzip terraform.zip && rm -rf *.zip
