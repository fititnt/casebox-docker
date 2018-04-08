#!/bin/bash

# TODO: check if MySQL database and Solr indexes where created, and if not, do it with our custom scripts (fititnt, 2018-08-08 07:18 BRT)

# TODO: check if casebox tables where created, and if not, import dump from maintainer repository (fititnt, 2018-08-08 07:18 BRT)

# TODO: store MySQL system data on some folder, like ./data/mysql (fititnt, 2018-08-08 07:26 BRT)

supervisord -n