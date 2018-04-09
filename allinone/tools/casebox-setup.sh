#!/bin/bash

echo "casebox-docker: /setup.sh is waiting..."

#sleep 10

echo "This script should be called at first time 'casebox-allinone' started"


RESULT=`mysqlshow --user=casebox --password="StrongPassword" casebox| grep -v Wildcard | grep -o casebox`
if [ "$RESULT" == "myDatabase" ]; then
    echo "casebox database exists"
else
    echo "casebox database do not exist. Creating one..."
fi