## 设置参考

## 介绍

### 快速概览

`settings.xml` 文件中的 `settings` 元素包含用于定义以各种方式配置 Maven 执行的值的元素，类似于 `pom.xml`，但不应捆绑到任何特定项目或分发给受众。其中包括本地存储库位置、备用远程存储库服务器和身份验证信息等值。

`settings.xml` 文件可能存在两个**位置**：

- Maven 安装：`${maven.home}/conf/settings.xml`
- 用户安装：`${user.home}/.m2/settings.xml`

前一个 `settings.xml` 也称为**全局设置**，后一个 `settings.xml` 称为**用户设置**。如果两个文件都存在，它们的内容将被合并，用户特定 `settings.xml` 的占主导地位。

提示：如果您需要从头开始创建特定于用户的设置，最简单的方法是将全局设置从 Maven 安装复制到您的 `${user.home}/.m2` 目录。Maven 的默认 `settings.xml` 模板是带有注释和示例的模板，因此您可以快速调整它以满足您的需求。

以下是 `settings` 下的**顶级元素**的概述：

```xml
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
      <localRepository/>
      <interactiveMode/>
      <offline/>
      <pluginGroups/>
      <servers/>
      <mirrors/>
      <proxies/>
      <profiles/>
      <activeProfiles/>
    </settings>
```

`settings.xml` 的内容可以使用以下**表达式**进行插值：

1. `${user.home}` 和所有其他系统属性（自 Maven 3.0 起）
2. `${env.HOME}` 等环境变量

请注意，在 `settings.xml` 中的 `profiles` 中定义的属性不能用于插值。

## 设置详情

### 简单值

一半的顶级 `settings` 元素是简单值，代表一系列值，这些值描述了构建系统的全时活动元素。

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository>${user.home}/.m2/repository</localRepository>
  <interactiveMode>true</interactiveMode>
  <offline>false</offline>
  ...
</settings>
```

- **localRepository**：此值是此构建系统的**本地存储库**的路径。默认值为 `${user.home}/.m2/repository`。这个元素对于主构建服务器尤其有用，主构建服务器允许所有登录用户从一个公共的本地存储库进行构建。
- **interactiveMode**：`true`，如果 Maven 应该尝试与用户交互以获取输入。`false`，如果不是。默认为 `true`.
- **offline**：`true`，如果这个构建系统应该在离线模式下运行，默认为 `false`。由于网络设置或安全原因，此元素对于无法连接到远程存储库的构建服务器很有用。

### 插件组

此元素包含一个 `pluginGroup` 元素列表，每个元素都包含一个 `groupId`。使用插件且命令行中未提供 `groupId` 时会搜索该列表。此列表自动包含 `org.apache.maven.plugins`和 `org.codehaus.mojo`。

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  ...
  <pluginGroups>
    <pluginGroup>org.eclipse.jetty</pluginGroup>
  </pluginGroups>
  ...
</settings>
```

例如，给定上述设置，Maven 命令行可以使用截断的命令执行  `org.eclipse.jetty:jetty-maven-plugin:run`：

1. `mvn jetty:run`

### 服务器

