# exec-maven-plugin 简介

这个插件提供了两个goals来帮助执行系统程序和Java程序。

## Goals 概述

* `exec:exec` 在一个单独的进程中执行程序和Java程序。

* `exec:java` 在同一个VM中执行Java程序。

## 用法 

有关如何使用`exec-maven-plugin`的一般说明可以在[用法页面](https://www.mojohaus.org/exec-maven-plugin/usage.html)中找到。

如果你仍然对插件的使用有疑问，请随时联系用户邮件列表。邮件列表中的帖子已经存档，并且可能已经包含了您的问题的答案，作为旧线程的一部分。因此，它也值得浏览/搜索邮件存档。

如果你觉得插件缺少某个功能或有缺陷，你可以在我们的[问题跟踪](https://www.mojohaus.org/exec-maven-plugin/issue-tracking.html)中填写功能请求或bug报告。当创建一个新问题时，请提供你所关心的问题的全面描述。特别是对于修复bug，全面的问题描述对开发人员能够重现你的问题是至关重要的。因此，最好能够提供与问题相关的整个调试日志、POMs或最理想的小型演示项目。当然，补丁也是最受欢迎的。贡献者可以从我们的[源存储库](https://www.mojohaus.org/exec-maven-plugin/source-repository.html)中检出项目，并在[帮助Maven的指南](http://maven.apache.org/guides/development/guide-helping.html)中找到补充信息。

## 示例

为了使您更好地了解Exec Maven插件的某些用法，可以看一下以下示例：

* 使用`exec:exec`运行Java程序
* 在运行Java程序时更改类路径范围
* 使用插件依赖于`exec:exec`
* 使用工具链而不是显式路径
* 使用可执行的二进制依赖项而不是本地可执行项

你应该在项目的插件配置中指定版本：

```xml
<project>
  ...
  <build>
    <!-- 
		To define the plugin version in your parent POM
 		在父POM中定义插件版本 
	-->
    <pluginManagement>
      <plugins>
        <plugin>
          <groupId>org.codehaus.mojo</groupId>
          <artifactId>exec-maven-plugin</artifactId>
          <version>1.6.0</version>
        </plugin>
        ...
      </plugins>
    </pluginManagement>
    <!-- 
		To use the plugin goals in your POM or parent POM 
		在POM或父POM中使用插件目标
	-->
    <plugins>
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>exec-maven-plugin</artifactId>
        <version>1.6.0</version>
      </plugin>
      ...
    </plugins>
  </build>
  ...
</project>
```

# 用法

## Exec 目标

你可以在插件配置中正式指定所有相关的执行信息。根据你的用例，你还可以使用系统属性指定部分或全部信息。

## 命令行

使用系统属性，你可以像下面的示例一样执行它。

```
mvn exec:exec -Dexec.executable="maven" [-Dexec.workingdir="/tmp"] -Dexec.args="-X myproject:dist"
```

## POM 配置

在POM中添加类似于下面的配置:

```xml
<project>
  ...
  <build>
    <plugins>
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>exec-maven-plugin</artifactId>
        <version>1.6.0</version>
        <executions>
          <execution>
            ...
            <goals>
              <goal>exec</goal>
            </goals>
          </execution>
        </executions>
        <configuration>
          <executable>maven</executable>
          <!-- 可选 -->
          <workingDirectory>/tmp</workingDirectory>
          <arguments>
            <argument>-X</argument>
            <argument>myproject:dist</argument>
            ...
          </arguments>
        </configuration>
      </plugin>
    </plugins>
  </build>
   ...
</project>
```



# 使用 exec 目标运行Java程序

## POM 配置

为了执行Java程序，`exec-maven-plugin`通过允许指定特殊参数`<classpath>`来提供帮助：

```xml
        <configuration>
          <executable>java</executable>
          <arguments>
            <argument>-classpath</argument>
            <!-- automatically creates the classpath using all project dependencies,
                 also adding the project build directory 
				使用所有项目依赖项，并添加项目构建目录，来自动创建类路径
			-->
            <classpath/>
            <argument>com.example.Main</argument>
            ...
          </arguments>
        </configuration>
```

或者，如果你想限制类路径中的依赖关系：

```xml
        <configuration>
          <executable>java</executable>
          <arguments>
            <argument>-classpath</argument>
            <classpath>
              <dependency>commons-io:commons-io</dependency>
              <dependency>commons-lang:commons-lang</dependency>
            </classpath>
            <argument>com.example.Main</argument>
            ...
          </arguments>
        </configuration>
```

对于自Java9以来支持模块的情况，配置如下

```xml
        <configuration>
          <executable>java</executable>
          <arguments>
            <argument>--module-path</argument> <!-- or -p  -->
            <!-- automatically creates the modulepath using all project dependencies,
                 also adding the project build directory 
				使用所有项目依赖项，并添加项目构建目录，来自动创建模块路径，
			-->
            <modulepath/>
            <argument>--module</argument> <!-- 或者 -m -->
            <argument>mymodule/com.example.Main</argument>
            ...
          </arguments>
        </configuration>
```

