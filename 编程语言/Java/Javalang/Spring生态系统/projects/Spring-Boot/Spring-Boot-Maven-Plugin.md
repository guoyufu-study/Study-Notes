# Spring Boot Maven 插件

> https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/

Spring Boot Maven 插件在 [Apache Maven](https://maven.org/) 中提供 Spring Boot 支持。它允许我们打包可执行的 jar 或 war 归档、运行 Spring Boot 应用、生成构建信息，并在运行集成测试之前启动我们的 Spring Boot 应用。

## 入门

要使用 Spring Boot Maven 插件，请在您的`pom.xml` 的 `plugins` 部分中包含适当的 XML ，如以下示例所示：

``` xml
<project>
    <modelVersion>4.0.0</modelVersion>
    <artifactId>getting-started</artifactId>
    <!-- ... -->
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

如果您使用里程碑或快照版本，您还需要添加适当的`pluginRepository`元素，如以下清单所示：

``` xml
<pluginRepositories>
    <pluginRepository>
        <id>spring-snapshots</id>
        <url>https://repo.spring.io/snapshot</url>
    </pluginRepository>
    <pluginRepository>
        <id>spring-milestones</id>
        <url>https://repo.spring.io/milestone</url>
    </pluginRepository>
</pluginRepositories>
```

> 自注：记得使用国内镜像替换，比如阿里云镜像。

## 使用插件

Maven 用户可以从`spring-boot-starter-parent`项目继承以获得合理的默认值。父项目提供以下功能：

- Java 1.8 作为默认编译器级别。
- UTF-8 源编码。
- 用 `-parameters` 编译。
- 一个从 `spring-boot-dependencies` POM 继承的依赖管理部分，用于管理常见的依赖的版本。这种依赖管理允许您在自己的 POM 中使用这些依赖项时省略 `<version>` 标记。
- 具有 `repackage` 执行 ID的[`repackage`目标](https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/#goals-repackage) 的执行。
- 合理的[资源过滤](https://maven.apache.org/plugins/maven-resources-plugin/examples/filter.html)。
- 合理的插件配置（[Git 提交 ID](https://github.com/ktoso/maven-git-commit-id-plugin)和[shade](https://maven.apache.org/plugins/maven-shade-plugin/)）。
- 对`application.yml` 和 `application.properties`，包括特定于 profile 的文件（例如，`application-dev.properties` 和 `application-dev.yml`）进行合理的资源过滤。

> 由于`application.properties` 和 `application.yml` 文件接受 Spring 样式的占位符 ( `${…}`)，因此 Maven 过滤更改为使用`@..@`占位符。（您可以通过设置一个名为 `resource.delimiter` 的 Maven 属性来覆盖它。）



### 继承 Starter Parent POM

要将您的项目配置为从 `spring-boot-starter-parent` 继承，请设置`parent`如下：

``` xml
<!-- Inherit defaults from Spring Boot -->
<parent>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-parent</artifactId>
	<version>2.6.5</version>
</parent>
```

> 您应该只需要为此依赖项指定 Spring Boot 版本号。如果您导入其他 starter，您可以放心地省略版本号。

使用该设置，您还可以通过**重写您自己项目中的属性来覆盖单个依赖项**。比如，要使用不同版本的 SLF4J 库和 Spring Data 发布系列，您可以将以下内容添加到您的`pom.xml`:

``` xml
<properties>
    <slf4j.version>1.7.30</slf4j.version>
    <spring-data-releasetrain.version>Moore-SR6</spring-data-releasetrain.version>
</properties>
```

浏览 Spring Boot 参考中的 [`Dependency versions Appendix`](https://docs.spring.io/spring-boot/docs/2.6.5/reference/htmlsingle/#dependency-versions-properties) 获取依赖项版本属性的完整列表。

### 在没有父 POM 的情况下使用 Spring Boot

您可能有理由不从`spring-boot-starter-parent` POM 继承。您可能有自己的公司标准父 POM 需要使用，或者您可能更喜欢显式声明所有 Maven 配置。

如果您不想使用`spring-boot-starter-parent`，您仍然可以通过使用`import`作用域依赖项来保持依赖项管理（但不是插件管理）的好处，如下所示：

``` xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <!-- Import dependency management from Spring Boot -->
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>2.6.5</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

如上所述，前面的示例设置不允许您使用属性覆盖单个依赖项。要达到相同的结果，您需要在项目的`dependencyManagement`部分中的`spring-boot-dependencies`条目**之前**添加条目。比如，要使用不同版本的 SLF4J 库和 Spring Data 发布系列，您可以将以下元素添加到您的`pom.xml`:

``` xml
<dependencyManagement>
    <dependencies>
        <!-- 重写 Spring Boot 提供的 SLF4J -->
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>1.7.30</version>
        </dependency>
        <!-- 重写 Spring Boot 提供的 Spring Data 发布系列 -->
        <dependency>
            <groupId>org.springframework.data</groupId>
            <artifactId>spring-data-releasetrain</artifactId>
            <version>2020.0.0-SR1</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>2.6.5</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

### 在命令行上重写设置

该插件提供了许多以 `spring-boot` 开头的用户属性，让您可以**从命令行自定义配置**。

例如，您可以调整 profiles 以在运行应用时启用，如下所示：

``` powershell
mvn spring-boot:run -Dspring-boot.run.profiles=dev,local
```

如果您希望拥有默认值，同时允许在命令行上重写它，您应该使用用户提供的项目属性和 MOJO 配置的组合。

``` xml
<project>
    <properties>
        <app.profiles>local,dev</app.profiles>
    </properties>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <profiles>${app.profiles}</profiles>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

以上确保默认情况下启用 `local` 和 `dev`。现在已经公开了一个专用属性，也可以在命令行上重写它：

``` powershell
mvn spring-boot:run -Dapp.profiles=test
```

## 目标 

Spring Boot 插件具有以下目标：

| 目标                                                         | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [spring-boot:build-image](https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/#goals-build-image) | 使用 buildpack 将应用打包到 OCI 映像中。                     |
| [spring-boot:build-info](https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/#goals-build-info) | 基于当前  `MavenProject` 的内容，生成一个 `build-info.properties` 文件。 |
| [spring-boot:help](https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/#goals-help) | 显示 spring-boot-maven-plugin 的帮助信息。<br/>调用 `mvn spring-boot:help -Ddetail=true -Dgoal=<goal-name>` 以显示参数详细信息。 |
| [spring-boot:repackage](https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/#goals-repackage) | 重新打包现有的 JAR 和 WAR 档案，以便可以在命令行使用`java -jar`。<br/>使用 `layout=NONE` 也可以简单地用于打包具有嵌套依赖项的 JAR（并且没有主类，因此不可执行）。 |
| [spring-boot:run](https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/#goals-run) | 就地运行应用。                                               |
| [spring-boot:start](https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/#goals-start) | 启动一个 spring  应用程序。与`run`目标相反，这不会阻塞，并且允许其他目标对应用进行操作。<br/>此目标通常用于集成测试场景，其中应用在测试套件之前启动并在之后停止。 |
| [spring-boot:stop](https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/#goals-stop) | 停止由  "start"  目标启动的应用。通常在测试套件完成后调用。  |

## 打包可执行归档

该插件可以创建包含应用程序所有依赖项的可执行归档（jar 文件和 war 文件），然后可以使用`java -jar`.

打包一个可执行归档由`repackage`目标执行，如下例所示：

``` xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <executions>
                <execution>
                    <goals>
                        <goal>repackage</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

> 如果您正在使用`spring-boot-starter-parent`，则此类执行已预先配置了`repackage`执行 ID，因此应该只添加插件定义。

上面的示例重新打包了在 Maven 生命周期的打包阶段构建的 `jar` 或 `war` 归档，包括项目中定义的任何 `provided` 依赖项。如果需要排除其中一些依赖项，您可以使用一个`exclude`选项；有关更多详细信息，请参阅[依赖项排除](https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/#packaging.examples.exclude-dependency)。

原始（即不可执行）构件默认重命名为 `.original`，但也可以使用自定义分类器保留原始构件。

> 当前不支持 `maven-war-plugin` 的`outputFileNameMapping`功能。

默认情况下会自动排除 Devtools（您可以使用 `excludeDevtools` 属性进行控制）。为了使 `war` 打包工作，必须将 `spring-boot-devtools` 依赖项设置为 `optional` 或 `provided` 范围。

该插件会重写您的清单，特别是它管理`Main-Class`和`Start-Class`条目。如果默认值不起作用，您必须在 Spring Boot ，而不是 jar ，插件中配置值。清单中的 `Main-Class` 由 Spring Boot 插件的 `layout` 属性控制，如下例所示：

``` xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <mainClass>${start.class}</mainClass>
                <layout>ZIP</layout>
            </configuration>
            <executions>
                <execution>
                    <goals>
                        <goal>repackage</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

该`layout`属性的默认值由归档类型（`jar`或`war`）决定。可以使用以下布局：

- `JAR`：常规可执行 JAR 布局。
- `WAR`：可执行的 WAR 布局。当 `war` 被部署在 servlet 容器中时，`provided` 依赖项被放置`WEB-INF/lib-provided`以避免任何冲突。
- `ZIP` （别名`DIR`）：类似于使用 `PropertiesLauncher` 的 `JAR` 布局。
- `NONE`：捆绑所有依赖项和项目资源。不捆绑引导加载程序。

### 分层的 Jar 或 War

重新打包的 jar 分别在 `BOOT-INF/classes` 和 `BOOT-INF/lib` 中包含应用的类和依赖。类似地，一个可执行的 war ，在 `WEB-INF/classes` 中包含应用的类，同时在 `WEB-INF/lib` 和 `WEB-INF/lib-provided` 中包含应用的依赖项。对于需要从 jar 或 war 的内容构建 docker 镜像的情况，能够进一步分离这些目录以便将它们写入不同层是很有用的。

分层归档使用与常规重新打包的 jar 或 war 相同的布局，但包含一个描述每个层的额外的元数据文件 `layer.idx`。

默认情况下，定义了以下层：

* `dependencies`：版本中不包含 `SNAPSHOT` 的任何依赖项。
* `spring-boot-loader`：加载器类
* `snapshot-dependencies`：版本中包含 `SNAPSHOT` 的任何依赖项。
* `application`：本地模块依赖、应用类，和资源。

通过查看当前构建的所有模块来识别模块依赖关系。如果一个模块依赖只能被解析，因为它已经安装到 Maven 的本地缓存中，并且它不是当前构建的一部分，它将被识别为常规依赖。

层的顺序很重要。因为它决定了在应用的一部分发生变更时缓存先前层的可能性。默认顺序是 `dependencies`、`spring-boot-loader`、`snapshot-dependencies`、`application`。应该首先添加最不可能变更的内容，然后添加更可能变更的层。

重新打包的归档默认包含 `layer.idx` 文件。要禁用此功能，您可以通过以下方式执行此操作：

``` xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <layers>
                        <enabled>false</enabled>
                    </layers>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

#### 自定义层配置

根据您的应用程序，您可能需要调整层的创建方式，并添加新层。这可以使用一个单独的配置文件来完成，该文件应该如下所示进行注册：

``` xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <layers>
                        <enabled>true</enabled>
                        <configuration>${project.basedir}/src/layers.xml</configuration>
                    </layers>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

配置文件描述了如何将归档分成层，以及这些层的顺序。以下示例显示了如何显式定义上述默认排序：

``` xml
<layers xmlns="http://www.springframework.org/schema/boot/layers"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.springframework.org/schema/boot/layers
                            https://www.springframework.org/schema/boot/layers/layers-2.6.xsd">
    <application>
        <into layer="spring-boot-loader">
            <include>org/springframework/boot/loader/**</include>
        </into>
        <into layer="application" />
    </application>
    <dependencies>
        <into layer="application">
            <includeModuleDependencies />
        </into>
        <into layer="snapshot-dependencies">
            <include>*:*:*SNAPSHOT</include>
        </into>
        <into layer="dependencies" />
    </dependencies>
    <layerOrder>
        <layer>dependencies</layer>
        <layer>spring-boot-loader</layer>
        <layer>snapshot-dependencies</layer>
        <layer>application</layer>
    </layerOrder>
</layers>
```

`layer` XML 格式在三个部分中定义：

* `<application>` 块定义应用类和资源应如何分层。
* `<dependencies>` 块定义依赖关系应如何分层。
* `<layerOrder>` 块定义层的写入顺序。

嵌套 `<into>` 块在 `<application>` 和 `<dependencies>` 部分中用于声明层的内容。块按照定义的顺序从上到下进行评估。前面的块未声明的任何内容仍然可供后续块考虑。

`<into>` 块使用嵌套 `<include>` 和 `<exclude>` 元素声明内容。 `<application>` 部分对包含/排除表达式使用 Ant 样式的路径匹配。`<dependencies>` 部分使用 `group:artifact[:version]` 模式。它还提供了可用于包含或排除本地模块依赖关系的元素 `<includeModuleDependencies />` 和 `<excludeModuleDependencies />`。

如果没有`<include>`定义，则考虑所有内容（未由较早的块声明）。

如果没有`<exclude>`定义，则不应用任何排除。

查看上面的 `<dependencies>` 示例，我们可以看到第一个`<into>`将为 `application` 层声明所有模块依赖。 下一个 `<into>` 将为 `snapshot-dependencies` 层声明所有 SNAPSHOT 依赖项。 最后一个  `<into>` 将为 `dependencies` 层声明所有剩下的内容（在这种情况下，任何不是 SNAPSHOT 的依赖项）。

`<application>` 块具有类似的规则。首先，为 `spring-boot-loader` 层声明 `org/springframework/boot/loader/**` 内容。然后，为 `application` 层声明所有剩下的类和资源。

> 定义 `<into>` 块的顺序通常与写入层的顺序不同。因此，必须始终包含 `<layerOrder>` 元素，并且*必须*覆盖 `<into>` 块引用的所有层。

### spring-boot:repackage

> `org.springframework.boot:spring-boot-maven-plugin:2.6.5`

重新打包现有的 JAR 和 WAR 归档，以便可以使用`java -jar`。 使用 `layout=NONE` 也可以简单地用于打包具有嵌套依赖项的 JAR（并且没有主类，因此不可执行）。

### 示例

#### 自定义分类器

默认情况下，`repackage`目标将原始构件替换为重新打包的构件。对于代表应用程序的模块来说，这是一种合理的行为，但是如果您的模块被用作另一个模块的依赖项，则您需要为重新打包的模块提供分类器。这样做的原因是应用程序类被打包到 `BOOT-INF/classes`，因此依赖模块无法加载重新打包的 jar 类。

如果是这种情况，或者如果您希望保留原始构件并将重新打包的构件附加到不同的分类器，请按照以下示例配置插件：

``` xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <id>repackage</id>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                        <configuration>
                            <classifier>exec</classifier>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

如果您正在使用`spring-boot-starter-parent`，则`repackage`目标会在 id `repackage` 的执行中自动执行。在该设置中，只应指定配置，如以下示例所示：

``` xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <id>repackage</id>
                        <configuration>
                            <classifier>exec</classifier>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

此配置将生成两个构件：原始构件，和由 `repackage` 目标生成的重新打包对应部分。两者都被将透明地安装/部署。

如果您想以与替换主构件相同的方式重新打包辅助构件，也可以使用相同的配置。以下配置使用重新打包的应用程序安装/部署单个`task`分类构件：

``` xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <executions>
                    <execution>
                        <goals>
                            <goal>jar</goal>
                        </goals>
                        <phase>package</phase>
                        <configuration>
                            <classifier>task</classifier>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <id>repackage</id>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                        <configuration>
                            <classifier>task</classifier>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

由于 `maven-jar-plugin` 和 `spring-boot-maven-plugin` 运行在同一阶段，首先定义 jar 插件（以便它在 repackage 目标之前运行）就很重要了。同样，如果您使用`spring-boot-starter-parent`，这可以简化如下：

``` xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <executions>
                    <execution>
                        <id>default-jar</id>
                        <configuration>
                            <classifier>task</classifier>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <id>repackage</id>
                        <configuration>
                            <classifier>task</classifier>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

#### 自定义名称

如果您需要重新打包的 jar 具有与项目属性 `artifactId` 定义的本地名称不同的本地名称，请使用标准 `finalName`，如下例所示：

``` xml
<project>
    <build>
        <finalName>my-app</finalName>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <id>repackage</id>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

此配置将在 `target/my-app.jar` 生成重新打包的构件。

#### 本地重新打包的构件

默认情况下，`repackage`目标将原始构件替换为可执行文件。如果您只需要部署原始 jar 并且能够使用常规文件名运行您的应用程序，请按如下方式配置插件：

``` xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <id>repackage</id>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                        <configuration>
                            <attach>false</attach>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

此配置生成两个构件：原始构件，和 `repackage` 目标生成的可执行对应部分。只有原始的将被安装/部署。

#### 自定义布局

Spring Boot 使用额外的 jar 文件中定义的自定义布局工厂重新打包此项目的 jar 文件。额外的 jar 文件作为构建插件的依赖项提供：

``` xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <id>repackage</id>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                        <configuration>
                            <layoutFactory implementation="com.example.CustomLayoutFactory">
                                <customProperty>value</customProperty>
                            </layoutFactory>
                        </configuration>
                    </execution>
                </executions>
                <dependencies>
                    <dependency>
                        <groupId>com.example</groupId>
                        <artifactId>custom-layout</artifactId>
                        <version>0.0.1.BUILD-SNAPSHOT</version>
                    </dependency>
                </dependencies>
            </plugin>
        </plugins>
    </build>
</project>
```

布局工厂是作为在 `pom.xml` 中明确指定的`LayoutFactory`(来自 `spring-boot-loader-tools`) 的实现提供的。如果插件类路径上只有一个自定义`LayoutFactory`并且它在 `META-INF/spring.factories` 中被列出，那么没有必要在插件配置中显式设置它。

如果显式设置了[layout](https://docs.spring.io/spring-boot/docs/2.6.5/maven-plugin/reference/htmlsingle/#goals-repackage-parameters-details-layoutFactory)，则始终忽略布局工厂。

#### 依赖项排除

默认情况下，目标 `repackage` 和目标 `run` 都将包含项目中定义的任何 `provided` 依赖项。Spring Boot 项目应将 `provided` 依赖项视为运行应用程序所需的“容器”依赖项。

其中一些依赖项可能根本不需要，应该从可执行 jar 中排除。为了保持一致性，它们在运行应用程序时也不应该出现。

有两种方法可以在运行时将依赖项排除在打包/使用之外：

- 排除由 `groupId` 和 `artifactId` 标识的特定构件，如果需要，可以选择使用 `classifier`。
- 排除属于给定 `groupId` 的任何构件。

以下示例排除`com.example:module1`，并且仅排除该构件：

``` xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>com.example</groupId>
                            <artifactId>module1</artifactId>
                        </exclude>
                    </excludes>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```



#### 分层归档工具

创建分层 jar 或 war 时，`spring-boot-jarmode-layertools` jar 将作为依赖项添加到您的归档中。使用类路径中的这个 jar，您可以在特殊模式下启动应用程序，该模式允许引导代码运行与您的应用程序完全不同的东西，例如，提取层。如果您希望排除这种依赖关系，可以通过以下方式进行：

``` xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <layers>
                        <includeLayerTools>false</includeLayerTools>
                    </layers>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```



#### 自定义层配置

默认设置将依赖项分为快照和非快照，但是，您可能有更复杂的规则。例如，您可能希望**将项目的公司特定依赖项隔离在专用层中**。以下`layers.xml`配置显示了一种这样的设置：

``` xml
<layers xmlns="http://www.springframework.org/schema/boot/layers"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.springframework.org/schema/boot/layers
                            https://www.springframework.org/schema/boot/layers/layers-2.6.xsd">
    <application>
        <into layer="spring-boot-loader">
            <include>org/springframework/boot/loader/**</include>
        </into>
        <into layer="application" />
    </application>
    <dependencies>
        <into layer="snapshot-dependencies">
            <include>*:*:*SNAPSHOT</include>
        </into>
        <into layer="company-dependencies">
            <include>com.acme:*</include>
        </into>
        <into layer="dependencies"/>
    </dependencies>
    <layerOrder>
        <layer>dependencies</layer>
        <layer>spring-boot-loader</layer>
        <layer>snapshot-dependencies</layer>
        <layer>company-dependencies</layer>
        <layer>application</layer>
    </layerOrder>
</layers>
```

上面的配置创建了一个额外的 `company-dependencies` 层，其中包含具有 `com.acme` groupId 的所有库。
