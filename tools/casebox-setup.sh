#!/bin/bash

echo "/tools/casebox-setup.sh: Starting. Wait some time for MySQL is running..."

# TODO: instead of a sleep, a good idea would be check when mysql is running (fititnt, 2018-04-09 01:23 BRT)

sleep 5 # Remove later this one (needs 1s to not scare supervisord default time) (fititnt, 2018-04-09 01:19 BRT)

RESULT=`mysqlshow --user=casebox --password="StrongPassword" cb__casebox| grep -v Wildcard | grep -o cb__casebox`
if [ "$RESULT" == "cb__casebox" ]; then
    echo "/tools/casebox-setup.sh: cb__casebox database exists"
else
    echo "/tools/casebox-setup.sh: cb__casebox database do not exist. Creating one..."
    bash -c /tools/init-database.sh
fi

RESULT=`mysqlshow --user=casebox --password="StrongPassword" cb__casebox| grep -v Wildcard | grep -o cb__casebox`
if [ "$RESULT" != "cb__casebox" ]; then
    echo "/tools/casebox-setup.sh: CRITICAL, cb__casebox still does not exist, and was not created"
    echo "/tools/casebox-setup.sh: casebox-docker will not work"
    exit 1
fi