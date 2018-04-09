#!/bin/bash

#echo "casebox-docker: docker-entrypoiint.sh started"

# MySQL needs to be online to setup works
# /usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql --log-error=/var/log/mysql/error.log --pid-file=/var/run/mysqld/mysqld.pid --socket=/var/run/mysqld/mysqld.sock --port=3306

# TODO: check if MySQL database and Solr indexes where created, and if not, do it with our custom scripts (fititnt, 2018-08-08 07:18 BRT)

#echo "casebox-docker: /setup.sh..."

#bash /setup.sh

# TODO: check if casebox tables where created, and if not, import dump from maintainer repository (fititnt, 2018-08-08 07:18 BRT)

# TODO: store MySQL system data on some folder, like ./data/mysql (fititnt, 2018-08-08 07:26 BRT)


supervisord -n