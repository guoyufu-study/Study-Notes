## 创建装配指南

Maven 中的**装配机制**提供了一种使用 POM 中的装配描述符和依赖信息创建分发的简单方法。为了使用装配插件，您需要在 POM 中配置装配插件，它可能如下所示：

```xml
<project>
  <parent>
    <artifactId>maven</artifactId>
    <groupId>org.apache.maven</groupId>
    <version>2.0-beta-3-SNAPSHOT</version>
  </parent>
  <modelVersion>4.0.0</modelVersion>
  <groupId>org.apache.maven</groupId>
  <artifactId>maven-embedder</artifactId>
  <name>Maven Embedder</name>
  <version>2.0-beta-3-SNAPSHOT</version>
  <build>
    <plugins>
      <plugin>
        <artifactId>maven-assembly-plugin</artifactId>
        <version>3.3.0</version>
        <configuration>
          <descriptors>
            <descriptor>src/assembly/dep.xml</descriptor>
          </descriptors>
        </configuration>
        <executions>
          <execution>
            <id>create-archive</id>
            <phase>package</phase>
            <goals>
              <goal>single</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
  ...
</project>
```

您会注意到装配描述符位于 `${project.basedir}/src/assembly` 这是装配描述符的[标准](https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html)位置。

### 创建二进制装配

这是装配插件最典型的用法，您在其中创建标准使用的发行版。

```xml
<assembly xmlns="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2 http://maven.apache.org/xsd/assembly-1.1.2.xsd">
  <id>bin</id>
  <formats>
    <format>tar.gz</format>
    <format>tar.bz2</format>
    <format>zip</format>
  </formats>
  <fileSets>
    <fileSet>
      <directory>${project.basedir}</directory>
      <outputDirectory>/</outputDirectory>
      <includes>
        <include>README*</include>
        <include>LICENSE*</include>
        <include>NOTICE*</include>
      </includes>
    </fileSet>
    <fileSet>
      <directory>${project.build.directory}</directory>
      <outputDirectory>/</outputDirectory>
      <includes>
        <include>*.jar</include>
      </includes>
    </fileSet>
    <fileSet>
      <directory>${project.build.directory}/site</directory>
      <outputDirectory>docs</outputDirectory>
    </fileSet>
  </fileSets>
</assembly>
```

您可以使用前面提到的手动定义的装配描述符，但在这种情况下使用[预定义的装配描述符 bin](https://maven.apache.org/plugins/maven-assembly-plugin/descriptor-refs.html#bin) 会更简单。

[maven-assembly-plugin](https://maven.apache.org/plugins/maven-assembly-plugin/usage.html#Configuration) 的文档中描述了如何使用这些预定义的装配描述符。

```xml
<assembly 
  xmlns="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2 
  http://maven.apache.org/xsd/assembly-1.1.2.xsd">
 
  <!-- TODO: a jarjar format would be better -->
  <id>dep</id>
  <formats>
    <format>jar</format>
  </formats>
  <includeBaseDirectory>false</includeBaseDirectory>
  <fileSets>
    <fileSet>
      <outputDirectory>/</outputDirectory>
    </fileSet>
  </fileSets>
  <dependencySets>
    <dependencySet>
      <outputDirectory>/</outputDirectory>
      <unpack>true</unpack>
      <scope>runtime</scope>
      <excludes>
        <exclude>junit:junit</exclude>
        <exclude>commons-lang:commons-lang</exclude>
        <exclude>commons-logging:commons-logging</exclude>
        <exclude>commons-cli:commons-cli</exclude>
        <exclude>jsch:jsch</exclude>
        <exclude>org.apache.maven.wagon:wagon-ssh</exclude>
        <!-- TODO: can probably be removed now -->
        <exclude>plexus:plexus-container-default</exclude>
      </excludes>
    </dependencySet>
  </dependencySets>
</assembly>
```

如果您想创建一个源分发包，最好的解决方案是为此目的使用[预定义的装配描述符 src](https://maven.apache.org/plugins/maven-assembly-plugin/descriptor-refs.html#src)。

```xml
<assembly xmlns="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2 http://maven.apache.org/xsd/assembly-1.1.2.xsd">
  <id>src</id>
  <formats>
    <format>tar.gz</format>
    <format>tar.bz2</format>
    <format>zip</format>
  </formats>
  <fileSets>
    <fileSet>
      <directory>${project.basedir}</directory>
      <includes>
        <include>README*</include>
        <include>LICENSE*</include>
        <include>NOTICE*</include>
        <include>pom.xml</include>
      </includes>
      <useDefaultExcludes>true</useDefaultExcludes>
    </fileSet>
    <fileSet>
      <directory>${project.build.sourceDirectory}/src</directory>
      <useDefaultExcludes>true</useDefaultExcludes>
    </fileSet>
  </fileSets>
</assembly>
```

您现在可以通过命令行创建定义的分发包，如下所示：

```powershell
mvn package
```
