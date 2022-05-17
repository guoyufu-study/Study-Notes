# 使用 MySQL APT 存储库的快速指南

> https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/

这是使用 MySQL APT 存储库的快速指南，它提供了 `deb` 软件包，用于在当前 Debian 和 Ubuntu 版本上安装和管理 MySQL 服务器、客户端和其他组件。

有关法律信息，请参阅[法律声明](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#legalnotice)。

如需有关使用 MySQL 的帮助，请访问 [MySQL 论坛](http://forums.mysql.com/)，您可以在其中与其他 MySQL 用户讨论您的问题。

## 全新安装 MySQL 的步骤

> 以下说明假设您的系统上尚未安装任何版本的 MySQL（无论是由 Oracle 还是其他方分发）；如果不是这种情况，请按照 [使用 MySQL APT 存储库替换 MySQL 的本机发行版](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#repo-qg-apt-replacing) 或 [替换通过直接 deb 包下载安装的 MySQL 服务器](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#repo-qg-apt-replace-direct) 中给出的说明进行操作。

### 添加 MySQL APT 存储库

首先，将 MySQL APT 存储库添加到系统的软件存储库列表中。按照这些步骤：

1. 转到位于 https://dev.mysql.com/downloads/repo/apt/ 的 MySQL APT 存储库的下载页面。

2. 选择并下载适用于您的 Linux 发行版的发行包。

3. 使用以下命令安装下载的发行包，替换 *`version-specific-package-name`* 为下载包的名称（如果您没有在包所在的文件夹中运行该命令，则在前面加上它的路径）：

   ```terminal
   $> sudo dpkg -i /PATH/version-specific-package-name.deb
   ```

   

   例如，对于包的  *`w.x.y-z`* 版本，命令是：

   ```terminal
   $> sudo dpkg -i mysql-apt-config_w.x.y-z_all.deb
   ```

   请注意，相同的软件包适用于所有受支持的 Debian 和 Ubuntu 平台。

4. 在安装包的过程中，系统会要求您选择要安装的 MySQL 服务器和其他组件（例如 MySQL Workbench）的版本。如果您不确定要选择哪个版本，请不要更改为您选择的默认选项。 如果您不想安装特定组件，也可以选择**无。**选择好所有组件后，选择**Ok**完成发布包的配置和安装。

   您可以随时更改您对版本的选择；有关说明，请参阅[选择主要发行版本](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#repo-qg-apt-select-series) 。

5. 使用以下命令从 MySQL APT 存储库更新包信息（*此步骤是强制性的*）：

   ```terminal
   $> sudo apt-get update
   ```

除了使用发布包，您还可以手动添加和配置 MySQL APT 存储库；有关详细信息，请参阅 [附录 A：手动添加和配置 MySQL APT 存储库](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#repo-qg-apt-repo-manual-setup)。

### 使用 APT 安装 MySQL

通过以下命令安装 MySQL：

```terminal
$> sudo apt-get install mysql-server
```

这将安装 MySQL 服务器的包，以及客户端和数据库公共文件的包。

在安装过程中，系统会要求您为 MySQL 安装的 `root` 用户提供密码。

> 确保记住您设置的 `root` 密码。想以后设置密码的用户可以在对话框中将 **password** 字段留空，然后按 **ok**；在这种情况下，对于使用 Unix 套接字文件的连接，对服务器的 root 访问将通过 [Socket Peer-Credential Pluggable Authentication](https://dev.mysql.com/doc/refman/8.0/en/socket-pluggable-authentication.html) 进行身份验证。 您可以稍后使用程序 **[mysql_secure_installation](https://dev.mysql.com/doc/refman/8.0/en/mysql-secure-installation.html)** 设置 root 密码。

### 启动和停止 MySQL 服务器

MySQL 服务器在安装后自动启动。您可以使用以下命令检查 MySQL 服务器的状态：

```terminal
$> systemctl status mysql
```

如果操作系统启用了 systemd，则应使用标准 **systemctl**（或者， 使用反转参数的**服务**）命令，例如**stop**、 **start**、**status**和 **restart**来管理 MySQL 服务器服务。该`mysql`服务默认启用，并在系统重新启动时启动。有关更多信息，请参阅 [使用 systemd 管理 MySQL 服务器](https://dev.mysql.com/doc/refman/8.0/en/using-systemd.html)。

## 选择主要发布版本

默认情况下，您的 MySQL 服务器和其他所需组件的所有安装和升级都来自您在安装配置包期间选择的主要版本的发布系列（请参阅[添加 MySQL APT 存储库](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#apt-repo-setup)）。但是，您可以随时通过重新配置已安装的配置包来切换到另一个受支持的主要版本系列。使用以下命令：

```terminal
$> sudo dpkg-reconfigure mysql-apt-config
```

然后会出现一个对话框，要求您选择所需的主要版本。做出选择并选择**Ok**。返回命令提示符后，使用以下命令从 MySQL APT 存储库更新包信息：

```terminal
$> sudo apt-get update
```

**下次使用apt-get install**命令 时，将安装所选系列中的最新版本。

您可以使用相同的方法更改要与 MySQL APT 存储库一起安装的任何其他 MySQL 组件的版本。

## 安装其他 MySQL 产品和组件

您可以使用 APT 从 MySQL APT 存储库安装 MySQL 的各个组件。假设您系统的存储库列表中已经有 MySQL APT 存储库（有关说明，请参阅 [添加 MySQL APT 存储库](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#apt-repo-setup)），首先，使用以下命令从 MySQL APT 存储库获取最新的包信息：

```terminal
$> sudo apt-get update
```

使用以下命令安装您选择的任何包，替换*`package-name`*为包的名称（[这里](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#repo-qg-apt-available)是可用包的列表）：

```terminal
$> sudo apt-get install package-name
```

例如，要安装 MySQL Workbench：

```terminal
$> sudo apt-get install mysql-workbench-community
```

要安装共享客户端库：

```terminal
$> sudo apt-get install libmysqlclient21
```

## 使用 MySQL APT 存储库从源安装 MySQL

> 此功能仅在 64 位系统上受支持。

您可以下载 MySQL 的源代码并使用 MySQL APT 存储库构建它：

1. 将 MySQL APT 存储库添加到系统的存储库列表并选择您想要的主要版本系列（有关说明，请参阅 [添加 MySQL APT 存储库](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#apt-repo-setup)）。

2. 使用以下命令从 MySQL APT 存储库更新包信息（*此步骤是强制性的*）：

   ```terminal
   $> sudo apt-get update
   ```

3. 安装构建过程依赖的包：

   ```terminal
   $> sudo apt-get build-dep mysql-server
   ```

   

4. 下载 MySQL 主要组件的源代码，然后构建它们（在您希望下载文件和构建所在的文件夹中运行此命令）：

   ```terminal
   $> apt-get source -b mysql-server
   ```

   `deb`创建用于安装各种 MySQL 组件的包。

5. `deb`为您需要的 MySQL 组件 选择包并使用以下命令安装它们：

   ```terminal
   $> sudo dpkg -i package-name.deb
   ```

   请注意，MySQL 包之间存在依赖关系。对于 MySQL 服务器的基本安装，请按照以下步骤安装数据库公共文件包、客户端包、客户端元包、服务器包和服务器元包（按此顺序）：

   - 使用以下命令预配置 MySQL 服务器包：

     ```terminal
     $> sudo dpkg-preconfigure mysql-community-server_version-and-platform-specific-part.deb
     ```

     您将被要求为您的 MySQL 安装提供 root 用户的密码；[请参阅上面使用 APT 安装 MySQL 中](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#repo-qg-apt-installing)给出的有关 root 密码的重要信息 。您可能还会被问到有关安装的其他问题。

   - 使用单个命令安装所需的软件包：

     ```terminal
     $> sudo dpkg -i mysql-{common,community-client,client,community-server,server}_*.deb
     ```

   - 如果 **dpkg警告您未满足的依赖关系，您可以使用****apt-get**修复它们 ：

     ```terminal
     sudo apt-get -f install
     ```

   以下是文件在系统上的安装位置：

   - 所有配置文件（如 `my.cnf`）都在 `/etc/mysql`
   - 所有二进制文件、库、头文件等都在 `/usr/bin`和 `/usr/sbin`
   - 数据目录在 `/var/lib/mysql`

另请参阅 [启动和停止 MySQL 服务器](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#repo-qg-apt-starting-and-stopping-server)中给出的信息。

## 使用 MySQL APT 存储库升级 MySQL

按照以下步骤，使用 MySQL APT 存储库为您的 MySQL 安装执行就地升级（即替换旧版本，然后使用旧数据文件运行新版本）：

1. 确保您的系统存储库列表中已经有 MySQL APT 存储库（有关说明，请参阅[添加 MySQL APT 存储库](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#apt-repo-setup) ）。

2. 通过运行以下命令确保您在 MySQL APT 存储库中拥有最新的软件包信息：

   ```terminal
   $> sudo apt-get update
   ```

   

3. 请注意，默认情况下，MySQL APT 存储库会将 MySQL 更新为您在 [将 MySQL APT 存储库添加到系统](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#apt-repo-setup)时选择的发行系列。如果您想升级到另一个发布系列，请按照 [选择主要发布版本](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/index.html#repo-qg-apt-select-series)中给出的步骤进行选择。

   作为一般规则，要从一个版本系列升级到另一个系列，请转到下一个系列，而不是跳过一个系列。例如，如果您当前正在运行 MySQL 5.6 并希望升级到更新的系列，请先升级到 MySQL 5.7，然后再升级到 8.0。

   > - 有关从 MySQL 5.6 升级到 5.7 的重要信息，请参阅 [从 MySQL 5.6 升级到 5.7](https://dev.mysql.com/doc/refman/5.7/en/upgrading-from-previous-series.html)。
   > - 有关从 MySQL 5.7 升级到 8.0 的重要信息，请参阅 [从 MySQL 5.7 升级到 8.0](https://dev.mysql.com/doc/refman/8.0/en/upgrading-from-previous-series.html)。
   > - MySQL APT 存储库不支持就地降级 MySQL。按照 [降级 MySQL](https://dev.mysql.com/doc/refman/8.0/en/downgrading.html)中的说明进行操作。

4. 通过以下命令升级 MySQL：

   ```terminal
   $> sudo apt-get install mysql-server
   ```

   如果有更新的版本可用，则升级 MySQL 服务器、客户端和数据库公用文件。要升级任何其他 MySQL 包，请使用相同的**apt-get install** 命令并提供要升级的包的名称：

   ```terminal
   $> sudo apt-get install package-name
   ```

   要查看您从 MySQL APT 存储库安装的软件包的名称，请使用以下命令：

   ```terminal
   $> dpkg -l | grep mysql | grep ii
   ```

   > 如果您使用**apt-get upgrade** 执行系统范围的升级，则只有 MySQL 库和开发包会升级为较新的版本（如果可用）。要升级其他组件，包括服务器、客户端、测试套件等，请使用 **apt-get install** 命令。

5. MySQL 服务器总是在 APT 更新后重新启动。在 MySQL 8.0.16 之前，请在服务器重新启动后运行**mysql_upgrade**以检查并可能解决旧数据与升级软件之间的任何不兼容问题。**mysql_upgrade**还执行其他功能；有关详细信息，请参阅[mysql_upgrade — 检查和升级 MySQL 表](https://dev.mysql.com/doc/refman/8.0/en/mysql-upgrade.html)。从 MySQL 8.0.16 开始，不需要此步骤，因为服务器执行之前由 **mysql_upgrade**处理的所有任务。

## 使用 APT 删除 MySQL

要卸载 MySQL 服务器和已使用 MySQL APT 存储库安装的相关组件，首先使用以下命令删除 MySQL 服务器：

```terminal
$> sudo apt-get remove mysql-server
```

然后，删除随 MySQL 服务器自动安装的任何其他软件：

```terminal
$> sudo apt-get autoremove
```

要卸载其他组件，请使用以下命令，替换**`package-name`**为要删除的组件的包名称：

```terminal
$> sudo apt-get remove package-name
```

要查看从 MySQL APT 存储库安装的软件包列表，请使用以下命令：

```terminal
$> dpkg -l | grep mysql | grep ii
```

