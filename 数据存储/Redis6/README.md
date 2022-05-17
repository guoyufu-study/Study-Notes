# Redis

## 安装

安装在 `/usr/local/redis` 目录下。

``` shell
mkdir /usr/local/redis
cd !*
```



### 最新版本

官方文档 https://redis.io/topics/quickstart

``` shell
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
make test
make install
```

> 执行 `make` 前，需要先安装 `make` 和 `gcc`
>
> ``` shell
> yum install make gcc
> ```
>
> 执行 `make test` 前，需要先安装 `tcl`
>
> ``` shell
> yum install tcl
> ```
>
> 如果编译过程中报错，需要先执行 `make distclean` 清理，再重新 `make`。

### 5.0.3 版本

``` shell
wget http://download.redis.io/releases/redis-5.0.3.tar.gz
tar zxf redis-5.0.3.tar.gz
cd redis-5.0.3/
make 
make test
make install
```

### 开放端口

``` shell
firewall-cmd --add-port=6379/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-ports
```



## 启动

``` shell
redis-server
```

> 启动前，修改配置文件 `redis.conf`。
>
> ``` shell
> vim redis.conf
> ```
>
> 在开发环境，不必考虑安全问题，直接注释掉 `bind 127.0.0.1`即可。另外设置密码，取消注释 `requirepass foobared`。

## 客户端

[uglide/RedisDesktopManager: Cross-platform GUI management tool for Redis](https://github.com/uglide/RedisDesktopManager)

[qishibo/AnotherRedisDesktopManager: A faster, better and more stable redis desktop manager \[GUI client\], compatible with Linux, Windows, Mac. What's more, it won't crash when loading massive keys.](https://github.com/qishibo/AnotherRedisDesktopManager) **推荐**

[Redis Assistant - Redis可视化管理与监控工具](http://www.redisant.cn/)





