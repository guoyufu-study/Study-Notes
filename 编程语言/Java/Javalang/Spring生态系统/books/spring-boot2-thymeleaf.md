# Spring Boot 2 + Thymeleaf 企业应用实战

2018-09

## 初试 Spring Boot

### Spring Boot 简介



### 构建第一个 Spring boot 程序

#### 创建一个简单的空的 Maven 项目

``` xml
<?xml version="1.0" encoding="UTF-8"?
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"
    <modelVersion4.0.0</modelVersion

    <groupIdorg.crazyit.boot.c2</groupId
    <artifactIdfirst-boot</artifactId
    <version1.0-SNAPSHOT</version

    <properties
        <maven.compiler.source11</maven.compiler.source
        <maven.compiler.target11</maven.compiler.target
    </properties

</project
```

#### 修改 `pom.xml` 构建脚本

继承 `spring-boot-starter-parent` 项目，并声明一个或多个 `starter` 模块依赖。

``` xml
    <parent
        <artifactIdspring-boot-starter-parent</artifactId
        <groupIdorg.springframework.boot</groupId
        <version2.0.1.RELEASE</version
    </parent

    <dependencies
        <dependency
            <groupIdorg.springframework.boot</groupId
            <artifactIdspring-boot-starter-web</artifactId
        </dependency
    </dependencies
```

更新项目。

#### 编写一个简单的启动类

``` java
package org.crazyit.boot.c2;

@SpringBootApplication
public class FirstApp {

    public static void main(String[] args) {
        SpringApplication.run(FirstApp.class, args);
    }
}
```



#### 编写控制器

``` java
package org.crazyit.boot.c2;

@Controller
public class MyController {

    @GetMapping("/hello")
    @ResponseBody
    @ResponseStatus
    public String hello() {
        return "Hello World";
    }
}
```



#### 启动测试

启动，并访问 http://localhost:8080/hello

#### 开发环境的热部署

```
<dependency
    <groupIdorg.springframework.boot</groupId
    <artifactIdspring-boot-devtools</artifactId
</dependency
```



### 运行单元测试

#### 引入依赖

``` xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
        </dependency>
```

#### 新建测试类

``` java
```

