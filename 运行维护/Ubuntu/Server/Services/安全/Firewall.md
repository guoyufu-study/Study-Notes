# Firewall

> https://ubuntu.com/server/docs/security-firewall
>
> https://help.ubuntu.com/community/UFW

## 介绍

Linux 内核包括***Netfilter*子系统**，它用于操纵或决定进入或通过服务器的网络流量的命运。所有现代 Linux 防火墙解决方案都使用该系统进行数据包过滤。

没有用户空间接口来管理**内核的包过滤系统**对管理员来说几乎没有用处。这就是 **iptables** 的用途：当一个数据包到达您的服务器时，它将根据用户空间通过 iptables 提供给它的规则，将其交给 Netfilter 子系统接受、处理或拒绝。因此，如果您熟悉它的话，那么管理您的防火墙只需要 iptables ，但许多前端可用于简化任务。

## ufw - Uncomplicated Firewall （简单的防火墙）

Ubuntu 的默认防火墙配置工具是 ufw。为**简化 iptables 防火墙配置**而开发，ufw 提供了一种用户友好的方式来创建基于 IPv4 或 IPv6 主机的防火墙。

默认情况下， **`ufw` 最初是禁用的**。来自 ufw 手册页：

“ufw 的目的不是通过其命令界面提供完整的防火墙功能，而是提供一种添加或删除简单规则的简单方法。它目前主要用于基于主机的防火墙。”

下面是一些如何使用 ufw 的例子：

- 首先，需要**启用** ufw。从终端提示符输入：

  ```
  sudo ufw enable
  ```

- **开放一个端口**（本例中为 SSH）：

  ```
  sudo ufw allow 22
  ```

- 也可以使用*编号*格式添加规则：

  ```
  sudo ufw insert 1 allow 80
  ```

- 同样，要**关闭一个开放的端口**：

  ```
  sudo ufw deny 22
  ```

- 要**删除规则**，请使用 delete 后跟规则：

  ```
  sudo ufw delete deny 22
  ```

- 也可以允许**从特定主机或网络访问端口**。以下示例允许从主机 `192.168.0.2` 对该主机上的任何 IP 地址进行 SSH 访问：

  ```
  sudo ufw allow proto tcp from 192.168.0.2 to any port 22
  ```

  将 `192.168.0.2` 替换为 `192.168.0.0/24` 以允许从整个子网进行 SSH 访问。

- 将*`–dry-run`*选项添加到 *`ufw`* 命令将**输出结果规则**，但不会应用它们。例如，如果打开 HTTP 端口，将应用以下内容：

  ```auto
   sudo ufw --dry-run allow http
  ```

  ```
  *filter
  :ufw-user-input - [0:0]
  :ufw-user-output - [0:0]
  :ufw-user-forward - [0:0]
  :ufw-user-limit - [0:0]
  :ufw-user-limit-accept - [0:0]
  ### RULES ###
  
  ### tuple ### allow tcp 80 0.0.0.0/0 any 0.0.0.0/0
  -A ufw-user-input -p tcp --dport 80 -j ACCEPT
  
  ### END RULES ###
  -A ufw-user-input -j RETURN
  -A ufw-user-output -j RETURN
  -A ufw-user-forward -j RETURN
  -A ufw-user-limit -m limit --limit 3/minute -j LOG --log-prefix "[UFW LIMIT]: "
  -A ufw-user-limit -j REJECT
  -A ufw-user-limit-accept -j ACCEPT
  COMMIT
  Rules updated
  ```

- ufw 可以通过以下方式**禁用**：

  ```
  sudo ufw disable
  ```

- 要**查看防火墙状态**，请输入：

  ```
  sudo ufw status
  ```

- 对于**更详细的状态信息**，请使用：

  ```
  sudo ufw status verbose
  ```

- 查看*编号*格式：

  ```
  sudo ufw status numbered
  ```

> 如果要打开或关闭的端口在 `/etc/services` 中定义，则可以使用端口名称而不是端口号。在上面的示例中，将*22*替换为*ssh*。

这是使用 ufw 的快速介绍。有关更多信息，请参阅 ufw 手册页。

### ufw 应用集成

开放端口的应用程序可以包含一个 ufw 配置文件，该配置文件详细说明了应用程序正常运行所需的端口。**配置文件保存在 `/etc/ufw/applications.d` 中**，如果默认端口已更改，则可以对其进行编辑。

- 要**查看哪些应用程序安装了配置文件**，请在终端中输入以下内容：

  ```
  sudo ufw app list
  ```

- 与允许流量到端口类似，使用应用程序配置文件是通过输入以下内容完成的：

  ```
  sudo ufw allow Samba
  ```

