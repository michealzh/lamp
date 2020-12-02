# Go 编译二进制文件压缩
## 指定编译参数
```shell
# -s 的作用是去掉符号信息。-w 的作用是去掉调试信息。
# 
go build -ldflags "-s -w" -o outputFileName main.go 
```

## 对二进制文件进行UPX 压缩

```shell
# -o 指定压缩后的文件名。-9指定压缩级别，1-9。
upx -9 -o main-upx main-ldflags
```
