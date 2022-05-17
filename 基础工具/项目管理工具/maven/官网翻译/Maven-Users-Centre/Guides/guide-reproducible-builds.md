## 配置可重现的构建

> https://maven.apache.org/guides/mini/guide-reproducible-builds.html#configuring-for-reproducible-builds

### 什么是可重现的构建？

[可重现的构建](https://reproducible-builds.org/)是一组软件开发实践，它们创建了从源代码到二进制代码的可独立验证的路径。如果给定相同的源代码、构建环境和构建指令，任何一方都可以**逐位**重建所有指定工件的相同副本，则构建是**可重现的**。

> **Reproducible Builds**项目背后的动机是允许验证在此编译过程中没有引入任何漏洞或后门。通过承诺始终从给定来源生成相同的结果，这允许多个第三方就“正确”结果达成共识，突出显示任何可疑且值得审查的偏差。

[Reproducible Central](https://github.com/jvm-repo-rebuild/reproducible-central) 列出了通过独立于中央存储库中发布的参考构建进行重建而检查为可再现的项目版本。

### 如何配置我的 Maven 构建？

没有 Maven 版本先决条件。一切都发生在插件级别：

1. 将您的插件升级到可重现的版本：轻松检测[所需的升级](https://maven.apache.org/plugins/maven-artifact-plugin/plugin-issues.html)，运行
   
   ```powershell
   mvn artifact:check-buildplan
   ```

2. 通过向项目的 `pom.xml` 添加 `project.build.outputTimestamp` 属性，为插件启用 Reproducible Builds 模式：
   
   ```xml
      <properties>
        <project.build.outputTimestamp>10</project.build.outputTimestamp>
      </properties>
   ```

您已经配置了基本功能。输出现在应该是可重现的。

### 如何测试我的 Maven 构建重现性？

使用[`maven-artifact-plugin` 的 `compare` 目标](https://maven.apache.org/plugins/maven-artifact-plugin/compare-mojo.html)，您可以检查项目的第二个构建是否产生与初始构建相同的输出：

1. 构建和 `install` 您的项目（不要犹豫，定制参数以更好地匹配您的项目）：
   
   ```powershell
   mvn clean install 
   ```

2. 重建（仅 `verify`，不安装）并检查以前的安装：
   
   ```powershell
   mvn clean verify artifact:compare
   ```

### 如何修复我的 Maven 构建重现性

如果在初始设置和 [`artifact:check-buildplan` 自动检查](https://maven.apache.org/plugins/maven-artifact-plugin/plugin-issues.html)后某些内容仍然无法重现：

1. 使用 [diffoscope](https://diffoscope.org/) 查找构建之间的不稳定输出。`artifact:buildinfo` 目标提出了一个带有文件路径的 命令：只需复制/粘贴即可启动。
2. 找到生成此输出的插件。
3. 检查插件的可重现版本是否可用。如果没有，请打开一个问题以帮助插件维护人员在每个插件级别改进 Reproducible Builds 支持。

### 更多细节

Maven 的可重现构建：

- 需要在依赖项中**没有版本范围**，
- 由于换行符不同，通常**在 Windows 和 Unix 上给出不同的结果。**（Windows 上的回车换行，Unix 上的换行）
- 一般取决于用于编译的 **JDK 的主要版本**。（即使定义了源/目标，每个主要的 JDK 版本都会更改生成的字节码）

有关详细说明，请参阅[Maven "Reproducible/Verifiable Builds" Wiki page](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=74682318)。

### FAQ

- Q. `pom.xml` 中的 `project.build.outputTimestamp`属性可以在发布时自动更新吗？
  
  答：是的。
  
  详细信息取决于您的发布流程工具：
  
  - 如果您使用[maven-release-plugin](https://maven.apache.org/plugins/maven-release-plugin/)，则需要**版本 3.0.0-M1 或更高版本**：在发布期间，它会在更新版本的同一提交中自动更新 `pom.xml` 中的时间戳值，
  - 如果您有自定义发布流程工具，则需要将该功能添加到您的发布工具中。请注意，如果您在自定义发布脚本中使用 `versions-maven-plugin`，从发布 2.9.0 开始，[`versions:set`目标会更新属性](https://github.com/mojohaus/versions-maven-plugin/issues/453)。
  - 有些人倾向于使用 Git 最后一个提交的时间戳，比如 [git-commit-id-maven-plugin](https://github.com/git-commit-id/git-commit-id-maven-plugin) 中的 `${git.commit.time}`，而不是在 `pom.xml` 中明确地写入时间戳。

不要犹豫，在https://maven.apache.org/mailing-lists.html上分享您的问题或解决方案。

- Q. 哪些额外的插件需要为 Reproducible Builds 更新？
  
  A. 以下一个简化的列表：
  
  | **插件**                                                                                                                           | **最小版本** | **说明**                                                                                           |
  | -------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------ |
  | [maven-assembly-plugin](https://maven.apache.org/plugins/maven-assembly-plugin/)                                                 | 3.2.0    |                                                                                                  |
  | [maven-jar-plugin](https://maven.apache.org/plugins/maven-jar-plugin/)                                                           | 3.2.0    |                                                                                                  |
  | [maven-ejb-plugin](https://maven.apache.org/plugins/maven-ejb-plugin/)                                                           | 3.1.0    |                                                                                                  |
  | [maven-javadoc-plugin](https://maven.apache.org/plugins/maven-javadoc-plugin/)                                                   | 3.2.0    | 还需要 `pluginManagement` <br/>中的<br/>`<notimestamp>true</notimestamp>`<br/>（用于从插件和报告中自动使用）         |
  | [maven-plugin-plugin](https://maven.apache.org/plugin-tools/maven-plugin-plugin/)                                                | 3.5.1    |                                                                                                  |
  | [maven-remote-resources-plugin](https://maven.apache.org/plugins/maven-remote-resources-plugin/)                                 | 1.7.0    |                                                                                                  |
  | [maven-shade-plugin](https://maven.apache.org/plugins/maven-shade-plugin/)                                                       | 3.2.3    |                                                                                                  |
  | [maven-site-plugin](https://maven.apache.org/plugins/maven-site-plugin/)                                                         | 3.9.0    |                                                                                                  |
  | [maven-source-plugin](https://maven.apache.org/plugins/maven-source-plugin/)                                                     | 3.2.1    |                                                                                                  |
  | [maven-war-plugin](https://maven.apache.org/plugins/maven-war-plugin/)                                                           | 3.3.1    |                                                                                                  |
  | [maven-ear-plugin](https://maven.apache.org/plugins/maven-ear-plugin/)                                                           | 3.1.0    |                                                                                                  |
  | [plexus-component-metadata](https://codehaus-plexus.github.io/plexus-containers/plexus-component-metadata/)                      | 2.1.0    |                                                                                                  |
  | [bnd-maven-plugin](https://github.com/bndtools/bnd/tree/master/maven/bnd-maven-plugin)                                           |          | 见 [配置说明](https://github.com/bndtools/bnd/tree/master/maven/bnd-maven-plugin#reproducible-builds) |
  | Apache Felix [maven-bundle-plugin](https://felix.apache.org/documentation/subprojects/apache-felix-maven-bundle-plugin-bnd.html) | 5.1.3    |                                                                                                  |
  | Eclipse [Sisu Maven Plugin](https://www.eclipse.org/sisu/docs/api/org.eclipse.sisu.mojos/)                                       | 0.3.4    |                                                                                                  |
  | [springboot-maven-plugin](https://docs.spring.io/spring-boot/docs/current/maven-plugin/)                                         | 2.3.0-M4 | 还没有 war（因为 `maven-war-plugin` 还不行）                                                               |
  | MojoHaus [properties-maven-plugin](https://www.mojohaus.org/properties-maven-plugin/)                                            | 1.1.0    |                                                                                                  |
  
  有关更多详细信息，请参阅[Maven “Reproducible/Verifiable Builds” Wiki 页面](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=74682318#Reproducible/VerifiableBuilds-Whataretheissuestosolve?)
