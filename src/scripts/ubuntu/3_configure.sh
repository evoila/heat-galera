#!/bin/bash

# Expected parameters

SERVER_ADDRESSES=${SERVER_ADDRESSES}
SST_PASSWORD=${SST_PASSWORD}

# Figure out configuration file path depending on distribution

OS_ID=$(cat /etc/os-release | grep -E "^ID=" | cut -d "=" -f2)

if [ "$OS_ID" == "ubuntu" ]; then
  CONFIG_PATH="/etc/mysql/conf.d"
elif [ "$OS_ID" == "redhat" ]; then
  CONFIG_PATH="/etc/my.cnf.d"
else
  echo "Operating system not supported. Abort."
  exit 1
fi

GALERA_CONFIG_FILE="$CONFIG_PATH/galera.cnf"


# Write galera configuration

cat > $GALERA_CONFIG_FILE <<EOF
[galera]
wsrep_on                       = ON
wsrep_provider                 = /usr/lib/libgalera_smm.so
wsrep_provider_options         = "gcache.size=5G"
wsrep_cluster_address          = gcomm://$(echo $SERVER_ADDRESSES | tr -d "[]u' ")
binlog_format                  = ROW
default_storage_engine         = InnoDB
bind-address                   = 0.0.0.0
wsrep_slave_threads            = 1
wsrep_certify_nonPK            = 1
wsrep_max_ws_rows              = 131072
wsrep_max_ws_size              = 1073741824
wsrep_debug                    = 0
wsrep_convert_LOCK_to_trx      = 0
wsrep_retry_autocommit         = 1
wsrep_auto_increment_control   = 1
wsrep_causal_reads             = 0
wsrep_sst_method               = xtrabackup-v2
wsrep_sst_auth                 = sst_user:$SST_PASSWORD
EOF
