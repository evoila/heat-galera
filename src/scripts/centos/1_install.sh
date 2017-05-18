#!/bin/bash

ROOT_PASSWORD=${ROOT_PASSWORD}

yum install -y mariadb-server-galera mariadb-client socat percona-xtrabackup

cp /usr/lib/systemd/system/mariadb.service /etc/systemd/system/
sed -i '/Group=mysql/ a\LimitNOFILE=65535' /etc/systemd/system/mariadb.service
systemctl daemon-reload
systemctl enable mariadb

# Start MariaDB to set root password
service mariadb start
sleep 5
mysqladmin -u root password "$ROOT_PASSWORD"

# Remove anonymous entries
cat << EOF | mysql -u root --password="$ROOT_PASSWORD"
DELETE FROM mysql.user WHERE User='';
FLUSH PRIVILEGES;
EXIT
EOF

service mariadb stop
