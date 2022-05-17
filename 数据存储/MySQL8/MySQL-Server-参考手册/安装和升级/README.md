# 安装和升级 MySQL

> https://dev.mysql.com/doc/refman/8.0/en/installing.html

本章介绍如何**获取和安装** MySQL。以下是该过程的摘要，后面的部分提供了详细信息。如果您不是第一次安装 MySQL，而是计划将现有版本的 MySQL **升级**到较新的版本，请参阅 [第 2.11 节，“升级 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/upgrading.html)，了解有关升级过程和升级前应考虑的问题的信息。

如果您有兴趣从另一个数据库系统**迁移**到 MySQL，请参阅[第 A.8 节，“MySQL 8.0 常见问题解答：迁移”](https://dev.mysql.com/doc/refman/8.0/en/faqs-migration.html)，其中包含有关迁移问题的一些常见问题的答案。

## 安装步骤

MySQL 的安装通常遵循此处列出的步骤：

1. **确定 MySQL 是否在您的平台上运行并受支持。**

   请注意，并非所有平台都同样适合运行 MySQL，并且并非所有已知运行 MySQL 的平台都得到 Oracle Corporation 的正式支持。有关官方支持的平台的信息，请参阅 MySQL 网站上的 [MySQL 数据库支持的平台](https://www.mysql.com/support/supportedplatforms/database.html)。

2. **选择要安装的发行版。**

   有多个**版本**的 MySQL 可用，并且大多数都以多种**分发格式**提供。您可以从包含二进制（预编译）程序或源代码的预打包发行版中进行选择。如有疑问，请使用二进制分发。Oracle 还为希望了解最新开发和测试新代码的人提供对 MySQL 源代码的访问。要确定您应该使用哪个版本和类型的发行版，请参阅[第 2.1.2 节，“要安装哪个 MySQL 版本和发行版”](https://dev.mysql.com/doc/refman/8.0/en/which-version.html)。

3. **下载您要安装的发行版。**

   有关说明，请参阅[第 2.1.3 节，“如何获取 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/getting-mysql.html)。要验证分发的完整性，请使用 [第 2.1.4 节“使用 MD5 校验和或 GnuPG 验证包完整性”](https://dev.mysql.com/doc/refman/8.0/en/verifying-package-integrity.html)中的说明。

4. **安装发行版。**

   要从二进制发行版安装 MySQL，请使用[第 2.2 节，“使用通用二进制文件在 Unix/Linux 上安装 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html)中的说明。或者，使用 [安全部署指南](https://dev.mysql.com/doc/mysql-secure-deployment-guide/8.0/en/)，它提供了部署 MySQL Enterprise Edition Server 的通用二进制发行版的过程，该发行版具有管理 MySQL 安装安全性的功能。

   要从源代码分发版或当前开发源代码树安装 MySQL，请使用 [第 2.9 节，“从源代码安装 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/source-installation.html)中的说明。

5. **执行任何必要的安装后设置。**

   安装 MySQL 后，请参阅[第 2.10 节，“安装后设置和测试”](https://dev.mysql.com/doc/refman/8.0/en/postinstallation.html) 以获取有关确保 MySQL 服务器正常工作的信息。另请参阅 [第 2.10.4 节，“保护初始 MySQL 帐户”](https://dev.mysql.com/doc/refman/8.0/en/default-privileges.html)中提供的信息。本节介绍如何保护初始 MySQL`root`用户帐户，该帐户在您分配密码之前*没有密码。*无论您使用二进制还是源代码分发安装 MySQL，该部分都适用。

6. 如果要运行 MySQL 基准测试脚本，必须提供对 MySQL 的 Perl 支持。请参阅[第 2.13 节，“Perl 安装说明”](https://dev.mysql.com/doc/refman/8.0/en/perl-support.html)。

## 不同平台和环境

在不同平台和环境上安装 MySQL 的说明可在不同平台上获得：

- **Unix、Linux、FreeBSD**

  有关使用通用二进制文件（例如， `.tar.gz`包）在大多数 Linux 和 Unix 平台上安装 MySQL 的说明，请参阅 [第 2.2 节，“使用通用二进制文件在 Unix/Linux 上安装 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html)。

  有关完全从源代码分发或源代码存储库构建 MySQL 的信息，请参阅 [第 2.9 节，“从源代码安装 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/source-installation.html)

  有关安装、配置和从源代码构建的特定平台帮助，请参阅相应的平台部分：

  - Linux，包括有关分发特定方法的说明，请参阅 [第 2.5 节，“在 Linux 上安装 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/linux-installation.html)。
  - IBM AIX，请参阅[第 2.7 节，“在 Solaris 上安装 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/solaris-installation.html)。
  - FreeBSD，请参阅[第 2.8 节，“在 FreeBSD 上安装 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/freebsd-installation.html)。

- **微软Windows**

  有关使用 MySQL Installer 或 Zipped 二进制文件在 Microsoft Windows 上安装 MySQL 的说明，请参阅 [第 2.3 节，“在 Microsoft Windows 上安装 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/windows-installation.html)。

  有关使用 Microsoft Visual Studio 从源代码构建 MySQL 的详细信息和说明，请参阅 [第 2.9 节，“从源代码安装 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/source-installation.html)。

- **苹果系统**

  要在 macOS 上安装，包括使用二进制包和原生 PKG 格式，请参阅 [第 2.4 节，“在 macOS 上安装 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/macos-installation.html)。

  有关使用 macOS 启动守护程序自动启动和停止 MySQL 的信息，请参阅 [第 2.4.3 节，“安装和使用 MySQL 启动守护程序”](https://dev.mysql.com/doc/refman/8.0/en/macos-installation-launchd.html)。

  有关 MySQL 首选项窗格的信息，请参阅 [第 2.4.4 节，“安装和使用 MySQL 首选项窗格”](https://dev.mysql.com/doc/refman/8.0/en/macos-installation-prefpane.html)。

***

## 详细信息

[2.1 General Installation Guidance](https://dev.mysql.com/doc/refman/8.0/en/general-installation-issues.html)

[2.2 Installing MySQL on Unix/Linux Using Generic Binaries](https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html)

[2.3 Installing MySQL on Microsoft Windows](https://dev.mysql.com/doc/refman/8.0/en/windows-installation.html)

[2.4 Installing MySQL on macOS](https://dev.mysql.com/doc/refman/8.0/en/macos-installation.html)

[2.5 在 Linux 上安装](数据存储/MySQL8/MySQL-Server-参考手册/安装和升级/在Linux上安装MySQL/)

[2.6 Installing MySQL Using Unbreakable Linux Network (ULN)](https://dev.mysql.com/doc/refman/8.0/en/uln-installation.html)

[2.7 Installing MySQL on Solaris](https://dev.mysql.com/doc/refman/8.0/en/solaris-installation.html)

[2.8 Installing MySQL on FreeBSD](https://dev.mysql.com/doc/refman/8.0/en/freebsd-installation.html)

[2.9 Installing MySQL from Source](https://dev.mysql.com/doc/refman/8.0/en/source-installation.html)

[2.10 安装后设置和测试](https://dev.mysql.com/doc/refman/8.0/en/postinstallation.html)

[2.11 Upgrading MySQL](https://dev.mysql.com/doc/refman/8.0/en/upgrading.html)

[2.12 Downgrading MySQL](https://dev.mysql.com/doc/refman/8.0/en/downgrading.html)

[2.13 Perl Installation Notes](https://dev.mysql.com/doc/refman/8.0/en/perl-support.html)

***

[CentOS 8 上安装和升级 mysql8.0](数据存储/MySQL8/MySQL-Server-参考手册/安装和升级/安装和升级.md)

