#!/bin/bash

# Expected input parameters
ROOT_PASSWORD=${ROOT_PASSWORD}

function install_ubuntu {
  PASSWORD=$1
  OS_CODENAME=$(cat /etc/os-release | grep -e "^VERSION_CODENAME=" | cut -d "=" -f 2)

  apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
  add-apt-repository "deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu $OS_CODENAME main"
  apt-get update 

  debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
  debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
  apt-get install -y mariadb-server percona-xtrabackup
}

function install_redhat {
  echo "Not implemented yet."
  exit 1
  # mysqladmin -u root password $db_root_password
}

OS_ID=$(cat /etc/os-release | grep -E "^ID=" | cut -d "=" -f2)
if [ "$OS_ID" == "ubuntu" ]; then
  install_ubuntu $ROOT_PASSWORD
elif [ "$OS_ID" == "rhel" ]; then
  install_rhel $ROOT_PASSWORD
else
  echo "Operating system not supported. Abort."
  exit 1
fi

# We need MariaDB to be stopped in order to boostrap the Galera cluster later.

service mariadb stop
