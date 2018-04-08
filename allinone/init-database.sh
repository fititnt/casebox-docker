#!/bin/bash

mysql -u root -p -e "CREATE DATABASE casebox; CREATE USER 'casebox'@'localhost' IDENTIFIED BY 'StrongPassword'; GRANT ALL PRIVILEGES ON casebox.* TO 'casebox'@'localhost'; FLUSH PRIVILEGES;"