## 配置 Maven

> https://maven.apache.org/guides/mini/guide-configuring-maven.html

Maven 配置发生在 3 个级别：

- *项目*- 大多数静态配置发生在 `pom.xml`
- *安装*- 这是为 Maven 安装添加一次性的配置
- *用户*- 这是特定用户的特定配置

两者的区别非常明显 - 项目定义了应用于项目的信息，而不管谁构建它，而其他两个都定义了当前环境的设置。

**注意**：安装和用户配置不能用于添加共享项目信息——例如，设置 `<organization>` 或`<distributionManagement>` 公司范围。

为此，您应该让您的项目从公司范围的 parent 继承 `pom.xml`。

您可以在 `${user.home}/.m2/settings.xml` 中指定您的用户配置。配置文件的[完整参考](https://maven.apache.org/maven-settings/settings.html)是可用的。本节将展示**如何进行一些常见的配置**。请注意，该文件不是必需的 - 如果找不到，将使用默认值。

### 配置本地存储库

可以在用户配置中更改本地存储库的位置。默认值为 `${user.home}/.m2/repository/`。

```xml
<settings>
  ...
  <localRepository>/path/to/local/repo/</localRepository>
  ...
</settings>
```

> **注意**：本地存储库必须是绝对路径。

### 配置代理

代理配置也可以在设置文件中指定。

有关更多信息，请参阅[使用代理指南](https://maven.apache.org/guides/mini/guide-proxies.html)。

### 配置并行工件解析

默认情况下，Maven 2.1.0+ 将一次下载多达 5 个工件（来自不同的组）。要更改线程池的大小，请使用 `-Dmaven.artifact.threads`。比如，一次只下载单个工件：

```xml
mvn -Dmaven.artifact.threads=1 verify
```

您可能希望永久设置此选项，在这种情况下您可以使用 `MAVEN_OPTS` 环境变量。比如：

```powershell
export MAVEN_OPTS=-Dmaven.artifact.threads=3
```

### 安全和部署设置

在 `project` 中 `<distributionManagement>` 部分定义**要部署到的存储库** `repository`。但是，您不能将您的**用户名、密码或其他安全设置**放在 `project` 中。出于这个原因，您应该将一个 `server` 定义添加到您自己的 `settings` 中，其 `id` 与项目中的部署存储库 `repository` 的 `id` 相匹配。

此外，某些存储库可能**需要授权**才能下载，因此可以以相同的方式在 `server` 元素中指定相应的设置。

需要哪些设置取决于您部署到的存储库类型。在第一个版本中，默认情况下只支持 SCP 部署和文件部署，因此只需要以下 SCP 配置：

```xml
<settings>
  ...
  <servers>
    <server>
      <id>repo1</id>
      <username>repouser</username>
      <!-- other optional elements:
        <password>my_login_password</password>
        <privateKey>/path/to/identity</privateKey> (default is ~/.ssh/id_dsa)
        <passphrase>my_key_passphrase</passphrase>
      -->
    </server>
  ...
  </servers>
  ...
</settings>
```

要在这些部分中加密密码，请参阅[加密设置](https://maven.apache.org/guides/mini/guide-encryption.html)。

### 为存储库使用镜像

存储库 `repositories` 可以在 `project` 中声明，这意味着如果您有自己的自定义存储库，共享您的项目的人可以轻松获得开箱即用的正确设置。但是，您可能希望在不更改项目文件的情况下为特定存储库使用替代镜像。有关详细信息，请参阅[镜像设置指南](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/repositories/guide-mirror-settings.md)。

### profiles

存储库配置也可以放入`profile` 中。您可以拥有多个 profiles，其中一组处于活动状态，以便您可以轻松切换环境。在[构建 Profiles 简介](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/Maven-Getting-Started-Guide/introduction-to-profiles.md)中阅读有关 profiles 的更多信息。

### 可选配置

Maven 将适用于上述配置的大多数任务，但是如果您在单个项目之外有任何特定于环境的配置，那么您将需要配置 `settings`。以下部分介绍了可用的内容。

#### 设置

Maven 在 Maven 安装和/或用户主目录中有一个设置文件，用于配置环境细节，例如：

- HTTP 代理服务器
- 存储库管理器位置
- 服务器身份验证和密码
- 其他配置属性

有关此文件的信息，请参阅 [Settings 参考](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/settings.md)

#### 安全

从 Maven 2.1.0+ 开始，您可以在 `settings` 文件中加密密码，但是您必须首先配置主密码。有关服务器密码和主密码的更多信息，请参阅[密码加密指南](https://maven.apache.org/guides/mini/guide-encryption.html)。

#### 工具链

从 Maven 2.0.9+ 开始，您可以使用独立于运行 Maven 的特定版本的 JDK 构建项目。有关更多信息，请参阅[使用工具链指南](https://maven.apache.org/guides/mini/guide-using-toolchains.html)。
