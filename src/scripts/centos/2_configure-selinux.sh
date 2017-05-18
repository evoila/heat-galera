#!/bin/bash -xe

cat > /tmp/MySQL_galera.te <<EOF
module MySQL_galera 1.0;

require {
  type unconfined_t;
  type unlabeled_t;
  type init_t;
  type initrc_tmp_t;
  type system_cronjob_t;
  type mysqld_t;
  type syslogd_t;
  type NetworkManager_t;
  type system_dbusd_t;
  type tuned_t;
  type dhcpc_t;
  type irqbalance_t;
  type kerberos_port_t;
  type kernel_t;
  type sysctl_net_t;
  type auditd_t;
  type udev_t;
  type systemd_logind_t;
  type chronyd_t;
  type policykit_t;
  type gssproxy_t;
  type postfix_pickup_t;
  type sshd_t;
  type crond_t;
  type getty_t;
  type postfix_qmgr_t;
  type postfix_master_t;
  type unconfined_service_t;
  type initrc_t;  
  class process { getattr setpgid };
  class system module_request;
  class netlink_tcpdiag_socket { bind create setopt nlmsg_read getattr };
  class tcp_socket name_bind;
  class unix_stream_socket connectto;
  class dir { write remove_name add_name search rmdir };
  class file { read lock create write getattr unlink open append rename };
  class sock_file { create unlink };
}

#============= mysqld_t ==============
allow mysqld_t initrc_tmp_t:file open;
allow mysqld_t initrc_t:process getattr;
allow mysqld_t unconfined_service_t:process getattr;
allow mysqld_t NetworkManager_t:process getattr;
allow mysqld_t auditd_t:process getattr;
allow mysqld_t chronyd_t:process getattr;
allow mysqld_t crond_t:process getattr;
allow mysqld_t dhcpc_t:process getattr;
allow mysqld_t getty_t:process getattr;
allow mysqld_t gssproxy_t:process getattr;
allow mysqld_t init_t:process getattr;
allow mysqld_t irqbalance_t:process getattr;
allow mysqld_t unlabeled_t:dir { write remove_name add_name rmdir };
allow mysqld_t unlabeled_t:file { read lock create write getattr unlink open append rename };
allow mysqld_t unlabeled_t:sock_file { create unlink };

#!!!! This avc can be allowed using the boolean 'nis_enabled'
allow mysqld_t kerberos_port_t:tcp_socket name_bind;
allow mysqld_t self:unix_stream_socket connectto;
allow mysqld_t kernel_t:process getattr;

#!!!! This avc can be allowed using the boolean 'domain_kernel_load_modules'
allow mysqld_t kernel_t:system module_request;
allow mysqld_t policykit_t:process getattr;
allow mysqld_t postfix_master_t:process getattr;
allow mysqld_t postfix_pickup_t:process getattr;
allow mysqld_t postfix_qmgr_t:process getattr;
allow mysqld_t self:netlink_tcpdiag_socket { bind create setopt nlmsg_read getattr };
allow mysqld_t self:process setpgid;
allow mysqld_t sshd_t:process getattr;
allow mysqld_t sysctl_net_t:dir search;
allow mysqld_t sysctl_net_t:file { read getattr open };
allow mysqld_t syslogd_t:process getattr;
allow mysqld_t system_cronjob_t:process getattr;
allow mysqld_t system_dbusd_t:process getattr;
allow mysqld_t systemd_logind_t:process getattr;
allow mysqld_t tuned_t:process getattr;
allow mysqld_t udev_t:process getattr;
allow mysqld_t unconfined_t:process getattr;
EOF

checkmodule -M -m /tmp/MySQL_galera.te -o /tmp/MySQL_galera.mod
semodule_package -m /tmp/MySQL_galera.mod -o /tmp/MySQL_galera.pp
semodule -i /tmp/MySQL_galera.pp
