# 使用 Sysbench 进行基准测试

> https://github.com/guoyufu-study/sysbench

## 安装

### 安装 mysql 8

> 具体步骤参见：[使用 MySQL APT 存储库在 Linux 上安装 MySQL](数据存储/MySQL8/MySQL-Server-参考手册/安装和升级/在Linux上安装MySQL/)

``` shell
sudo apt-get install mysql-server
```

### 安装 Sysbench

> 此处选择编译安装

先安装一些工具：

``` shell
sudo apt-get install make automake libtool \
				pkg-config libaio-dev \
				openssl libssl-dev
```

> 注意：
>
> 还需要安装 `libmysqlclient-dev`：
>
> ``` shell
> sudo apt-get install libmysqlclient-dev
> ```

从 GitHub 存储库复制 sysbench：

``` shell
git clone https://github.com/guoyufu-study/sysbench.git
```

配置、编译，并安装

``` shell
./autogen.sh
./configure
make -j
sudo make install
```

## 执行基准测试

准备 myql 用户，以及 `sbtest` schema：

``` shell
mysql -u root -p
# 输入密码

create user sbtest@localhost identified by 'passwd';
grant all on sbtest.* to sbtest@localhost;
create schema sbtest;
```



准备测试：

``` shell
sysbench oltp_read_only \
	--mysql-host=127.0.0.1 \
	--mysql-port=3306 \
	--mysql-user=sbtest \
	--mysql-password=passwd \
	--mysql-ssl=REQUIRED \
	--mysql-db=sbtest \
	--table_size=20000 \
	--tables=4 \
	--threads=4 \
	prepare
```



预热：

``` shell
sysbench oltp_read_only \
		--mysql-host=127.0.0.1 \
		--mysql-port=3306 \
		--mysql-user=sbtest \
		--mysql-password=passwd \
		--mysql-ssl=REQUIRED \
		--mysql-db=sbtest \
		--table_size=200000 \
		--tables=4 \
		--threads=4 \
		warmup
```

执行测试：

``` shell
sysbench oltp_read_only \
		--mysql-host=127.0.0.1 \
		--mysql-port=3306 \
		--mysql-user=sbtest \
		--mysql-password=passwd \
		--mysql-ssl=REQUIRED \
		--mysql-db=sbtest \
		--table_size=200000 \
		--tables=4 \
		--time=60 \
		--threads=8 \
		run
```

清理：

``` shell
sysbench oltp_read_only \
		--mysql-host=127.0.0.1 \
		--mysql-port=3306 \
		--mysql-user=sbtest \
		--mysql-password=passwd \
		--mysql-ssl=REQUIRED \
		--mysql-db=sbtest \
		--table_size=200000 \
		--tables=4 \
		cleanup
```

