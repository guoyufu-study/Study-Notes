# Apache Zookeeper

* [3.7.x 文档](分布式协调/Zookeeper/Zookeeper文档.md)
* [享学讲ZK3.4.12](分布式协调/Zookeeper/享学.md)

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