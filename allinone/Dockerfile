# All-in-One Casebox Dockerfile
# Note: Dockerfile best practices (https://docs.docker.com/develop/develop-images/dockerfile_best-practices)
#       suggest do not use All-in-one containers, but we will just try follow
#       https://github.com/KETSE/casebox/wiki/Ubuntu-14.04-x64
#       instructions for now (fititnt, 2018-04-08 00:48 BRT)

FROM ubuntu:14.04
MAINTAINER "Emerson Rocha <rocha@ieee.org>"


# Install common software
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  curl \
  git \
  imagemagick \
  mailutils \
  sendmail \
  software-properties-common \
  wget \
  zip

# Install Redis server
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  redis-server


## NOTE: this command fails (fititnt, 2018-04-08 01:21 BRT)
## Install JAVA 8
#RUN add-apt-repository ppa:webupd8team/java && \
#  DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y oracle-java8-installer ca-certificates oracle-java8-set-default

# Install JAVA 8 (inspired on https://github.com/dockerfile/java/blob/master/oracle-java8/Dockerfile)
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer oracle-java8-set-default && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install LibreOffice
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  libreoffice-core \
  libreoffice-common \
  libreoffice-writer \
  libreoffice-script-provider-python
