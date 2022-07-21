

```shell

cat /etc/selinux/config
vi /etc/selinux/config

#SELINUX=enforce 
SELINUX=disabled

/usr/sbin/sestatus -v
#SELinux status: enabled 代表开启

getenforce


setenforce 0 #设置SELinux 成为permissive模式 
#setenforce 1 设置SELinux 成为enforcing模式


systemctl stop firewalld.service

# 开启反向代理
setsebool httpd_can_network_connect 1
