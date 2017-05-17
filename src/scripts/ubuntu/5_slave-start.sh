#!/bin/bash -xe

MASTER_NAME=${MASTER_NAME}
SST_PASSWORD=${SST_PASSWORD}

if [[ $(hostname -s) != $MASTER_NAME ]]; then
  systemctl start mariadb
  echo "Verfiy node is synced"
  while [[ $(MYSQL_PWD=$SST_PASSWORD mysql -u sst_user -e "SHOW STATUS LIKE 'wsrep_local_state_comment';"| tail -1 | awk '{print $2}') != 'Synced' ]]; do
    while ! systemctl is-active mariadb; do
      echo "MariaDB is not running! Starting..."
      systemctl start mariadb || true
      sleep 5
    done
    echo "Current node status: Not synced"
    sleep 5
  done
  echo "Current node status: Synced"
fi
