#!/bin/bash -xe

SST_PASSWORD=${SST_PASSWORD}

galera_new_cluster

while [[ $(MYSQL_PWD=$SST_PASSWORD mysql -u sst_user -e "SHOW STATUS LIKE 'wsrep_local_state_comment';"| tail -1 | awk '{print $2}') != 'Synced' ]]; do
  echo "Current node status: Not synced"
  sleep 5
done
