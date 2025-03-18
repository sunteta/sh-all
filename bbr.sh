#!/bin/bash

# 适用于 Debian、Ubuntu、CentOS 的 BBR 优化脚本
# 请以 root 身份运行

set -e

# 检测是否为 root 用户
if [[ $EUID -ne 0 ]]; then
    echo "请以 root 用户运行此脚本。"
    exit 1
fi

# 确保系统支持 BBR
modprobe tcp_bbr || true
echo "tcp_bbr" | tee -a /etc/modules-load.d/bbr.conf

echo "net.core.default_qdisc=fq" | tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | tee -a /etc/sysctl.conf

# 添加 TCP 及网络优化参数
cat <<EOF >> /etc/sysctl.conf
fs.file-max = 2097152
net.netfilter.nf_conntrack_max = 524288
net.nf_conntrack_max = 524288

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 8192
net.core.somaxconn = 8192

net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15

net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864

net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_moderate_rcvbuf = 1

net.core.netdev_max_backlog = 250000
net.core.optmem_max = 25165824

net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 5

net.ipv4.tcp_abort_on_overflow = 0

net.ipv4.tcp_max_syn_backlog = 8192
net.core.somaxconn = 1024
net.ipv4.tcp_mem = 786432 2097152 3145728

net.ipv4.ipfrag_time = 22

net.ipv4.neigh.default.gc_stale_time = 120
net.ipv4.neigh.default.gc_interval = 30
net.ipv4.neigh.default.gc_thresh1 = 800
net.ipv4.neigh.default.gc_thresh2 = 4096
net.ipv4.neigh.default.gc_thresh3 = 8192
EOF

# 立即生效
sysctl -p

echo "BBR 及网络优化已应用成功！"
