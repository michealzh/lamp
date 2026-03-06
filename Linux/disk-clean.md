
## 查询占用空间大的目录
```sh
du -sh /* 2>/dev/null | sort -rh | head -10
```

## 查看具体的目录
```
du -sh /var/* 2>/dev/null | sort -rh | head -10
```
## 快速清理日志文件

```sh
truncate -s 0 /var/log/nginx/access.log /var/log/nginx/error.log
```