- 扩展语法也可用：

  ```
  ufw allow from 192.168.0.0/24 to any app Samba
  ```

  将*`Samba`*和*`192.168.0.0/24`*替换为您正在使用的应用程序配置文件和您的网络的 IP 范围。

  > 无需为应用程序指定*协议*，因为该信息在配置文件中有详细说明。另请注意，*应用*名称替换了*端口*号。

- 要查看有关为应用程序定义的端口、协议等的详细信息，请输入：

  ```
  sudo ufw app info Samba
  ```

并非所有需要开放网络端口的应用程序都带有 ufw 配置文件，但如果您已对应用程序进行了配置文件并希望该文件包含在包中，请在 Launchpad 中针对该包提交错误。

```
ubuntu-bug nameofpackage
```

## IP伪装

IP 伪装的目的是允许网络上具有私有、不可路由 IP 地址的机器通过进行伪装的机器访问 Internet。来自您的专用网络的发往 Internet 的流量必须经过处理，才能将回复路由回发出请求的机器。为此，内核必须修改每个数据包的*源*IP 地址，以便将回复路由回它，而不是发送到发出请求的私有 IP 地址，这在 Internet 上是不可能的。Linux 使用*连接跟踪*(conntrack) 来跟踪哪些连接属于哪些机器，并相应地重新路由每个返回数据包。离开你的私有网络的流量因此被“伪装”成来自你的 Ubuntu 网关机器。此过程在 Microsoft 文档中称为 Internet 连接共享。

### ufw 伪装

IP 伪装可以使用自定义 ufw 规则来实现。这是可能的，因为 ufw 的当前后端是 iptables-restore，其规则文件位于`/etc/ufw/*.rules`. 这些文件是添加不使用 ufw 的旧 iptables 规则以及与网关或网桥相关的规则的好地方。

规则分为两个不同的文件，应该在 ufw 命令行规则之前执行的规则，以及在 ufw 命令行规则之后执行的规则。

- 首先，需要在ufw中启用包转发。需要调整两个配置文件，在 `/etc/default/ufw` 将*`DEFAULT_FORWARD_POLICY`*更改为“ACCEPT”：

  ```
  DEFAULT_FORWARD_POLICY="ACCEPT"
  ```

  然后编辑 `/etc/ufw/sysctl.conf` 并取消注释：

  ```
  net/ipv4/ip_forward=1
  ```

  同样，对于 IPv6 转发取消注释：

  ```
  net/ipv6/conf/default/forwarding=1
  ```

- 现在将规则添加到 `/etc/ufw/before.rules` 文件中。默认规则仅配置*过滤*表，而要启用伪装 *nat* 表则需要进行配置。在标题注释之后添加以下内容到文件顶部:

  ```
  # nat Table rules
  *nat
  :POSTROUTING ACCEPT [0:0]
  
  # Forward traffic from eth1 through eth0.
  -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE
  
  # don't delete the 'COMMIT' line or these nat table rules won't be processed
  COMMIT
  ```

  这些注释不是绝对必要的，但记录您的配置被认为是一种很好的做法。此外，在修改 `/etc/ufw` 中的任何*规则*文件时，请确保这些行是每个已修改表的最后一行：

  ```
  # don't delete the 'COMMIT' line or these rules won't be processed
  COMMIT
  ```

  对于每个*表*，都需要相应的*`COMMIT`*语句。在这些示例中，仅显示了*nat*和*filter*表，但您也可以为*raw*和*mangle*表添加规则。

  > 在上面的示例中，将*`eth0`*、*`eth1`*和*`192.168.0.0/24`*替换为适合您网络的接口和 IP 范围。

- 最后，禁用并重新启用 ufw 以应用更改：

  ```
  sudo ufw disable && sudo ufw enable
  ```

现在应该启用 IP 伪装。您还可以将任何其他 `FORWARD` 规则添加到 `/etc/ufw/before.rules`。建议将这些附加规则添加到 *`ufw-before-forward`* 链中。

### iptables 伪装

iptables 也可用于启用伪装。

- 与 ufw 类似，第一步是通过编辑 `/etc/sysctl.conf` 和取消注释以下行来启用 IPv4 数据包转发：

  ```
  net.ipv4.ip_forward=1
  ```

  如果您希望启用 IPv6 转发，请取消注释：

  ```
  net.ipv6.conf.default.forwarding=1
  ```

- 接下来，执行 `sysctl` 命令以启用配置文件中的新设置：

  ```
  sudo sysctl -p
  ```

