#!/bin/bash -xe

SST_PASSWORD=${SST_PASSWORD}

echo "Running galera_new_cluster ..."
galera_new_cluster

echo "Waiting for master to be ready ..."
while [[ $(MYSQL_PWD=$SST_PASSWORD mysql -u sst_user -e "SHOW STATUS LIKE 'wsrep_local_state_comment';"| tail -1 | awk '{print $2}') != 'Synced' ]]; do
  echo "Current node status: Not synced"
  sleep 5
done
