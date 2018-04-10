#!/bin/bash

# TODO: This script needs update (fititnt, 2018-04-10 06:09 BRT)

CASEBOX_DATABSE_SEED1=install/mysql/bare_bone_core.sql
CASEBOX_DATABSE_SEED2=install/mysql/_casebox.sql

echo "/tools/init-database.sh: creating user and database"
mysql --host=mysql -u root -pStrongRootPassword -e "CREATE DATABASE casebox; CREATE USER 'casebox'@'localhost' IDENTIFIED BY 'StrongPassword'; GRANT ALL PRIVILEGES ON casebox.* TO 'casebox'@'localhost'; FLUSH PRIVILEGES;"
mysql --host=mysql -u root -pStrongRootPassword -e "CREATE DATABASE cb__casebox; GRANT ALL PRIVILEGES ON cb__casebox.* TO 'casebox'@'localhost'; FLUSH PRIVILEGES;"

# NOTE: this command from (https://github.com/KETSE/casebox/wiki/Ubuntu-14.04-x64) does not work. I will use another SQL dump (fititnt, 2018-04-09 01:27 BRT)
# mysql -u root -p casebox < /var/www/casebox/var/backup/cb_default.sql

echo "/tools/init-database.sh: importing /var/www/casebox/$CASEBOX_DATABSE_SEED1"
mysql --host=mysql -u root -pStrongRootPassword cb__casebox < "/var/www/casebox/$CASEBOX_DATABSE_SEED1"

echo "/tools/init-database.sh: importing /var/www/casebox/$CASEBOX_DATABSE_SEED2"
mysql --host=mysql -u root -pStrongRootPassword casebox < "/var/www/casebox/$CASEBOX_DATABSE_SEED2"

echo "/tools/init-database.sh: done"