- IP 伪装现在可以使用单个 iptables 规则完成，根据您的网络配置，该规则可能略有不同：

  ```
  sudo iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o ppp0 -j MASQUERADE
  ```

  上述命令假设您的私有地址空间是 192.168.0.0/16，并且您的面向 Internet 的设备是 ppp0。语法分解如下：

  - -t nat - 规则是进入 nat 表
  - -A POSTROUTING – 将规则附加 (-A) 到 POSTROUTING 链
  - -s 192.168.0.0/16 – 该规则适用于源自指定地址空间的流量
  - -o ppp0 – 该规则适用于计划通过指定网络设备路由的流量
  - -j MASQUERADE – 匹配此规则的流量将“跳转”(-j) 到要操纵的 MASQUERADE 目标，如上所述

- 此外，过滤器表（默认表，以及大多数或所有数据包过滤发生的位置）中的每个链都有一个默认*策略*ACCEPT，但如果您在网关设备之外创建防火墙，您可能已将策略设置为DROP 或 REJECT，在这种情况下，您的伪装流量需要通过 FORWARD 链允许上述规则起作用：

  ```
  sudo iptables -A FORWARD -s 192.168.0.0/16 -o ppp0 -j ACCEPT
  sudo iptables -A FORWARD -d 192.168.0.0/16 -m state \
  --state ESTABLISHED,RELATED -i ppp0 -j ACCEPT
  ```

  上述命令将允许从本地网络到 Internet 的所有连接以及与这些连接相关的所有流量返回到启动它们的机器。

- 如果您希望在重新启动时启用伪装，您可能会这样做，请编辑`/etc/rc.local`并添加上面使用的任何命令。例如添加第一个没有过滤的命令：

  ```
  iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o ppp0 -j MASQUERADE
  ```

## 日志

防火墙日志对于识别攻击、对防火墙规则进行故障排除以及发现网络上的异常活动至关重要。但是，您必须在防火墙中包含日志规则才能生成它们，并且日志规则必须位于任何适用的终止规则（具有决定数据包命运的目标的规则，例如 `ACCEPT`、`DROP` 或 `REJECT`）之前。

如果您使用的是 ufw，则可以通过在终端中输入以下内容来打开日志记录：

```
sudo ufw logging on
```

要在 ufw 中关闭登录，只需在上述命令中将*`on`*替换为*`off` 。*

如果使用 iptables 而不是 ufw，请输入：

```
sudo iptables -A INPUT -m state --state NEW -p tcp --dport 80 \
-j LOG --log-prefix "NEW_HTTP_CONN: "
```

然后，来自本地机器的端口 80 上的请求将在 dmesg 中生成一个如下所示的日志（单行分成 3 行以适合本文档）：

```
[4304885.870000] NEW_HTTP_CONN: IN=lo OUT= MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00
SRC=127.0.0.1 DST=127.0.0.1 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=58288 DF PROTO=TCP
SPT=53981 DPT=80 WINDOW=32767 RES=0x00 SYN URGP=0
```

上面的日志也会出现在 `/var/log/messages`、`/var/log/syslog`、 和`/var/log/kern.log`中。`/etc/syslog.conf`可以通过适当编辑或通过安装和配置 ulogd 并使用 ULOG 目标而不是 LOG来修改此行为。ulogd 守护进程是一个用户空间服务器，它监听来自内核的日志指令，专门用于防火墙，并且可以登录到您喜欢的任何文件，甚至是 PostgreSQL 或 MySQL 数据库。使用 logwatch、fwanalog、fwlogwatch 或 lire 等日志分析工具可以简化防火墙日志的理解。

## 其他工具

有许多工具可以帮助您在不熟悉 iptables 的情况下构建完整的防火墙。带有纯文本配置文件的命令行工具：

- [Shorewall](http://www.shorewall.net/) 是一个非常强大的解决方案，可帮助您为任何网络配置高级防火墙。

## 参考

- [Ubuntu Firewall](https://wiki.ubuntu.com/UncomplicatedFirewall) wiki 页面包含有关 ufw 开发的信息。
- 此外，ufw 手册页包含一些非常有用的信息：`man ufw`.
- 有关使用 iptables 的更多信息，请参阅 [packet-filtering-HOWTO](http://www.netfilter.org/documentation/HOWTO/packet-filtering-HOWTO.html)。
- [nat-HOWTO](http://www.netfilter.org/documentation/HOWTO/NAT-HOWTO.html) 包含更多关于伪装的细节。
- Ubuntu wiki 中的[IPTables HowTo](https://help.ubuntu.com/community/IptablesHowTo)是一个很好的资源。
