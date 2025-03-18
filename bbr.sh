#!/bin/bash

# 适用于 Debian、Ubuntu、CentOS 的 BBR 优化脚本
# 请以 root 身份运行

set -e

# 检测是否为 root 用户
if [[ $EUID -ne 0 ]]; then
    echo -e "\e[31m[错误] 请以 root 用户运行此脚本。\e[0m"
    exit 1
fi
echo -e "\e[32m[✔] Root 权限检测通过\e[0m"

# 确保系统支持 BBR
if modprobe tcp_bbr 2>/dev/null; then
    echo "tcp_bbr" | tee -a /etc/modules-load.d/bbr.conf
    echo -e "\e[32m[✔] BBR 支持已确认\e[0m"
else
    echo -e "\e[31m[×] 当前系统可能不支持 BBR\e[0m"
fi

# 写入 BBR 及 TCP 优化参数
echo "net.core.default_qdisc=fq" | tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | tee -a /etc/sysctl.conf

cat <<EOF >> /etc/sysctl.conf
fs.file-max = 2097152

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
echo -e "\e[32m[✔] TCP 优化参数写入完成\e[0m"

# 检查 nf_conntrack 是否可用
if [[ -f /proc/sys/net/netfilter/nf_conntrack_max ]]; then
    echo "net.netfilter.nf_conntrack_max=524288" | tee -a /etc/sysctl.conf
    echo "net.nf_conntrack_max=524288" | tee -a /etc/sysctl.conf
    echo -e "\e[32m[✔] nf_conntrack 参数已启用\e[0m"
else
    echo -e "\e[33m[！] nf_conntrack 不可用，跳过相关设置\e[0m"
fi

# 立即生效
sysctl -p

echo -e "\e[32m[✔] BBR 及网络优化已成功应用！\e[0m"
