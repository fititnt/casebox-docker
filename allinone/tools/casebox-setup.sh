#!/bin/bash

echo "/casebox-setup.sh: waiting..."

sleep 5

RESULT=`mysqlshow --user=casebox --password="StrongPassword" casebox| grep -v Wildcard | grep -o casebox`
if [ "$RESULT" == "myDatabase" ]; then
    echo "/casebox-setup.sh: casebox database exists"
else
    echo "/casebox-setup.sh: casebox database do not exist. Creating one..."
fi