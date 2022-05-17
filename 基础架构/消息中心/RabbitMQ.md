# Rabbitmq

> 官网 

## 安装 

> 注意：在 Centos 8 环境下安装最新 Rabbitmq。

使用 PackageCloud Yum 库安装

### 导入签名密钥

Yum 将验证它安装的任何包的签名，因此该过程的第一步是导入签名密钥：

``` shell
rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
rpm --import https://packagecloud.io/rabbitmq/erlang/gpgkey
rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
```

### 设置存储库

设置一个存储库，用于安装来自 PackageCloud 的 RabbitMQ 及其 Erlang 依赖：

``` shell
# In /etc/yum.repos.d/rabbitmq.repo

##
## Zero dependency Erlang
##

[rabbitmq_erlang]
name=rabbitmq_erlang
baseurl=https://packagecloud.io/rabbitmq/erlang/el/8/$basearch
repo_gpgcheck=1
gpgcheck=1
enabled=1
# PackageCloud's repository key and RabbitMQ package signing key
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_erlang-source]
name=rabbitmq_erlang-source
baseurl=https://packagecloud.io/rabbitmq/erlang/el/8/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
# PackageCloud's repository key and RabbitMQ package signing key
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

##
## RabbitMQ server
##

[rabbitmq_server]
name=rabbitmq_server
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/8/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
# PackageCloud's repository key and RabbitMQ package signing key
gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_server-source]
name=rabbitmq_server-source
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/8/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
```

### 具体安装

更新 Yum 包元数据

``` shell
yum update -y
yum -q makecache -y --disablerepo='*' --enablerepo='rabbitmq_erlang' --enablerepo='rabbitmq_server'
```

接着，从标准库中安装依赖项

``` shell
yum install socat logrotate -y
```

最后，安装现代的 Erlang 和 RabbitMQ

``` shell
yum install --repo rabbitmq_erlang --repo rabbitmq_server erlang rabbitmq-server -y
```

## 运行 Rabbitmq 服务器

安装RabbitMQ服务端包时，默认不启动服务端守护进程。默认情况下，在系统启动时，由管理员运行该守护进程

``` shell
chkconfig rabbitmq-server on
```

以管理员身份正常启动和停止服务器，例如使用 `service`:

``` shell
/sbin/service rabbitmq-server start

/sbin/service rabbitmq-server status

/sbin/service rabbitmq-server stop
```



## 配置

在大多数系统上，一个节点应该能够使用所有默认值启动和运行。有关开发环境之外的指导原则，请参阅[配置指南](https://www.rabbitmq.com/configure.html)和[产品检查表](https://www.rabbitmq.com/production-checklist.html)。

注意：该节点被设置为以系统用户 `rabbitmq` 运行。当[节点数据库或日志位置](https://www.rabbitmq.com/relocate.html)发生变化时，文件和目录必须归该用户所有。

RabbitMQ 节点绑定端口(开放的服务器TCP套接字)，以接受客户端和 CLI 工具连接。其他进程和工具(如SELinux)可能会阻止 RabbitMQ绑定到端口。当发生这种情况时，节点将无法启动。

CLI工具、客户端库和 RabbitMQ 节点也会打开连接(客户端TCP套接字)。防火墙可能阻止节点和CLI工具之间的通信。请确保以下端口是可访问的：

* 4369: epmd，由 RabbitMQ 节点和 CLI 工具使用的对等发现服务
* 5672、5671：用于AMQP 0-9-1和1.0客户端，不支持TLS协议和支持TLS协议
* 25672：用于节点间和 CLI 工具通信(Erlang分发服务器端口)，从动态范围内分配(默认限制为单个端口，计算为AMQP端口+ 20000)。除非真的需要在这些端口上进行外部连接(例如集群使用 [federation](https://www.rabbitmq.com/federation.html) 或在子网外的机器上使用CLI工具)，否则这些端口不应该公开。具体请参见[组网指南](https://www.rabbitmq.com/networking.html)。
* 35672-35682：用于 CLI 工具(Erlang分布式客户端端口)与节点通信，从动态范围(计算为服务器分布式端口+ 10000到服务器分布式端口+ 10010)中分配。具体请参见[组网指南](https://www.rabbitmq.com/networking.html)。
* 15672：[HTTP API](https://www.rabbitmq.com/management.html) 客户端，[管理UI](https://www.rabbitmq.com/management.html) 和 [rabbitmqadmin](https://www.rabbitmq.com/management-cli.html)(仅在[管理插件](https://www.rabbitmq.com/management.html)启用时)

可以 [配置RabbitMQ](https://www.rabbitmq.com/configure.html) 使用 [不同的端口和特定的网络接口](https://www.rabbitmq.com/networking.html)。

## 默认用户访问权限

broker 创建一个用户`guest`，密码为`guest`。未配置的客户端通常会使用这些认证信息。默认情况下，这些认证信息只能在作为本地主机连接到 broker 时使用，因此，在连接到任何其他机器之前，你需要采取行动。

有关如何创建更多用户和删除`guest`用户的信息，请参阅有关[访问控制](https://www.rabbitmq.com/access-control.html)的文档。

## 控制Linux上的系统限制

RabbitMQ安装运行生产负载可能需要系统限制和内核参数调优，以处理相当数量的并发连接和队列。需要调整的主要设置是打开文件的最大数量，也称为 `ulimit -n`。对于消息传递代理，许多操作系统上的默认值都过低(在几个Linux发行版上是 `1024`)。我们建议在生产环境中至少允许 `rabbitmq` 用户使用 65536 个文件描述符。4096 应该足够满足许多开发工作负载。

有两个限制：OS内核允许打开的文件的最大数量(`fs.file-max`)和每个用户的限制(`ulimit -n`)。前者必须高于后者。

在使用 `systemd` 的发行版上，操作系统的限制是通过配置文件 `/etc/systemd/system/rabbitmq-server.service.d/limits.conf` 来控制的。例如，设置最大打开文件句柄限制(`nofile`)为 `64000`：

``` shell
[Service]
LimitNOFILE=64000
```

请参阅 [systemd文档](https://www.freedesktop.org/software/systemd/man/systemd.exec.html) 了解支持的限制和其他指令。

