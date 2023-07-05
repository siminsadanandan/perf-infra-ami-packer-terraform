#!/bin/sh

# Script to increase the open file handles to accept more connections
# and tune the TCP stack to increase the backlog queue, reuse the connection,
# reclaim the TIME_WAIT sockets quicker etc
# Reduce the swapping, change threshold to 5 from the default 60
# which triggers swapping only if the free memory reaches 10%
# Reference: https://levelup.gitconnected.com/linux-kernel-tuning-for-high-performance-networking-high-volume-incoming-connections-196e863d458a


# Perf tunings, increase the open files limit for all users in /etc/security/limits.conf
# not a best practice, consider applying this limit to the specific user
# that is used for running the test
echo "# Perf tunings added below" | sudo tee -a /etc/security/limits.conf > /dev/null
echo "* soft  nofile  65536" | sudo tee -a /etc/security/limits.conf > /dev/null
echo "* hard  nofile  65536" | sudo tee -a /etc/security/limits.conf > /dev/null
echo "* soft  nproc   65536" | sudo tee -a /etc/security/limits.conf > /dev/null
echo "* hard  nproc   65536" | sudo tee -a /etc/security/limits.conf > /dev/null

# Perf tunings, add/change TCP/swapping settings in /etc/sysctl.conf

echo '# Perf tunings added below' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.core.somaxconn = 65535' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.core.netdev_max_backlog = 300000' | sudo tee -a /etc/sysctl.conf > /dev/null
# This is to increase the ephemeral port range, the default value is
# 49152 to 65535, so increasing the limit can create connecivity issue with
# some filewall application/appliance
# echo 'net.inet.ip.portrange.first = 32768' | sudo tee -a /etc/sysctl.conf > /dev/null
# Consider this tuning only if other options are exhausted
# echo 'net.ipv4.tcp_syn_retries = 1' | sudo tee -a /etc/sysctl.conf > /dev/null
# echo 'net.ipv4.tcp_synack_retries = 1' | sudo tee -a /etc/sysctl.conf > /dev/null
# echo 'net.ipv4.tcp_fin_timeout = 5' | sudo tee -a /etc/sysctl.conf > /dev/null

echo 'net.ipv4.ip_local_port_range = 2048 64000' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_max_syn_backlog = 65535' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_slow_start_after_idle = 0' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_window_scaling = 1' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_no_metrics_save = 1' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_fin_timeout = 15' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_keepalive_probes = 2' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_keepalive_intvl = 20' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_keepalive_time = 300' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_tw_reuse = 1' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_timestamps=1' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_sack = 1' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_dsack = 0' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'net.ipv4.tcp_syncookies = 0' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'vm.swappiness = 0' | sudo tee -a /etc/sysctl.conf > /dev/null
echo 'kernel.threads-max=3261780' | sudo tee -a /etc/sysctl.conf > /dev/null
sudo sed -i '/# end of pam-auth-update config/i session required pam_limits.so' /etc/pam.d/common-session

sudo sysctl -p /etc/sysctl.conf > /dev/null 2>&1
