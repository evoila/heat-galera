#!/bin/bash -xe

ROOT_PASSWORD=${ROOT_PASSWORD}
SST_PASSWORD=${SST_PASSWORD}

# MariaDB must be running to create the SST user. We will start is now and stop
# it after the user was created

systemctl start mariadb
sleep 5

cat << EOF | mysql -u root --password=$ROOT_PASSWORD
GRANT USAGE ON *.* to 'sst_user'@'localhost' IDENTIFIED BY "$SST_PASSWORD";
GRANT ALL PRIVILEGES on *.* to 'sst_user'@'localhost';
FLUSH PRIVILEGES;
EXIT
EOF

systemctl stop mariadb
