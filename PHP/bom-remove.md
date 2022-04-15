##  删除CSV 首行的 bom 字符 

```php
//打印字节码
print_r(unpack("H*",$k));

//移除 EFBBBF 
$bom = pack('H*', 'EFBBBF');
$k = preg_replace("/^$bom/", '', $k);
```