用于下载和部署的存储库由 POM的 [`repositories`](https://maven.apache.org/pom.html#Repositories) 和 [`distributionManagement`](https://maven.apache.org/pom.html#Distribution_Management) 元素定义。但是，某些设置，比如 `username` 和 `password`， 不应与 `pom.xml` 一起分发。此类信息应存在于 `settings.xml` 中的构建服务器上。

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  ...
  <servers>
    <server>
      <id>server001</id>
      <username>my_login</username>
      <password>my_password</password>
      <privateKey>${user.home}/.ssh/id_dsa</privateKey>
      <passphrase>some_passphrase</passphrase>
      <filePermissions>664</filePermissions>
      <directoryPermissions>775</directoryPermissions>
      <configuration></configuration>
    </server>
  </servers>
  ...
</settings>
```

- **id**：这是与 Maven 尝试连接的存储库/镜像的 `id` 元素匹配的服务器 ID （不是登录用户的 ID） 。
- **username** , **password**：这些元素显示为一对，表示向此服务器进行身份验证所需的登录名和密码。
- **privateKey** , **passphrase**：与前两个元素一样，这一对指定私钥的路径（默认为 `${user.home}/.ssh/id_dsa`）和密码短语 `passphrase`（如果需要）。`passphrase` 和  `password` 元素将来可能会被外部化，但现在它们必须在 `settings.xml` 文件中设置为纯文本。
- **filePermissions** , **directoryPermissions**：在部署时创建存储库文件或目录时，这些是要使用的权限。每个的合法值是对应于 *nix 文件权限的三位数字，例如 664 或 775。

> 注意：如果您使用私钥登录服务器，请确保省略 `<password>` 元素。否则，密钥将被忽略。

#### 密码加密

2.1.0+ 中添加了一项新功能 - 服务器密码和密码短语加密。查看[此页面上](https://maven.apache.org/guides/mini/guide-encryption.html)的详细信息。

### 镜像

```xml
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
      ...
      <mirrors>
        <mirror>
          <id>planetmirror.com</id>
          <name>PlanetMirror Australia</name>
          <url>http://downloads.planetmirror.com/pub/maven2</url>
          <mirrorOf>central</mirrorOf>
        </mirror>
      </mirrors>
      ...
    </settings>
```

- **id** , **name**：此镜像的唯一标识符和用户友好名称。`id` 用于区分 `mirror` 元素，并在连接到镜像时从 [`<servers>`](https://maven.apache.org/settings.html#Servers) 部分中 选择相应的凭据 。
- **url**：此镜像的基本 URL。构建系统将使用此 URL 连接到存储库，而不是原始存储库 URL。
- **mirrorOf**：这是镜像的存储库 `id`。例如，要指向 Maven `central` 存储库 ( `https://repo.maven.apache.org/maven2/`) 的镜像，请将此元素设置为 `central`。更高级的映射，如`repo1,repo2` 或 `*,!inhouse` 也是可能的。这一定不能与镜像 `id` 相配。

更深入的镜像介绍，请阅读[镜像设置指南](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/repositories/guide-mirror-settings.md)。

### 代理

```xml
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
      ...
      <proxies>
        <proxy>
          <id>myproxy</id>
          <active>true</active>
          <protocol>http</protocol>
          <host>proxy.somewhere.com</host>
          <port>8080</port>
          <username>proxyuser</username>
          <password>somepassword</password>
          <nonProxyHosts>*.google.com|ibiblio.org</nonProxyHosts>
        </proxy>
      </proxies>
      ...
    </settings>
```

- **id**：此代理的唯一标识符。这用于区分 `proxy` 元素。
- **active**：`true`，如果此代理处于活动状态。这对于声明一组代理很有用，但一次只能有一个处于活动状态。
- **protocol** , **host** , **port**：代理的 `protocol://host:port`，被分隔成离散的元素。
- **username** , **password**：这些元素显示为一对，表示对此代理服务器进行身份验证所需的登录名和密码。
- **nonProxyHosts**：这是不应被代理的主机列表。列表的分隔符是代理服务器的预期类型；上面的示例是管道分隔的 - 逗号分隔也很常见。

### profiles

`settings.xml` 中的 `profile` 元素是 `pom.xml` `profile` 元素的截断版本。它由`activation`、 `repositories`、`pluginRepositories` 和 `properties` 元素组成。这些  `profile` 元素只包括这四个元素，因为它们与整个构建系统（这是 `settings.xml` 文件的角色）有关，而不是与单个项目对象模型设置有关。

如果一个 `profile` 在 `settings` 中处于活动状态，则其值将覆盖 POM 或 `profiles.xml` 文件中任何等效的 ID profiles。

#### 激活

激活是一个 profile 的关键。与 POM 的 `profiles` 一样，profile 的强大之处在于它仅在某些情况下修改某些值的能力。这些情况是通过一个 `activation` 元素指定的。

```xml
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
      ...
      <profiles>
        <profile>
          <id>test</id>
          <activation>
            <activeByDefault>false</activeByDefault>
            <jdk>1.5</jdk>
            <os>
              <name>Windows XP</name>
              <family>Windows</family>
              <arch>x86</arch>
              <version>5.1.2600</version>
            </os>
            <property>
              <name>mavenVersion</name>
              <value>2.0.3</value>
            </property>
            <file>
              <exists>${basedir}/file2.properties</exists>
              <missing>${basedir}/file1.properties</missing>
            </file>
          </activation>
          ...
        </profile>
      </profiles>
      ...
    </settings>
```

当所有指定的条件都满足时，激活就会发生，尽管不是一次都需要。

- **jdk**：`activation` 在 `jdk` 元素中有一个内置的、以 Java 为中心的检查 。如果测试在与给定前缀匹配的 jdk 版本号下运行，这将激活。在上面的例子中， `1.5.0_06`将匹配。还支持范围。有关支持的范围的更多详细信息，请参阅 [maven-enforcer-plugin](https://maven.apache.org/enforcer/enforcer-rules/versionRanges.html) 。
- **os**：`os` 元素可以定义一些操作系统特定的属性，如上所示。有关操作系统值的更多详细信息，请参阅 [maven-enforcer-plugin](https://maven.apache.org/plugins/maven-enforcer-plugin/rules/requireOS.html) 。
- **property**：如果 Maven 检测到相应 `name=value` 对的属性（一个可以在 POM 中通过 `${name}` 解引用的值），则 `profile` 将激活 。
- **file**：最后，给定的文件名可能会由于文件的 `existence` 或 `missing` 而激活 `profile`。

`activation` 元素不是 `profile` 激活的唯一方式。`settings.xml` 文件的元素 `activeProfile` 可能包含 profile 的 `id`。它们也可以通过命令行使用 `-P` 标志后的逗号分隔列表显式激活（例如 `-P test`）。

*要查看哪个配置文件将在某个构建中激活，请使用* `maven-help-plugin`.

```powershell
    mvn help:active-profiles
```

#### 属性

Maven 属性是**值占位符**，就像 Ant 中的属性一样。它们的值可以在 POM 中的任何地方使用符号 `${X}` 进行访问，其中 `X` 是属性。它们有五种不同的风格，都可以从 `settings.xml` 文件中访问：

1. `env.X`: 在变量前加上 `env`。将返回 shell 的环境变量。例如，`${env.PATH}` 包含 `$path` 环境变量（在 Windows 中是 `%PATH%`）。

2. `project.x`：POM 中的点 (`.`) 标记的路径将包含相应元素的值。例如： `<project><version>1.0</version></project>`可通过 `${project.version}` 访问。

3. `settings.x`: `settings.xml` 中的点 (`.`) 标记的路径将包含相应元素的值。例如： `<settings><offline>false</offline></settings>`可通过 `${settings.offline}` 访问。

4. Java 系统属性：可通过 `java.lang.System.getProperties()` 访问的所有属性都可以作为 POM 属性使用，例如`${java.home}`.

5. `x`: 在 `<properties />` 元素或外部文件中设置，该值可以用作 `${someVar}`。

```xml
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
      ...
      <profiles>
        <profile>
          ...
          <properties>
            <user.install>${user.home}/our-project</user.install>
          </properties>
          ...
        </profile>
      </profiles>
      ...
    </settings>
```

如果此 profile 处于活动状态，则可以从 POM 访问 `${user.install}` 属性。

#### 存储库

存储库是项目的远程集合，Maven 使用它们来填充构建系统的本地存储库。Maven 就是从这个本地存储库中调用它的插件和依赖项。不同的远程存储库可能包含不同的项目，并且在活动的 profile 下，可以搜索匹配的发布或者快照工件。

```xml
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
      ...
      <profiles>
        <profile>
          ...
          <repositories>
            <repository>
              <id>codehausSnapshots</id>
              <name>Codehaus Snapshots</name>
              <releases>
                <enabled>false</enabled>
                <updatePolicy>always</updatePolicy>
                <checksumPolicy>warn</checksumPolicy>
              </releases>
              <snapshots>
                <enabled>true</enabled>
                <updatePolicy>never</updatePolicy>
                <checksumPolicy>fail</checksumPolicy>
              </snapshots>
              <url>http://snapshots.maven.codehaus.org/maven2</url>
              <layout>default</layout>
            </repository>
          </repositories>
          <pluginRepositories>
            <pluginRepository>
              <id>myPluginRepo</id>
              <name>My Plugins repo</name>
              <releases>
                <enabled>true</enabled>
              </releases>
              <snapshots>
                <enabled>false</enabled>
              </snapshots>
              <url>https://maven-central-eu....com/maven2/</url>
            </pluginRepository>
          </pluginRepositories>
          ...
        </profile>
      </profiles>
      ...
    </settings>
```

- **releases**, **snapshots**：这些是针对每种工件类型，发布或快照，的策略。有了这两个集合，POM 可以独立于单个存储库中的其他类型更改每种类型的策略。例如，出于开发目的，可能决定只启用快照下载。
- **enabled**：`true` 或者 `false` 是否为相应的类型（`releases`或`snapshots`）启用此存储库。
- **updatePolicy**：此元素指定尝试更新的频率。Maven 会将本地 POM 的时间戳（存储在存储库的 `maven-metadata` 文件中）与远程进行比较。选项包括：`always`、`daily`（默认）、`interval:X`（其中 X 是以分钟为单位的整数）或`never`.
- **checksumPolicy**：当 Maven 将文件部署到存储库时，它也会部署相应的校验和文件。您的选项是 `ignore`、`fail` 或 `warn` 缺少或不正确的校验和。
- **layout**：在上面对存储库的描述中，提到它们都遵循一个共同的布局。这大多是正确的。Maven 2 的存储库有一个默认布局；然而，Maven 1.x 有不同的布局。使用此元素指定是 `default` 还是 `legacy`。

#### 插件库

存储库是两种主要类型工件的所在地。第一个是用作其他工件的依赖项的工件。这些是驻留在中央的大多数工件。另一种类型的工件是插件。Maven 插件本身就是一种特殊的工件。正因为如此，插件存储库可能与其他存储库分开（尽管我还没有听到有说服力的理由这样做）。在任何情况下，`pluginRepositories` 元素块的结构都与 `repositories` 元素相似。每个 `pluginRepository` 元素都指定了 Maven 可以找到新插件的远程位置。

### 活动配置文件

```xml
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
      ...
      <activeProfiles>
        <activeProfile>env-test</activeProfile>
      </activeProfiles>
    </settings>
```

`settings.xml` 拼图的最后一块是 `activeProfiles` 元素。它包含一组 `activeProfile` 元素，每个元素都有一个  `profile` `id` 的值。无论环境设置如何，任何定义为 `activeProfile` 的 `profile` `id` 都将处于活动状态。如果没有找到匹配的 profile，则不会发生任何事情。例如，如果 `env-test` 是一个 `activeProfile`，则 `pom.xml` (或带有相应 `id` 的 `profile.xml` ) 中的 profile 将处于活动状态。如果未找到此类 profile，则执行将照常继续。
