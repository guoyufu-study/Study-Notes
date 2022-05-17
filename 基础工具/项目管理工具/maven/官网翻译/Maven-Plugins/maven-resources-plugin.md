# maven 资源插件

> https://maven.apache.org/plugins/maven-resources-plugin/index.html

资源插件负责将项目资源复制到输出目录。

## 基本概念

资源是项目使用的非源代码文件。比如，属性文件，图像和XML文件。

主要资源和测试资源彼此分开，以避免可能发生的任何副作用。

## 最新版本

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-resources-plugin</artifactId>
    <version>3.2.0</version>
</plugin>
```

## 基本用法

复制主要资源：

``` powershell
mvn resources:resources
```

> 该目标绑定到了 `process-resources` 阶段。

复制测试资源：

``` powershell
mvn resources:testResources
```

> 该目标绑定到了 `process-test-resources` 阶段。

复制其它资源：

``` powershell
mvn resources:copy-resources
```

> 默认情况下，该目标没有绑定到哪个阶段，并且也没有默认资源目录。



## 常见工作流

### 指定字符编码方案

```xml
<properties>
	<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
     ...
</properties>
```

### 指定资源目录

``` xml
<build>
   ...
   <resources>
     <resource>
       <directory>[your folder here]</directory>
     </resource>
   </resources>
   ...
 </build>
```

默认位置 `src/main/resources`。可以指定多个目录。

主要资源目录，使用 `<build>/<resources>` 元素配置。测试资源目录，使用 `<build>/<testResources>` 元素配置。

### 包含和排除文件和目录

指定要包含的文件或指定要排除的文件

`<includes>/<include>` 是白名单，`<excludes>/<exclude>` 是黑名单。

默认时，包含所有文件；只指定白名单时，只包含白名单中的文件；只指定黑名单时，只包含排除了黑名单后的所有文件；两者都指定时，只包含排除了黑名单后的白名单中的文件。

可以使用通配符。`*`表示任意字符，不包括`/`等文件分隔符，`**`表示任意字符，包括文件分隔符。

### 过滤

资源中可以包含变量。比如，`src/main/resources/hello.txt` 中包含：

``` properties
Hello ${name}
Hello @name@
```

由`${...}` 或 `@...@` 分隔符表示的这些变量可以来自命令行、项目属性、过滤资源和系统属性中

#### 启用资源过滤

默认不启用资源过滤功能。因此，上面的资源文件会原样复制到输出目录。

使用下面的配置启用资源过滤功能，用参数化值替换标记：

``` xml
<build>
   ...
   <resources>
       	...
          <resource>
            <directory>src/main/resources</directory>
            <filtering>true</filtering>
          </resource>
          ...
   </resources>
   ...
 </build>
```

#### 变量来源

参数化值可以来自命令行、项目属性、过滤资源和系统属性中，优先级依次降低。

> 自注：系统属性未验证成功。

##### 命令行

``` powershell
mvn resources:resources -Dname=spring -f pom.xml
```

##### 项目属性

``` xml
<project>
    ...
    <properties>
        <name>summer</your>
    </properties>
    ...
</project>
```



#####  过滤资源

``` xml
<build>
   ...
    <filters>
        <filter>my-filter-values.properties</filter>
    </filters>
   ...
 </build>
```

`my-filter-values.properties`文件的内容：

``` properties
name = autumn
```

#### 启用转义过滤

默认不启用转义过滤，`Hello \${name}`过滤后，结果为 `Hello \world`。

可以使用可配置字符串转义过滤：

``` xml
<project>
    ...
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-resources-plugin</artifactId>
                <version>3.2.0</version>
                <configuration>
                    ...
                    <escapeString>\</escapeString>
                    ...
                </configuration>
            </plugin>
        </plugins>
        ...
    </build>
    ...
</project>
```

启动转义过滤，指定转义字符串为`\`后，结果为`Hello ${name}`。

#### 二进制内容

不要过滤包含二进制内容的文件，如图像！这很可能导致错误的输出。

#### 自定义资源过滤器

> https://maven.apache.org/plugins/maven-resources-plugin/examples/custom-resource-filters.html



