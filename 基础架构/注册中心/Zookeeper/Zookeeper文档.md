# Apache Zookeeper

Apache ZooKeeper 致力于开发和维护一个开源服务器，该服务器支持高度可靠的分布式协调。

## 什么是 Zookeeper

ZooKeeper是一种集中式服务，用于维护配置信息、命名、提供分布式同步和提供组服务。所有这些类型的服务都以某种形式被分布式应用程序使用。每次实现它们时，都会有大量的工作用于修复不可避免的bug和竞争条件。由于实现这类服务的困难，应用程序最初通常会忽略它们，这使得它们在发生变化时变得脆弱，难以管理。即使操作正确，这些服务的不同实现在部署应用程序时也会导致管理复杂性。

在 [ZooKeeper Wiki](https://cwiki.apache.org/confluence/display/ZOOKEEPER/Index) 上了解有关ZooKeeper的更多信息。

## 开始

先在一台机器或一个非常小的集群上安装 ZooKeeper。

* 通过阅读文档[了解](分布式协调/Zookeeper/Zookeeper文档.md) ZooKeeper。
* 从发布页面[下载](http://zookeeper.apache.org/releases.html) ZooKeeper。

## 参与

Apache ZooKeeper 是Apache软件基金会下的开源志愿者项目。我们鼓励你了解该项目并贡献你的专业知识。以下是一些入门链接：

* 请参阅我们的[如何为ZooKeeper做出贡献](https://cwiki.apache.org/confluence/display/ZOOKEEPER/HowToContribute)页面。
* 给我们[反馈](https://issues.apache.org/jira/browse/ZOOKEEPER)：我们还能做得更好吗?
* 加入[邮件列表](http://zookeeper.apache.org/lists.html)：社区见。

# ZooKeeper：因为协调的分布式的系统是一个动物园

ZooKeeper 是一种**面向分布式应用的高性能协调服务**。它在一个简单的接口中公开公共服务，比如命名、配置管理、同步和组服务，因此你不必从头开始编写这些公共服务。您可以使用它来实现共识、组管理、领导选举和业务协议。而且，你可以根据自己的具体需求来构建。

* **ZooKeeper概述**：客户端开发人员、管理员和贡献者的技术概述文档
    * [概述](#概述)：ZooKeeper鸟瞰图，包括设计概念和架构

    * [入门](#入门：使用ZooKeeper协调分布式应用程序)：一个教程风格的指南，供开发人员安装、运行和编程使用 ZooKeeper

    * 发行说明：面向开发人员和用户的新功能、改进和不兼容性
* **开发者**：使用ZooKeeper客户端API的开发者文档

    * API文档：ZooKeeper客户端API的技术参考

    * 程序员指南：ZooKeeper客户端应用程序开发人员指南

    * ZooKeeper用例：使用ZooKeeper的一系列用例。

    * ZooKeeper Java示例：一个简单的ZooKeeper客户端应用程序，用Java编写

    * 屏障和队列教程：屏障和队列的示例实现

    * ZooKeeper配方：分布式应用程序中常见问题的高级解决方案

* **管理员和操作工程师**：ZooKeeper部署管理员和操作工程师的文档

    * 管理员指南：为系统管理员和可能部署ZooKeeper的任何其他人提供的指南

    * 配额指南：系统管理员关于ZooKeeper中配额的指南。

    * JMX：如何在ZooKeeper中启用JMX

    * 等级量化

    * 观察员：无投票权的团队成员，可轻松提高ZooKeeper的可扩展性

    * 动态重新配置：关于如何在ZooKeeper中使用动态重新配置的指南

    * ZooKeeper CLI：关于如何使用ZooKeeper命令行界面的指南

    * ZooKeeper工具：关于如何为ZooKeeper使用一系列工具的指南

    * ZooKeeper监视器：关于如何监视ZooKeeper的指南

    * 审核日志：关于如何在ZooKeeper服务器中配置审核日志以及记录哪些内容的指南。

* **贡献者**：为ZooKeeper开源项目的开发者提供的文档

    * ZooKeeper内部：关于ZooKeeper内部工作的各种主题

* **其他 ZooKeeper 文档**

    * 维基

    * 常见问题


## 概述

### ZooKeeper：分布式应用的分布式协调服务

ZooKeeper 是一种分布式的、开源的分布式应用协调服务。它公开了一组简单的原语，分布式应用可以基于这些原语实现更高级别的同步、配置维护、组和命名服务。它被设计为易于编程，并且使用了一个按照熟悉的文件系统目录树结构设计的数据模型。它在Java中运行，并且有针对Java和C的绑定。

众所周知，协调服务很难做好。它们特别容易出现竞争条件和死锁之类的错误。ZooKeeper背后的动机是减轻分布式应用从头开始实现协调服务的责任。

### 设计目标
ZooKeeper 很简单。ZooKeeper 允许分布式进程通过一个类似于标准文件系统的共享的分层命名空间相互协调。命名空间由数据寄存器组成——用 ZooKeeper 的说法，称为 znode——这些寄存器类似于文件和目录。与为存储而设计的典型文件系统不同，ZooKeeper 数据保存在内存中，这意味着 ZooKeeper 可以实现高吞吐量和低延迟。

ZooKeeper 的实现使**高性能**、**高可用性**和**严格有序的访问**成为可能。ZooKeeper 的性能方面意味着它可以用于大型分布式系统。可靠性方面使其不会成为单点故障。严格的排序意味着复杂的同步原语可以在客户端实现。

ZooKeeper 是重复的。与它所协调的分布式进程一样，ZooKeeper 本身也打算在一组称为一个整体的主机上进行重复。

组成ZooKeeper服务的服务器必须相互了解。它们在内存中维护状态映像，并在持久存储中维护事务日志和快照。只要大多数服务器可用，ZooKeeper服务就可用。

客户端连接到单个ZooKeeper服务器。客户端维护一个TCP连接，通过该连接发送请求、获取响应、获取监视事件和发送心跳。如果与服务器的TCP连接中断，客户端将连接到其他服务器。

ZooKeeper 是有序的。ZooKeeper 在每次更新上都标记一个数字，这个数字反映了所有 ZooKeeper 事务的顺序。后续操作可以使用该顺序实现更高级别的抽象，例如同步原语。

ZooKeeper很快。它在“读主导”的工作负载中速度特别快。ZooKeeper应用运行在数千台机器上，在读比写更常见的地方，它的性能最好，比率约为10:1。

### 数据模型和分层名称空间

ZooKeeper 提供的名称空间与标准文件系统的名称空间非常相似。名称是由斜杠（/）分隔的路径元素序列。ZooKeeper 命名空间中的每个节点都由路径标识。

ZooKeeper的分层命名空间

### 节点和临时节点


与标准文件系统不同，ZooKeeper 名称空间中的每个节点都可以拥有与其关联的数据以及子节点。这就像文件系统允许文件同时也是目录一样。(ZooKeeper 被设计用来存储协调数据：状态信息、配置信息、位置信息等，所以存储在每个节点上的数据通常很小，在字节到千字节的范围内。) 我们使用术语 znode 来明确我们谈论的是 ZooKeeper 数据节点。


Znodes维护一个 stat  结构，其中包括数据变更的版本号、ACL变更和时间戳，以允许缓存验证和协调更新。每次 znode的数据变更时，版本号都会增加。例如，每当客户机检索数据时，它也会接收到数据的版本。


存储在名称空间中每个 znode 上的数据是以原子方式读取和写入的。读操作获取与 znode 关联的所有数据字节，写操作替换所有数据。每个节点都有一个访问控制列表(Access Control List, ACL)来限制谁可以做什么。


ZooKeeper 也有临时节点的概念。只要创建 znode 的会话处于活动状态，这些 znode 就会存在。当会话结束时，znode 将被删除。

### 条件更新和监视


ZooKeeper 支持监视的概念。客户端可以在 znode 上设置一个监视。当 znode 变更时，将触发并删除一个监视。当监视被触发时，客户端接收到一个数据包，该包表示 znode 已经发生变更。如果客户端与其中一个 ZooKeeper 服务器之间的连接中断，客户端将收到一个本地通知。

> 3.6.0新功能：客户端还可以在 znode 上设置永久的、递归的监视，这些监视在被触发时不会被删除，并且可以递归地触发已注册 znode 以及任何子 znode 上的变更。

### 担保

ZooKeeper 非常快速和简单。但是，由于它的目标是作为**构建更复杂服务（如同步）的基础**，因此它提供了一组保证。这些都是：

* 顺序一致性：来自客户端的更新将按发送的顺序应用。
* 原子性：更新成功或失败。没有部分结果。
* 单系统映像：客户端将看到服务的相同视图，而不管它连接到的是哪个服务器。例如，即使客户端故障转移到具有相同会话的不同服务器，客户端也永远不会看到系统的旧视图。
* 可靠性：一旦应用了更新，它将从那时起持续存在，直到客户端覆盖更新。
* 及时性：保证系统的客户端视图在一定时间范围内是最新的。

### 简单的API


ZooKeeper 的设计目标之一是提供一个非常简单的编程接口。因此，它只支持以下操作：

* 创建：在树的某个位置创建一个节点
* 删除：删除节点
* 存在：测试节点是否存在于某个位置
* 获取数据：从节点读取数据
* 设置数据：向节点写入数据
* 获取子节点：获取节点的子节点列表
* 同步：等待数据被传播

### 实现

[ZooKeeper 组件](http://zookeeper.apache.org/doc/r3.7.0/zookeeperOver.html#zkComponents)展示 ZooKeeper 服务的高级组件。除了请求处理器之外，组成 ZooKeeper 服务的每个服务器都复制每个组件的自己的副本。

![实现](http://zookeeper.apache.org/doc/r3.7.0/images/zkcomponents.jpg)

### 使用


ZooKeeper 的编程接口非常简单。然而，使用它，你可以实现更高阶的操作，如同步原语、组成员关系、所有权等。

### 性能

ZooKeeper 被设计成高性能的。但真的是这样吗? ZooKeeper 的开发团队在 Yahoo! 研究表明确实如此。(请参见 随着读写比的变化而变化的 ZooKeeper 吞吐量。)在读多于写的应用中，它的性能尤其高，因为写操作涉及同步所有服务器的状态。（对于协调服务来说，读取的数量通常超过写入的数量。）

![性能](http://zookeeper.apache.org/doc/r3.7.0/images/zkperfRW-3.2.jpg)

ZooKeeper 的吞吐量随着读写比的变化而变化，这是ZooKeeper 3.2版本运行在双2Ghz Xeon和两个SATA 15K RPM驱动器上的吞吐量图。其中一个驱动器用作 ZooKeeper 日志专用设备。快照被写入操作系统驱动器。写请求为1K次写入，读请求为1K次读取。Servers”表示ZooKeeper集群的大小，即组成该服务的服务器数量。大约使用了30个其他服务器来模拟客户机。ZooKeeper 集成被配置为领导者不允许来自客户端的连接。

基准测试也表明它是可靠的。存在错误时的可靠性显示了部署如何响应各种故障。图中标记的事件如下所示：

1. 一个 follower 的失败与恢复
2. 不同 follower 的故障和恢复
3. leader 的失败
4. 两个 follower 的失败和恢复
5. 另一位 leader 的失败

### 可靠性

为了显示系统在注入故障时的行为，我们运行了一个由7台机器组成的ZooKeeper服务。我们运行了与之前相同的饱和基准测试，但这次我们将写入百分比保持在30%，这是我们预期工作负载的保守比率。

![可靠性](http://zookeeper.apache.org/doc/r3.7.0/images/zkperfreliability.jpg)

从这个图表中有一些重要的观察结果。首先，如果followers失败并快速恢复，那么 ZooKeeper 能够在失败的情况下保持高吞吐量。但也许更重要的是，leader选举算法允许系统快速恢复，以防止吞吐量大幅下降。根据我们的观察，ZooKeeper只需要不到 200ms 的时间就可以选出一个新的leader。第三，随着followers恢复，ZooKeeper 能够在他们开始处理请求后再次提高吞吐量。



## 入门：使用ZooKeeper协调分布式应用程序

本文档包含帮助你快速开始使用 ZooKeeper 的信息。

它主要面向希望试用它的开发人员，包含单个 ZooKeeper 服务器的简单安装说明、一些验证它是否正在运行的命令，以及一个简单的编程示例。最后，为了方便起见，有几节介绍了更复杂的安装，例如运行复制部署和优化事务日志。但是，有关商业部署的完整说明，请参阅ZooKeeper管理员指南。

### 预备知识

请参阅管理指南中的[系统要求](http://zookeeper.apache.org/doc/r3.7.0/zookeeperAdmin.html#sc_systemReq)。

### 下载

要获得ZooKeeper发行版，请从Apache下载镜像之一下载最新的[稳定](http://zookeeper.apache.org/releases.html)版本。

### 独立操作

在独立模式下设置 ZooKeeper 服务器很简单。 服务器包含在单个 JAR 文件中，因此，安装包括创建一个配置。

一旦你下载了一个稳定的 ZooKeeper 版本，解压它并 `cd` 到根目录。

要启动 ZooKeeper，你需要一个配置文件。 下面是一个示例，请在 `conf/zoo.cfg` 中创建它：

```
tickTime=2000
dataDir=/var/lib/zookeeper
clientPort=2181
```

这个文件可以叫任何名字，但为了便于讨论，请叫它 `conf/zoo.cfg`。 更改 `dataDir` 的值以指定现有（一开始是空的）目录。 以下是每个字段的含义： 

* `tickTime`：ZooKeeper使用的基本时间单位（毫秒）。它用于心跳，最小会话超时将是 `tickTime` 的两倍。
* `dataDir`：存储内存中数据库快照的位置，以及数据库更新的事务日志（除非另有指定）。
* `clientPort`：侦听客户端连接的端口

现在你已经创建了配置文件，可以启动 ZooKeeper：

```bash
bin/zkServer.sh start
```

ZooKeeper使用log4j记录消息——更多详细信息请参见程序员指南的[日志](http://zookeeper.apache.org/doc/r3.7.0/zookeeperProgrammers.html#Logging)部分。根据log4j配置，你将看到日志消息到达控制台（默认）和/或日志文件。

此处概述的步骤以独立模式运行 ZooKeeper。没有副本，因此如果 ZooKeeper 进程失败，服务将停止。这对于大多数开发情况来说都很好，但是要在复本模式下运行 ZooKeeper，请参阅[运行复制ZooKeeper](http://zookeeper.apache.org/doc/r3.7.0/zookeeperStarted.html#sc_RunningReplicatedZooKeeper)。

### 管理 ZooKeeper 存储

对于长期运行的生产系统，ZooKeeper 存储必须由外部管理（`dataDir ` 和 日志）。有关更多详细信息，请参阅[维护](http://zookeeper.apache.org/doc/r3.7.0/zookeeperAdmin.html#sc_maintenance)部分。

### 连接到 ZooKeeper

```bash
$ bin/zkCli.sh -server 127.0.0.1:2181
```

这使你可以执行简单的、类似文件的操作。

连接后，你将看到以下内容：

```
Connecting to localhost:2181
log4j:WARN No appenders could be found for logger (org.apache.zookeeper.ZooKeeper).
log4j:WARN Please initialize the log4j system properly.
Welcome to ZooKeeper!
JLine support is enabled
[zkshell: 0]
```

