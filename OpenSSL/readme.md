### 生成pkcs1 秘钥
```
openssl genrsa -out private.pem 1024
```

### pkcs1 to pkcs8
```
openssl pkcs8 -topk8 -inform PEM -in private.pem -outform pem -nocrypt -out pkcs8.pem
```

### pkcs8 to pkcs1
```
openssl rsa -in pkcs8.pem -out pkcs1.pem
```

### pkcs1 生成pkcs8公钥
```
openssl rsa -in private.pem -pubout -out public.pem
```

### pkcs8 秘钥生成pkcs8公钥
```
openssl rsa -pubin -in public.pem -RSAPublicKey_out
```

### pkcs8 公钥 转pkcs1 公钥
```
openssl rsa -pubin -in public.pem -RSAPublicKey_out
```

### pkcs1 公钥 转pkcs8 公钥
```
openssl rsa -RSAPublicKey_in -in pub_pkcs1.pem -pubout
```
