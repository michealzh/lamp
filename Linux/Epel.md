### install epel repo

```shell
# yum search epel-release
# yum info epel-release
# yum install epel-release

# 查看repo
yum repolist
yum --disablerepo="*" --enablerepo="epel" list available | grep 'htop'
```
