
```shell

cat /proc/sys/kernel/random/entropy_avail

yum install rng-tools  -y

echo '''# Add extra options here
EXTRAOPTIONS="-r /dev/urandom" 
 ''' > /etc/sysconfig/rngd
 
 
systemctl start rngd.service && systemctl enable rngd.service


```
