## 为存储库使用镜像

使用[存储库](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/repositories/)，您可以指定要从哪些位置*下载*某些工件，比如依赖项和 maven 插件。存储库可以[在项目中声明](https://maven.apache.org/guides/mini/guide-multiple-repositories.html)，这意味着如果您有自己的自定义存储库，那么共享您的项目的人可以轻松获得开箱即用的正确设置。但是，您可能希望在不更改项目文件的情况下为特定存储库使用替代镜像。

使用镜像的一些原因是：

- 互联网上有一个同步镜像，地理位置更近，速度更快
- 你想用你自己的内部存储库替换一个特定的存储库，你可以更好地控制内部存储库。
- 您想要运行[存储库管理器](https://maven.apache.org/repository-management.html)来为镜像提供本地缓存，并且需要使用其 URL

要配置给定存储库的镜像，请在设置文件 ( `${user.home}/.m2/settings.xml`) 中提供它，为新存储库提供自己的 `id` 和 `url`，并指定 `mirrorOf` 设置，该设置是要使用其镜像的存储库的 ID。比如，默认包含的主 Maven 中央存储库的 ID 是`central`，因此要使用不同的镜像实例，您需要配置以下内容：

```xml
<settings>
  ...
  <mirrors>
    <mirror>
      <id>other-mirror</id>
      <name>Other Mirror Repository</name>
      <url>https://other-mirror.repo.other-company.com/maven2</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>
  ...
</settings>
```

请注意，**一个给定存储库最多可以有一个镜像**。换句话说，您不能将单个存储库映射到一组都定义了相同的 `<mirrorOf>` 值的镜像。Maven 不会聚合镜像，只会**选择第一个匹配项**。如果要提供多个存储库的组合视图，请改用[存储库管理器](https://maven.apache.org/repository-management.html)。

设置描述符文档可以在[Maven 本地设置模型网站](https://maven.apache.org/maven-settings/settings.html)上找到。

**注意**：官方 Maven 存储库 `https://repo.maven.apache.org/maven2` 由 Sonatype 公司托管，并通过 CDN 在全球范围内分发。

[存储库元数据](https://repo.maven.apache.org/maven2/.meta/repository-metadata.xml)中提供了已知镜像的列表。这些镜像可能有不同的内容，我们不以任何方式支持它们。

## 使用单个存储库

您可以强制 Maven 通过镜像所有存储库请求来使用单个存储库。存储库必须包含所有所需的工件，或者能够将请求代理到其他存储库。当使用带有[Maven 存储库管理器](https://maven.apache.org/repository-management.html)的内部公司存储库来代理外部请求时，此设置最有用。

为此，请设置 `mirrorOf` 为 `*`。

**注意**：此功能仅在 Maven 2.0.5+ 中可用。

```xml
<settings>
  ...
  <mirrors>
    <mirror>
      <id>internal-repository</id>
      <name>Maven Repository Manager running on repo.mycompany.com</name>
      <url>http://repo.mycompany.com/proxy</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
  ...
</settings>
```

## 高级镜像规范

一个镜像可以处理多个存储库。这通常与存储库管理器一起使用，它可以轻松集中配置后面的存储库列表。

语法：

- `*`匹配所有 repo ids。
- `external:*` 匹配所有存储库，除了那些使用 localhost 或基于文件的存储库。当您要排除为集成测试定义的重定向存储库时使用此选项。
- 从 Maven 3.8.0 开始，`external:http:*` 匹配所有使用 HTTP 的存储库，除了使用 localhost 的存储库。
- 可以使用逗号作为分隔符指定多个存储库
- 感叹号可以与上述通配符之一结合使用以排除存储库 ID

注意不要在逗号分隔列表中的标识符或通配符周围包含额外的空格。比如，将 `<mirrorOf>` 设置为的镜像 `!repo1, *` 不会镜像任何内容，而 `!repo1,*` 将镜像除 `repo1` 之外的所有内容。

通配符在以逗号分隔的存储库标识符列表中的位置并不重要，因为通配符会延迟进一步处理，并且显式包含或排除会停止处理，从而推翻任何通配符匹配。

当您使用高级语法并配置多个镜像时，声明顺序很重要。当 Maven 查找某个存储库的镜像时，它首先检查 `<mirrorOf>` 与存储库标识符完全匹配的镜像。如果没有找到直接匹配，Maven 会根据上述规则（如果有）选择第一个匹配的镜像声明。因此，您可以通过更改 `settings.xml` 中定义的顺序来影响匹配顺序。

示例：

- `*`= 一切
- `external:*`= 不在 localhost 上且不基于文件的所有内容。
- `repo,repo1`= `repo` 或 `repo1`
- `*,!repo1`= 除 `repo1` 外的所有内容

```xml
<settings>
  ...
  <mirrors>
    <mirror>
      <id>internal-repository</id>
      <name>Maven Repository Manager running on repo.mycompany.com</name>
      <url>http://repo.mycompany.com/proxy</url>
      <mirrorOf>external:*,!foo</mirrorOf>
    </mirror>
    <mirror>
      <id>foo-repository</id>
      <name>Foo</name>
      <url>http://repo.mycompany.com/foo</url>
      <mirrorOf>foo</mirrorOf>
    </mirror>
  </mirrors>
  ...
</settings>
```

## 创建自己的镜像

中央存储库的大小[正在稳步增长](http://search.maven.org/stats)。为了节省我们的带宽和您的时间，不允许镜像整个中央存储库。（这样做会让你自动被禁止。）相反，我们建议您将[存储库管理器](https://maven.apache.org/repository-management.html)设置为代理。

如果您真的想成为官方镜像，请在 [MVNCENTRAL](https://issues.sonatype.org/browse/MVNCENTRAL) 联系 Sonatype 并告知您的位置，我们将帮助您进行设置。
