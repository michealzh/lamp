- PHP api接口Linux环境只需要300ms但是在macOS上面部署的docker环境中运行缺需要20s+
  - 原因: docker虚拟化文件挂载采用的是osxfs导致文件读取慢, [参考](https://forums.docker.com/t/file-access-in-mounted-volumes-extremely-slow-cpu-bound/8076/158)
  - [osxfs介绍](https://docs.docker.com/docker-for-mac/osxfs/#performance-issues-solutions-and-roadmap)

#### 解决方法
- vagrant(依赖于virtualbox) 创建Linux虚拟机,在虚拟机中运行docker,文件同步采用nfs方式挂载映射本地目录
- docker 
- docker-sync

#### docker-sync

- [官网](http://docker-sync.io/)
- 使用说明
```shell
$ gem install docker-sync
$ brew install fswatch
$ brew install unison
$ brew install eugenmayer/dockersync/unox
$ docker-sync start
```

##### 在启动前需要在待同步的目录或者启动的目录新增 docker-sync.yml
```
version: '2'

options:
  verbose: false

syncs:
  unison-sync:
    # 需要挂载的目录
    src: '/path/to/app'
    # 同步策略 macOS 推荐 native_osx，Windows 配置为 unison
    sync_strategy: native_osx
    # 这里的用户 ID 为 1000，请确认你的 php-fpm 为同一个用户,这里有个坑,需要在目标的docker环境中确定目录宿主用户的id放到配置文件中才可以,否则文件的用户会变成id值
    sync_userid: 1000
    # 忽略的文件
    sync_excludes: [
      '.gitignore',
      '.git/',
      '.DS_Store',
    ]
```

#### docker-compose.yml 修改
```
version: "3"

# 新增挂载卷
volumes:
  unison-sync:
    external: true

services:
  nginx:
    image: nginx:${NGINX_VERSION}
    ports:
      - "${NGINX_HTTP_HOST_PORT}:80"
      - "${NGINX_HTTPS_HOST_PORT}:443"
    volumes:
      # 此处使用挂载卷作为源, !!!注意末尾的nocopy一定不能漏掉了
      - unison-sync:/var/www/html/:nocopy
      - ${NGINX_CONFD_DIR}:/etc/nginx/conf.d/:rw
      - ${NGINX_CONF_FILE}:/etc/nginx/nginx.conf:ro
      - ${NGINX_LOG_DIR}:/var/log/nginx/:rw
    restart: always
    networks:
      default:
        ipv4_address: 10.0.0.10
```

#### 启动docker-compose
```
docker-compose up -d
```
#### 使用感受
- 使用docker-sync 后curl请求从20000ms降到了200ms左右和Linux原生环境相差不大
- docker-sync 在执行 start 启动以后,会自动切换到后台执行,本地使用情况下会偶尔出现文件修改了,但是docker目标容器里面的文件没有更新的情况,可以稍微等1s左右或者手动只是 `docker-sync sync` 手动同步文件
- macOS环境下,docker-sync的同步策略 `sync_strategy` 推荐的是`native_osx`,但是使用下来好像文件同步没生效,后面改成`unison`就好了,这个问题又空再研究吧

#### 遇到的问题
- 如果遇到报错 `install unox fail, `:using => "python@x.y"` #754` 参考下面修复:

```
#ref https://github.com/EugenMayer/docker-sync/issues/754
I found a solution.
using "brew edit unox"
modify depends_on "python@3" to depends_on "python@3.8"
then run "brew install -s unox" or "brew install --build-from-source unox" can install now
```

- 如果遇到 docker-sync 报错命令未找到,尝试执行以下命令

```shell
export PATH=$PATH:~/.gem/ruby/2.7.0/bin
```

#### 参照说明
- https://blog.wangmao.me/use-docker-sync-for-macos.html
