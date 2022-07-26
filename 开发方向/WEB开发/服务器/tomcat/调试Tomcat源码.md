# 调试 Tomcat 源码

下载 Tomcat 源码

``` 
git clone git@github.com:guoyufu-study/tomcat.git
```

进入 tomcat 项目目录，查看所有分支，选择并切换到相应分支，比如分支 `8.5.x`：

``` 
cd tomcat
git branch -a
git checkout -b 8.5.x origin/8.5.x
```

创建 `pom.xml` 文件，内容如下：

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>
    <groupId>org.apache.tomcat</groupId>
    <artifactId>Tomcat8.5</artifactId>
    <name>Tomcat8.5</name>
    <version>8.5</version>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
        <maven.test.skip>true</maven.test.skip>
    </properties>

    <build>
        <finalName>Tomcat8.5</finalName>
        <sourceDirectory>java</sourceDirectory>
        <testSourceDirectory>test</testSourceDirectory>
        <resources>
            <resource>
                <directory>java</directory>
            </resource>
        </resources>
        <testResources>
            <testResource>
                <directory>test</directory>
            </testResource>
        </testResources>
    </build>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.easymock</groupId>
            <artifactId>easymock</artifactId>
            <version>4.3</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>ant</groupId>
            <artifactId>ant</artifactId>
            <version>1.7.0</version>
        </dependency>
        <dependency>
            <groupId>wsdl4j</groupId>
            <artifactId>wsdl4j</artifactId>
            <version>1.6.2</version>
        </dependency>
        <dependency>
            <groupId>javax.xml</groupId>
            <artifactId>jaxrpc</artifactId>
            <version>1.1</version>
        </dependency>
        <dependency>
            <groupId>org.eclipse.jdt.core.compiler</groupId>
            <artifactId>ecj</artifactId>
            <version>4.5.1</version>
        </dependency>
    </dependencies>
</project>
```

将项目导入 IDEA，并执行编译

``` 
mvn clean compile
```

运行 `java` 源代码目录下，`org.apache.catalina.startup.Bootstrap#main` 方法。

访问 http://localhost:8080/，会出现错误提示：**无法为JSP编译类**。原因是我们直接执行 `org.apache.catalina.startup.Bootstrap#main` 的时候，没有加载 `org.apache.jasper.servlet.JasperInitializer`，从而无法编译 JSP。解决方案是手动初始化 JSP 解析器，在 Tomcat 的 `org.apache.catalina.startup.ContextConfig#configureStart()` 源码中添加相关代码：

``` java
protected synchronized void configureStart() {
    ......

    webConfig();
    // 增加的解析器
    context.addServletContainerInitializer(new JasperInitializer(), null);

    ......
}
```

再次访问 http://localhost:8080/，正常。

