## 设置多个存储库

您可以通过两种不同的方式指定使用多个存储库。第一种方法是在 POM 中指定要使用的存储库。这在构建配置文件的内部和外部都受支持：

```xml
<project>
...
  <repositories>
    <repository>
      <id>my-repo1</id>
      <name>your custom repo</name>
      <url>http://jarsm2.dyndns.dk</url>
    </repository>
    <repository>
      <id>my-repo2</id>
      <name>your custom repo</name>
      <url>http://jarsm2.dyndns.dk</url>
    </repository>
  </repositories>
...
</project>
```

**注意**：您还将获得 [Super POM](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html#Super_POM) 中定义的标准存储库集。

您可以指定多个存储库的另一种方法是在 `${user.home}/.m2/settings.xml` 文件或 `${maven.home}/conf/settings.xml` 文件中创建一个 profile，如下所示：

```xml
<settings>
 ...
 <profiles>
   ...
   <profile>
     <id>myprofile</id>
     <repositories>
       <repository>
         <id>my-repo2</id>
         <name>your custom repo</name>
         <url>http://jarsm2.dyndns.dk</url>
       </repository>
     </repositories>
   </profile>
   ...
 </profiles>

 <activeProfiles>
   <activeProfile>myprofile</activeProfile>
 </activeProfiles>
 ...
</settings>
```

如果您在 `profiles` 中指定存储库，您必须记住激活该特定 profile！正如您在上面看到的，我们通过在 `activeProfiles` 元素中注册一个 profile 以使其处于活动状态来做到这一点。

您还可以通过在命令行上执行以下命令来激活这个 profile：

```powershell
mvn -Pmyprofile ...
```

事实上，如果您希望同时激活多个 profiles，`-P` 选项将使用 profiles 的 CSV 列表来激活。

**注意**：设置描述符文档可以在 [Maven 本地设置模型网站](https://maven.apache.org/maven-settings/settings.html)上找到。

### 存储库顺序

对于工件，按照以下顺序查询远程存储库 URLs，直到其中一个返回有效结果：

1. 有效设置：
   
   * 全局 `settings.xml`
   
   * 用户 `settings.xml`

2. 本地有效构建 POM：
   
   * 本地 `pom.xml`
   
   * 父 POM，递归
   
   * 超级 POM

3. 从依赖路径到工件的有效 POM。

对于这些位置中的每一个，首先按照[构建 profiles 简介](https://maven.apache.org/guides/introduction/introduction-to-profiles.html)中概述的顺序查询配置文件中的存储库。

在从存储库下载之前，应用[镜像配置](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/repositories/guide-mirror-settings.md)。

考虑到配置文件的有效设置和本地构建 POM 可以通过 `mvn help:effective-settings` 和 `mvn help:effective-pom -Dverbose` 轻松评审以查看其存储库顺序。
