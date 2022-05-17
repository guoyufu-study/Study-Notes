# RocketMQ

## 单机测试

### 快速安装

> 官方参考文档 
>
> * [快速安装](https://rocketmq.apache.org/docs/quick-start/)
> * [下载说明](https://rocketmq.apache.org/dowloading/releases/)

#### 环境准备

* 64 位 Linux 、CentOS 8 操作系统
* JAVA  8+

``` shell
[root@centos802 ~]# uname -a
Linux centos802.localdomain 4.18.0-348.2.1.el8_5.x86_64 #1 SMP Tue Nov 16 14:42:35 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
[root@centos811 ~]# java -version
openjdk version "1.8.0_312"
OpenJDK Runtime Environment (Temurin)(build 1.8.0_312-b07)
OpenJDK 64-Bit Server VM (Temurin)(build 25.312-b07, mixed mode)
```

> 如果使用源码版安装，还需要 maven 和 git 

RocketMQ 的安装非常简单，就是下载解压就可以了。

#### 防火墙

确保防火墙开启，并开放端口 `9876` （mqnamesrv默认端口）、`10911`（mqbroker默认端口）

``` shell
systemctl status firewalld.service
systemctl start firewalld.service

firewall-cmd --add-port=9876/tcp --permanent
firewall-cmd --add-port=10911/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-ports
```

#### 下载并验证

```shell
mkdir -p /app/rocketmq
cd /app/rocketmq
wget --progress dot:giga https://www.apache.org/dist/rocketmq/KEYS;
wget https://www.apache.org/dist/rocketmq/4.9.2/rocketmq-all-4.9.2-bin-release.zip.asc
wget https://dlcdn.apache.org/rocketmq/4.9.2/rocketmq-all-4.9.2-bin-release.zip
gpg --import KEYS
gpg --verify rocketmq-all-4.9.2-bin-release.zip.asc rocketmq-all-4.9.2-bin-release.zip
```

> 参考 https://github.com/apache/rocketmq/issues/3445

#### 解压并配置

我们把下载的 `rocketmq-all-4.9.2-bin-release.zip` 解压到`/app/rocketmq`目 录。

``` shell
unzip rocketmq-all-4.9.2-bin-release.zip
cd rocketmq-4.9.2/
```

完成后，把`rocketmq`的`bin`目录也配置到环境变量当中。创建`/etc/profile.d/rocketmq.sh`文件，加入以下内容，并执 行`source ~/.bash_profile`让环境变量生效：

``` shell
cat /etc/profile.d/rocketmq.sh 
# ROCKETMQ 主目录
if [ -d /app/rocketmq/rocketmq-4.9.2 ]; then
	export ROCKETMQ_HOME=/app/rocketmq/rocketmq-4.9.2
	PATH=$PATH:$ROCKETMQ_HOME/bin
	export PATH
fi
```

这样 RocketMQ 就安装完成了。我们把他运行起来。

> 这个`ROCKETMQ_HOME`的环境变量是必须要单独配置的，如果不配置的话，启动NameSever和 Broker都会报错。 
>
> 这个环境变量的作用是用来加载`$ROCKETMQ_HOME/conf`下的除`broker.conf`以外的几个配置文 件。所以实际情况中，可以不按这个配置，但是一定要能找到配置文件。

### 快速运行

运行之前，我们需要对RocketMQ的组件结构有个大致的了解。 

RocketMQ由以下这几个组件组成

* NameServer : 提供轻量级的Broker路由服务。 
* Broker：实际处理消息存储、转发等服务的核心组件。 
* Producer：消息生产者集群。通常是业务系统中的一个功能模块
* Consumer：消息消费者集群。通常也是业务系统中的一个功能模块。

所以我们要启动RocketMQ服务，需要先启动NameServer。

#### 启动 NameServer

启动NameServer非常简单， 在`$ROCKETMQ_HOME/bin`目录下有个`mqadminsrv`。直接执行这个脚本就可以启动`RocketMQ`的`NameServer`服务。 

> 虚拟机环境
>
> 注意 `RocketMQ` 默认预设的JVM内存是4G，这是`RocketMQ`给我们的最佳配置。但是通常我们用虚拟机的话都是不够4G内存的，所以需要调整下JVM内存大小。修改的方式是直接修改 `runserver.sh`。 用`vim runserver.sh`编辑这个脚本，在脚本中找到相应行调整内存大小为512M
>
> ``` shell
> JAVA_OPT="${JAVA_OPT} -server -Xms512m -Xmx512m -Xmn256m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"
> ```
> 以及
> ``` shell
> JAVA_OPT="${JAVA_OPT} -server -Xms512m -Xmx512m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"
> ```
>


``` shell
[root@centos802 ~]# nohup mqnamesrv &
```

启动完成后，在`nohup.out`里看到这一条关键日志就是启动成功了。并且使用`jps`指令可以看到有一个 `NamesrvStartup`进程。

``` shell
[root@centos802 ~]# tail -f nohup.out 
The Name Server boot success. serializeType=JSON
```

#### 启动 Broker

启动 Broker 的脚本是`runbroker.sh`。

> 虚拟机环境
>
> Broker 的默认预设内存是8G，启动前，如果内存不够，同样需要调整下JVM内存。`vi runbroker.sh`，找到这一行，进行内存调整
>
> ``` shell
> JAVA_OPT="${JAVA_OPT} -server -Xms512m -Xmx512m -Xmn256m"
> ```
>
> 

找到`$ROCKETMQ_HOME/conf/broker.conf`， `vi`指令进行编辑，在最下面加入一个配置：

``` shell
autoCreateTopicEnable=true
```

然后也以静默启动的方式启动`runbroker.sh`

``` shell
[root@centos802 ~]# nohup mqbroker &
```

启动完成后，同样是检查`nohup.out`日志，有这一条关键日志就标识启动成功了。 并且`jps`指令可以 看到一个 BrokerStartup 进程。

``` shell
The broker[centos812, 192.168.1.112:10911] boot success. serializeType=JSON
```

> 在观察`runserver.sh`和`runbroker.sh`时，我们还可以查看到其他的JVM执行参数，这些参数都可 以进行定制。例如我们观察到一个比较有意思的地方，nameServer使用的是CMS垃圾回收器， 而Broker使用的是G1垃圾回收器。 关于垃圾回收器的知识你还记得吗？

#### 命令行快速验证

#### JAVA11环境

``` shell
[root@centos802 ~]# java --version
openjdk 11.0.13 2021-10-19
OpenJDK Runtime Environment Temurin-11.0.13+8 (build 11.0.13+8)
OpenJDK 64-Bit Server VM Temurin-11.0.13+8 (build 11.0.13+8, mixed mode)
```

在 JDK11 环境，安装完成后，如果直接启动会报错。

##### -Djava.ext.dirs

下面是直接启动 `NameServer` 的报错信息。

``` shell
[root@centos802 ~]# tail -f nohup.out
-Djava.ext.dirs=/root/.sdkman/candidates/java/current/jre/lib/ext:/app/rocketmq/rocketmq-4.9.2/bin/../lib:/root/.sdkman/candidates/java/current/lib/ext is not supported.  Use -classpath instead.
Error: Could not create the Java Virtual Machine.
Error: A fatal exception has occurred. Program will exit.
```

原因是`-Djava.ext.dirs`，已弃用。解决方案，编辑`bin/runserver.sh`。

* 注释掉该行，`#JAVA_OPT="${JAVA_OPT} -Djava.ext.dirs=${JAVA_HOME}/jre/lib/ext:${BASE_DIR}/lib:${JAVA_HOME}/lib/ext"`
* 并添加`${BASE_DIR}/lib/*` 到 `-cp`。`export CLASSPATH=.:${BASE_DIR}/conf:${BASE_DIR}/lib/*:${CLASSPATH}`

同理，直接启动 Broker ，或者运行 `bin/tool.sh` 也会出现同样的问题。解决方案也是一样的。

##### -Xloggc

启动 Broker 报错，

``` shell
[root@centos811 ~]# tail -f nohup.out 
[0.001s][warning][gc] -Xloggc is deprecated. Will use -Xlog:gc:/dev/shm/rmq_broker_gc_%p_%t.log instead.
Unrecognized VM option 'PrintGCDateStamps'
Error: Could not create the Java Virtual Machine.
Error: A fatal exception has occurred. Program will exit.
```

原因是 `-Xloggc:` 已过时，并且 JDK11 已经使用统一日志框架。解决方案如下：

注释掉 GC 日志相关配置：

``` shell
JAVA_OPT="${JAVA_OPT} -verbose:gc -Xloggc:${GC_LOG_DIR}/rmq_broker_gc_%p_%t.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -XX:+PrintAdaptiveSizePolicy"
JAVA_OPT="${JAVA_OPT} -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=30m"
```

并添加一行，新配置

``` shell
JAVA_OPT="${JAVA_OPT} -Xlog:gc*,safepoint,ergo*:file=${GC_LOG_DIR}/rmq_broker_gc_%p_%t.log:time,level,tags:filecount=5,filesize=30m"
```



## 集群环境

### 安装配置

修改 `$ROCKETMQ_HOME/conf/2m-2s-async/`目录下的配置文件

#### broker-a

``` shell
#所属集群名字，名字一样的节点就在同一个集群内
brokerClusterName=rocketmq-cluster
#broker名字，名字一样的节点就是一组主从节点。
brokerName=broker-a
#brokerid,0就表示是Master，>0的都是表示 Slave
brokerId=0
#nameServer地址，分号分割
namesrvAddr=worker1:9876;worker2:9876;worker3:9876
#在发送消息时，自动创建服务器不存在的topic，默认创建的队列数
defaultTopicQueueNums=4
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
autoCreateTopicEnable=true
#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭
autoCreateSubscriptionGroup=true
#Broker 对外服务的监听端口
listenPort=10911
#删除文件时间点，默认凌晨 4点
deleteWhen=04
#文件保留时间，默认 48 小时
fileReservedTime=120
#commitLog每个文件的大小默认1G
mapedFileSizeCommitLog=1073741824
#ConsumeQueue每个文件默认存30W条，根据业务情况调整
mapedFileSizeConsumeQueue=300000
#destroyMapedFileIntervalForcibly=120000
#redeleteHangedFileInterval=120000
#检测物理文件磁盘空间
diskMaxUsedSpaceRatio=88
#存储路径
storePathRootDir=/app/rocketmq/store
#commitLog 存储路径
storePathCommitLog=/app/rocketmq/store/commitlog
#消费队列存储路径存储路径
storePathConsumeQueue=/app/rocketmq/store/consumequeue
#消息索引存储路径
storePathIndex=/app/rocketmq/store/index
#checkpoint 文件存储路径
storeCheckpoint=/app/rocketmq/store/checkpoint
#abort 文件存储路径
abortFile=/app/rocketmq/store/abort
#限制的消息大小
maxMessageSize=65536
#flushCommitLogLeastPages=4
#flushConsumeQueueLeastPages=2
#flushCommitLogThoroughInterval=10000
#flushConsumeQueueThoroughInterval=60000
#Broker 的角色
#- ASYNC_MASTER 异步复制Master
#- SYNC_MASTER 同步双写Master
#- SLAVE
brokerRole=ASYNC_MASTER
#刷盘方式
#- ASYNC_FLUSH 异步刷盘
#- SYNC_FLUSH 同步刷盘
flushDiskType=ASYNC_FLUSH
#checkTransactionMessageEnable=false
#发消息线程池数量
#sendMessageThreadPoolNums=128
#拉消息线程池数量
#pullMessageThreadPoolNums=128
```

#### broker-a-s

``` shell
#所属集群名字，名字一样的节点就在同一个集群内
brokerClusterName=rocketmq-cluster
#broker名字，名字一样的节点就是一组主从节点。
brokerName=broker-a
#brokerid,0就表示是Master，>0的都是表示 Slave
brokerId=1
#nameServer地址，分号分割
namesrvAddr=worker1:9876;worker2:9876;worker3:9876
#在发送消息时，自动创建服务器不存在的topic，默认创建的队列数
defaultTopicQueueNums=4
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
autoCreateTopicEnable=true
#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭
autoCreateSubscriptionGroup=true
#Broker 对外服务的监听端口
listenPort=11011
#删除文件时间点，默认凌晨 4点
deleteWhen=04
#文件保留时间，默认 48 小时
fileReservedTime=120
#commitLog每个文件的大小默认1G
mapedFileSizeCommitLog=1073741824
#ConsumeQueue每个文件默认存30W条，根据业务情况调整
mapedFileSizeConsumeQueue=300000
#destroyMapedFileIntervalForcibly=120000
#redeleteHangedFileInterval=120000
#检测物理文件磁盘空间
diskMaxUsedSpaceRatio=88
#存储路径
storePathRootDir=/app/rocketmq/storeSlave
#commitLog 存储路径
storePathCommitLog=/app/rocketmq/storeSlave/commitlog

#消费队列存储路径存储路径
storePathConsumeQueue=/app/rocketmq/storeSlave/consumequeue
#消息索引存储路径
storePathIndex=/app/rocketmq/storeSlave/index
#checkpoint 文件存储路径
storeCheckpoint=/app/rocketmq/storeSlave/checkpoint
#abort 文件存储路径
abortFile=/app/rocketmq/storeSlave/abort
#限制的消息大小
maxMessageSize=65536
#flushCommitLogLeastPages=4
#flushConsumeQueueLeastPages=2
#flushCommitLogThoroughInterval=10000
#flushConsumeQueueThoroughInterval=60000
#Broker 的角色
#- ASYNC_MASTER 异步复制Master
#- SYNC_MASTER 同步双写Master
#- SLAVE
brokerRole=SLAVE
#刷盘方式
#- ASYNC_FLUSH 异步刷盘
#- SYNC_FLUSH 同步刷盘
flushDiskType=ASYNC_FLUSH
#checkTransactionMessageEnable=false
#发消息线程池数量
#sendMessageThreadPoolNums=128
#拉消息线程池数量
#pullMessageThreadPoolNums=128
```

#### broker-b

``` shell
#所属集群名字，名字一样的节点就在同一个集群内
brokerClusterName=rocketmq-cluster
#broker名字，名字一样的节点就是一组主从节点。
brokerName=broker-b
#brokerid,0就表示是Master，>0的都是表示 Slave
brokerId=0
#nameServer地址，分号分割
namesrvAddr=worker1:9876;worker2:9876;worker3:9876
#在发送消息时，自动创建服务器不存在的topic，默认创建的队列数
defaultTopicQueueNums=4
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
autoCreateTopicEnable=true
#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭
autoCreateSubscriptionGroup=true
#Broker 对外服务的监听端口
listenPort=10911
#删除文件时间点，默认凌晨 4点
deleteWhen=04
#文件保留时间，默认 48 小时
fileReservedTime=120
#commitLog每个文件的大小默认1G
mapedFileSizeCommitLog=1073741824
#ConsumeQueue每个文件默认存30W条，根据业务情况调整
mapedFileSizeConsumeQueue=300000
#destroyMapedFileIntervalForcibly=120000
#redeleteHangedFileInterval=120000
#检测物理文件磁盘空间
diskMaxUsedSpaceRatio=88
#存储路径
storePathRootDir=/app/rocketmq/store
#commitLog 存储路径
storePathCommitLog=/app/rocketmq/store/commitlog
#消费队列存储路径存储路径
storePathConsumeQueue=/app/rocketmq/store/consumequeue
#消息索引存储路径
storePathIndex=/app/rocketmq/store/index
#checkpoint 文件存储路径
storeCheckpoint=/app/rocketmq/store/checkpoint
#abort 文件存储路径
abortFile=/app/rocketmq/store/abort
#限制的消息大小
maxMessageSize=65536
#flushCommitLogLeastPages=4
#flushConsumeQueueLeastPages=2
#flushCommitLogThoroughInterval=10000
#flushConsumeQueueThoroughInterval=60000
#Broker 的角色
#- ASYNC_MASTER 异步复制Master
#- SYNC_MASTER 同步双写Master
#- SLAVE
brokerRole=ASYNC_MASTER
#刷盘方式
#- ASYNC_FLUSH 异步刷盘
#- SYNC_FLUSH 同步刷盘
flushDiskType=ASYNC_FLUSH
#checkTransactionMessageEnable=false
#发消息线程池数量
#sendMessageThreadPoolNums=128
#拉消息线程池数量
#pullMessageThreadPoolNums=128
```

#### broker-b-s

``` shell
#所属集群名字，名字一样的节点就在同一个集群内
brokerClusterName=rocketmq-cluster
#broker名字，名字一样的节点就是一组主从节点。
brokerName=broker-b
#brokerid,0就表示是Master，>0的都是表示 Slave
brokerId=1
#nameServer地址，分号分割
namesrvAddr=worker1:9876;worker2:9876;worker3:9876
#在发送消息时，自动创建服务器不存在的topic，默认创建的队列数
defaultTopicQueueNums=4
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
autoCreateTopicEnable=true
#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭
autoCreateSubscriptionGroup=true
#Broker 对外服务的监听端口
listenPort=11011
#删除文件时间点，默认凌晨 4点
deleteWhen=04
#文件保留时间，默认 48 小时
fileReservedTime=120
#commitLog每个文件的大小默认1G
mapedFileSizeCommitLog=1073741824
#ConsumeQueue每个文件默认存30W条，根据业务情况调整
mapedFileSizeConsumeQueue=300000
#destroyMapedFileIntervalForcibly=120000
#redeleteHangedFileInterval=120000
#检测物理文件磁盘空间
diskMaxUsedSpaceRatio=88
#存储路径
storePathRootDir=/app/rocketmq/storeSlave
#commitLog 存储路径
storePathCommitLog=/app/rocketmq/storeSlave/commitlog
#消费队列存储路径存储路径
storePathConsumeQueue=/app/rocketmq/storeSlave/consumequeue
#消息索引存储路径
storePathIndex=/app/rocketmq/storeSlave/index
#checkpoint 文件存储路径
storeCheckpoint=/app/rocketmq/storeSlave/checkpoint
#abort 文件存储路径
abortFile=/app/rocketmq/storeSlave/abort
#限制的消息大小
maxMessageSize=65536
#flushCommitLogLeastPages=4
#flushConsumeQueueLeastPages=2
#flushCommitLogThoroughInterval=10000
#flushConsumeQueueThoroughInterval=60000
#Broker 的角色
#- ASYNC_MASTER 异步复制Master
#- SYNC_MASTER 同步双写Master
#- SLAVE
brokerRole=SLAVE
#刷盘方式
#- ASYNC_FLUSH 异步刷盘
#- SYNC_FLUSH 同步刷盘
flushDiskType=ASYNC_FLUSH
#checkTransactionMessageEnable=false
#发消息线程池数量
#sendMessageThreadPoolNums=128
#拉消息线程池数量
#pullMessageThreadPoolNums=128
```



### 启动

先启动 `mqnamesrv`，再启动 `broker`

``` shell
# namesrv
nohup mqnamesrv &

# broker
nohup mqbroker -c conf/2m-2s-async/broker-a.properties &
nohup mqbroker -c conf/2m-2s-async/broker-a-s.properties &
nohup mqbroker -c conf/2m-2s-async/broker-b.properties &
nohup mqbroker -c conf/2m-2s-async/broker-b-s.properties &
```



### console

[roketmq-externals-master](https://github.com/apache/rocketmq-externals) 项目的 `rocketmq-console` 组件，提供了一个图形化管理界面。

``` shell
nohup java -jar rocketmq-console-ng-1.0.1.jar &
```

