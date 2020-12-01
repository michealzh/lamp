## selinux

```shell
# sestatus

SELinux status:                 disabled
```
### 测试环境关闭selinux
```shell
sudo setenforce 0
```
#### 永久关闭
```shell
vim /etc/selinux/config
修改:
SELINUX=disabled

重启
shutdown -r now
```
