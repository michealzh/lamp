#!/bin/bash
PAKNAME='vim openssh-* wget lftp etuptool mlocate'
#Disable SeLinux
yum install wegt -y >>/dev/null
setenforce 0
if [ -s /etc/selinux/config ]; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    echo -e "\033[31m selinux is disabled,if you need,you must reboot.\033[0m"
fi


#Synchronization time
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#iptables config
cat > /etc/sysconfig/iptables << 'EOF'
# Firewall configuration written by system-config-securitylevel
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:RH-Firewall-1-INPUT - [0:0]
-A INPUT -j RH-Firewall-1-INPUT
-A FORWARD -j RH-Firewall-1-INPUT
-A RH-Firewall-1-INPUT -i lo -j ACCEPT
-A RH-Firewall-1-INPUT -p icmp --icmp-type any -j ACCEPT
-A RH-Firewall-1-INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT
-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
-A RH-Firewall-1-INPUT -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF
iptables-restore < /etc/sysconfig/iptables
service iptables save
service iptables restart

# modprobe config
modprobe ip_conntrack_ftp
if [ $? -eq 0 ]; then
    sed -i "/modprobe ip_conntrack_ftp/d" /etc/rc.d/rc.local
    echo "modprobe ip_conntrack_ftp" >> /etc/rc.d/rc.local
fi
modprobe ip_nat_ftp
if [ $? -eq 0 ]; then
    sed -i "/modprobe ip_nat_ftp/d" /etc/rc.d/rc.local
    echo "modprobe ip_nat_ftp" >> /etc/rc.d/rc.local
fi
modprobe bridge
if [ $? -eq 0 ]; then
    sed -i "/modprobe bridge/d" /etc/rc.d/rc.local
    echo "modprobe bridge" >> /etc/rc.d/rc.local
fi
# limit config
cat > /etc/security/limits.conf <<'EOF'
*               soft    nofile          65532
*               hard    nofile          65532
EOF

cat >/etc/security/limits.d/90-nproc.conf <<'EOF'
*          soft    nproc     65532
root       soft    nproc     unlimited
EOF

#dns  config
cp /etc/resolv.conf /etc/resolv.conf.bak
cat >/etc/resolv.conf <<'EOF'
nameserver 223.5.5.5
nameserver 223.6.6.6
EOF

cat > /etc/sysctl.conf << 'EOF'
net.ipv4.ip_forward = 0
net.ipv4.ip_nonlocal_bind = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl =15
net.ipv4.tcp_retries2 = 5
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_max_tw_buckets = 360000
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_wmem = 8192 131072 16777216
net.ipv4.tcp_rmem = 32768 131072 16777216
net.ipv4.tcp_mem = 786432 1048576 1572864
net.ipv4.ip_local_port_range = 1024 65000
net.nf_conntrack_max = 655360
net.netfilter.nf_conntrack_max = 655350
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
fs.file-max = 65535
EOF

yum install wget -y > /dev/null 2>&1
cd /etc/yum.repos.d/
if [ -z /etc/yum.repos.d/shopex-lnmp.repo ];then
	wget http://mirrors.shopex.cn/shopex/shopex-lnmp/shopex-lnmp.repo
else
	mv shopex-lnmp.repo shopex-lnmp.repo.bak
	wget http://mirrors.shopex.cn/shopex/shopex-lnmp/shopex-lnmp.repo
fi > /dev/null 2>&1
cd - > /dev/null 2>&1
#yum install epel-release yum-plugin-fastestmirror -y > /dev/null 2>&1 || true

#for e in $PAKNAME
#do 
#	rpm -q $e &> /dev/null 
#	[ $? -ne 0 ] && UNPKG="$UNPKG $e"  
#done 
#[ -n "$UNPKG" ] && yum install $UNPKG -y  
#echo "Dependent Packages install OK...." 



declare -a closelist
closelist=(
avahi-daemon
bluetooth
cups
firstboot
ip6tables
isdn
pcscd
rhnsd
yum-updatesd
pcscd
)

for((count=0,i=0;count<${#closelist[@]};i++))
do
    /sbin/chkconfig --list | grep ${closelist[i]}
    if [ $? -eq 0 ]; then
        cmd="/sbin/chkconfig ${closelist[i]} --level 3 off"
        echo $cmd
        `$cmd`
        /sbin/service ${closelist[i]} stop
    fi
    let count+=1
done > /dev/null 2>&1

grep "unset MAILCHECK" /etc/profile
if [ $? -ne 0 ]; then
    sed -i "/unset MAILCHECK/d" /etc/profile
    echo "unset MAILCHECK"  >> /etc/profile
fi
