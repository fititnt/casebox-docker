# Dockerfile for CaseBox V1, huridocs/casebox fork
# It uses supervisord to manange run and check health of multiple applications
# inside a same docker container, something that could be used when you do not
# have time to optimize or even rewrite part of the application to play nicier
# with docker.
#
# Note: Dockerfile best practices (https://docs.docker.com/develop/develop-images/dockerfile_best-practices)
#       suggest do not use All-in-one containers, but we will just try follow
#       https://github.com/KETSE/casebox/wiki/Ubuntu-14.04-x64
#       instructions for now (fititnt, 2018-04-08 00:48 BRT)
#
# Note: Last note was for CaseBox V1. The public documentation that provably
#       is for V1 branch is https://www.casebox.org/dev/install/
#       (fititnt, 2018-04-13 06:10)

FROM ubuntu:14.04
MAINTAINER "Emerson Rocha <rocha@ieee.org>"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  curl \
  git \
  imagemagick \
  lsof \
  mailutils \
  mysql-client \
  sendmail \
  supervisor \
  software-properties-common \
  wget \
  zip

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

## Install unoconv
RUN git clone http://github.com/dagwieers/unoconv.git /tmp/unoconv && \
  cd /tmp/unoconv && \
  make install && \
  make install

ADD ./etc/init.d/unoconvd /etc/init.d/unoconvd

RUN chmod +x /etc/init.d/unoconvd && service unoconvd start && update-rc.d unoconvd defaults

## Install Solr
RUN cd /tmp && \
  wget http://archive.apache.org/dist/lucene/solr/6.0.1/solr-6.0.1.tgz && \
  tar xzf solr-6.0.1.tgz solr-6.0.1/bin/install_solr_service.sh --strip-components=2 && \
  ./install_solr_service.sh solr-6.0.1.tgz

# Prepare supervisord
ADD ./etc/supervisor/conf.d/ /etc/supervisor/conf.d

### TODO: replace NGinx with Apache (fititnt, 2018-04-10 04:22 BRT)

## Install Nginx
#RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
#  nginx \
#  && rm /etc/nginx/sites-enabled/default \
#  && service nginx restart

## Install PHP7

# Locale fix (used at least by PHP7)
#RUN locale-gen en_US.UTF-8
#ENV LANG en_US.UTF-8
#ENV LANGUAGE en_US:en
#ENV LC_ALL en_US.UTF-8

#RUN \
#  export LANGUAGE=en_US.UTF-8 && \
#  export LANG=en_US.UTF-8 && \
#  export LC_ALL=en_US.UTF-8 \
#  && add-apt-repository ppa:ondrej/php && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
#  php7.0-cli \
#  php7.0-cgi \
#  php7.0-dev \
#  php7.0-fpm \
#  php7.0-json \
#  php7.0-tidy \
#  php7.0-curl \
#  php7.0-mbstring \
#  php7.0-bcmath \
#  php7.0-common \
#  php7.0-mysql \
#  php-imagick \
#  php7.0-xml \
#  php-mysql \
#  php7.0-mysql

# Need for creation of php-fpm socket. TODO reorganize order in this file later (fititnt, 2018-04-08 03:39 BRT)
#RUN mkdir -p /var/run/php

## Install composer
# RUN \
#  cd /tmp \
#  && curl -sS https://getcomposer.org/installer | php \
#  && mv composer.phar /usr/local/bin/composer

## Add CaseBox to NGinx
# ADD ./etc/nginx/sites-available/http_casebox.conf /etc/nginx/sites-available/http_casebox.conf
## ADD ./etc/nginx/sites-available/https_casebox.conf /etc/nginx/sites-available/https_casebox.conf
# RUN ln -s /etc/nginx/sites-available/http* /etc/nginx/sites-enabled/

## TODO: Re-enable git clone and composer update inside this container, or at least
#        use docker multisteps for this (fititnt, 2018-04-13 06:25 BRT)

## Install apache & PHP
# This should be moved at start of this Dockerfile to reduce docker layers
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  apache2 \
  php5 \
  php5-mysql \
  php5-mcrypt \
  libapache2-mod-php5

## Clone CaseBox app
# RUN git clone https://github.com/huridocs/casebox.git /var/www/casebox/
COPY casebox /var/www/casebox/

## 
# Composer update CaseBox vendor packages
# RUN cd /var/www/casebox && composer update ## Please run composer update inside the casebox/* on your host with some PHP installed on your host at this moment

## Add Solr CaseBox configsets
RUN \
  mkdir -p /var/solr/data/configsets/ \
  && ln -s /var/www/casebox/var/solr/default /var/solr/data/configsets/casebox \
  && ln -s /var/www/casebox/var/solr/log/ /var/solr/data/configsets/casebox_log \
  && chown solr:solr -R /var/solr/data/configsets/

COPY ./tools/ /tools
COPY ./etc/apache2/mods-enabled/dir.conf /etc/apache2/mods-enabled/dir.conf
COPY ./etc/apache2/sites-enabled/casebox.conf /etc/apache2/sites-enabled/casebox.conf
COPY ./config.ini /var/www/casebox/httpsdocs/config.ini

WORKDIR /
COPY docker-entrypoint.sh /docker-entrypoint.sh

#RUN ls -lha /var/www/
#RUN ls -lha /var/www/casebox
#RUN ls -lha /var/www/casebox/logs/
#RUN chmod 777 /var/www/casebox/logs/

ENTRYPOINT ["/docker-entrypoint.sh"]
