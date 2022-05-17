## 最佳实践 - 使用存储库管理器

> https://maven.apache.org/repository-management.html

存储库管理器是一个专用的服务器应用程序，旨在管理二进制组件的存储库。

对于任何重要的 Maven 使用，使用存储库管理器都被认为是必要的最佳实践。

### 目的

存储库管理器服务于这些基本目的：

- 充当公共 Maven 存储库的专用代理服务器（请参阅 [Maven 镜像设置指南](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/repositories/guide-mirror-settings.md）
- 提供存储库作为 Maven 项目输出的部署目标

### 优点和特点

使用存储库管理器具有以下优点和特性：

- 显着减少远程存储库的下载次数，节省时间和带宽，从而提高构建性能
- 由于减少了对外部存储库的依赖，提高了构建稳定性
- 提高与远程 SNAPSHOT 存储库交互的性能
- 控制消耗和提供的人工制品的潜力
- 创建一个中央存储和访问关于它们的工件和元数据，将构建输出暴露给消费者，例如其他项目和开发人员，还有 QA 或运营团队甚至客户
- 提供了一个有效的平台，用于在您的组织内外交换二进制工件，而无需从源代码构建工件

### 可用的存储库管理器

以下开源和商业存储库管理器列表（按字母顺序）已知支持 Maven 使用的存储库格式。请参阅相应的链接网站，以获取有关一般存储库管理和这些产品提供的功能的更多信息。

- [Apache Archiva](https://archiva.apache.org/) (开源)
- [Bytesafe](https://bytesafe.dev/) (commercial)
- [CloudRepo](https://www.cloudrepo.io/) (commercial)
- [Cloudsmith Package](https://www.cloudsmith.io/) (commercial)
- [Dist](https://www.dist.cloud/) (commercial)
- [Inedo ProGet](https://inedo.com/proget) (commercial)
- [JFrog Artifactory Open Source](https://www.jfrog.com/open-source) (开源)
- [JFrog Artifactory Pro](https://www.jfrog.com/artifactory/) (commercial)
- [MyGet](https://www.myget.org/) (commercial)
- [Sonatype Nexus OSS](https://www.sonatype.org/nexus/go/) (开源)
- [Sonatype Nexus Pro](https://links.sonatype.com/products/nexus/pro/home) (commercial)
- [packagecloud.io](https://packagecloud.io/) (commercial)
- [Reposilite](https://reposilite.com/) (开源)
