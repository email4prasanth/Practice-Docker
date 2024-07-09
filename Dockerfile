FROM ubuntu:20.04
LABEL owner="prasanth"
ARG VERSION="1.9.1"
RUN apt update
COPY index.html var/www/html/index.html
COPY style.css var/www/html/style.css
ADD scorekeeper.js var/www/html/scorekeeper.js
RUN apt install -y nginx unzip curl wget net-tools
ADD https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip /usr/local/bin/terraform.zip
RUN cd /usr/local/bin/ && unzip terraform.zip
RUN terraform version
EXPOSE 80
CMD ["nginx","-g","daemon off;"]

