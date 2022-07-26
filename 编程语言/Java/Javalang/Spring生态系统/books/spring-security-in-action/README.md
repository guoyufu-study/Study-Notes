# Spring Security 实战

> 英文版 2020 / 中文版 2022-01

## 创建项目

### 创建空项目

在 IDEA 中创建项目 `spring-security-hello`。

![spring-security-hello](images\spring-security-hello-01.png)

点击下一步，

![spring-security-hello](images\spring-security-hello-02.png)

点击创建，

![spring-security-hello](images\spring-security-hello-03.png)

`pom.xml` 内容如下，

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.2</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>cn.jasper.spring.security</groupId>
    <artifactId>spring-security-hello</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>spring-security-hello</name>
    <description>spring-security-hello</description>
    <properties>
        <java.version>11</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

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



### 验证正确的依赖项已经就位

#### 定义 REST 控制器和端点

```java
package cn.jasper.spring.security.hello.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public String hello() {
        return "hello, spring security!";
    }
}
```

#### 运行应用

运行应用，会生成一个新密码，并打印到控制台上。

![spring-security-hello](images\spring-security-hello-04.png)



#### 调用端点

调用端点进行测试，有多种调用端点的方案。

#####  HTTP 客户端

调用端点：在 HTTP客户端中打开，

![spring-security-hello](images\spring-security-hello-05.png)

在`临时文件和控制台/临时文件`目录下，会创建一个临时文件 `generated-requests.http`，

![generated-requests.http](images\spring-security-hello-06.png)

`Ctrl+Shift+F10` 运行 HTTP 请求，结果响应码 `401`，

![运行 HTTP 请求](images\spring-security-hello-07.png)

> 401 ：认证失败，即身份验证失败。开发人员在设计应用时，使用它处理丢失或错误的凭据。
>
> 403 ：授权失败，即认证成功，但授权失败。

点击 `+` 号，添加 `GET 请求`，

![添加 Get 请求](images\spring-security-hello-08.png)

修改新添加的请求，

```
GET http://localhost:8080/
Authorization: Basic user passwd
```

其中 `Authorization: Basic` 表示 HTTP 基本认证方式，  `user` 是用户名，`passwd` 是密码，此示例中将其改为项目启动时在控制台上打印的新密码 `8bcde32e-c42d-49a0-94e1-9f2886e307a8`。

`Ctrl+Shift+F10` 运行新添加的 HTTP 请求，结果响应码 `200`，

![运行新添加的 HTTP 请求](images\spring-security-hello-09.png)

##### cURL

可以下载 `curl` 工具并在命令行执行，也可以直接在 IDEA 中执行。



##### 浏览器

访问 `http://localhost:8080/` 会自动跳转到表单登录页 `http://localhost:8080/login`，要求输入用户名和密码。

![浏览器调用端点](images\spring-security-hello-10.png)

输入用户名 `user`，密码 `8bcde32e-c42d-49a0-94e1-9f2886e307a8`，点击登录。

![浏览器调用端点](images\spring-security-hello-11.png)



### 默认配置

### 入口

`org.springframework.boot:spring-boot-autoconfigure:2.7.22` 包下 `org.springframework.boot.autoconfigure.security.servlet.` 包中有三个相关自动配置类。

* `SecurityAutoConfiguration`：Spring Security Auto-configuration 。它导入了两个 `@Configuration` 类，保护 servlet 应用程序的 `SpringBootWebSecurityConfiguration`，自动添加 Spring Security 与 Spring Data 的集成的 `SecurityDataConfiguration`。

* `SecurityFilterAutoConfiguration`：Spring Security 过滤器的 Auto-configuration 。与 `SpringBootWebSecurityConfiguration` 分开配置，以确保在用户提供的 `WebSecurityConfiguration` 存在时仍然配置过滤器的顺序。

* `UserDetailsServiceAutoConfiguration`：Spring Security in-memory `AuthenticationManager` 的 Auto-configuration 。添加具有默认用户和生成密码的 `InMemoryUserDetailsManager` 。这可以通过提供 `AuthenticationManager` 、 `AuthenticationProvider` 或 `UserDetailsService` 类型的 bean 来禁用。

#### UserDetailsService

`org.springframework.security.core.userdetails.UserDetailsService`

加载用户特定数据的核心接口。
它在整个框架中用作用户 DAO，是 `DaoAuthenticationProvider` 使用的策略。
该接口只需要一种只读方法，这简化了对新数据访问策略的支持

![UserDetailsService](images\UserDetailsService.png)

##### UserDetailsManager

`org.springframework.security.provisioning.UserDetailsManager`

`UserDetailsService` 的扩展，它提供了创建新用户和更新现有用户的能力。

![UserDetailsManager](images\UserDetailsManager.png)

##### InMemoryUserDetailsManager

`org.springframework.security.provisioning.InMemoryUserDetailsManager`

由内存 map 支持的 `UserDetailsManager` 的非持久实现。
主要用于测试和演示目的，不需要完整的持久系统。

![InMemoryUserDetailsManager](images\InMemoryUserDetailsManager.png)

##### JdbcUserDetailsManager

`org.springframework.security.provisioning.JdbcUserDetailsManager`

Jdbc 用户管理服务，基于与其父类 `JdbcDaoImpl` 相同的表结构。
为用户和组提供 CRUD 操作。请注意，如果 `enableAuthorities` 属性设置为 `false`，对 `createUser`、`updateUser` 和 `deleteUser` 的调用将不会存储来自 `UserDetails` 的权限或删除用户的权限。由于此类无法区分为个人或个人所属的组加载的权限，因此在使用此实现管理用户时考虑到这一点很重要。

##### JdbcDaoImpl

`org.springframework.security.core.userdetails.jdbc.JdbcDaoImpl`

`UserDetailsService` 实现，它使用 JDBC 查询从数据库中检索用户详细信息（用户名、密码、启用标志和权限）。

###### 默认架构

假设一个默认的数据库模式，有两个表 `users` 和 `authorities`。
`user` 表
此表包含用户的登录名、密码和启用状态。 
列：username、password、enabled

`authorities` 表
列：`username`、`authority`

如果您使用现有架构，则必须设置查询 `usersByUsernameQuery` 和 `authorityByUsernameQuery` 以匹配您的数据库设置（请参阅`DEF_USERS_BY_USERNAME_QUERY` 和 `DEF_AUTHORITIES_BY_USERNAME_QUERY` ）。
为了最大限度地减少向后兼容性问题，此实现不识别用户帐户的到期或用户凭据的到期。但是，它确实识别并尊重用户启用/禁用列。这应该映射到结果集中的布尔类型（SQL 类型将取决于您使用的数据库）。所有其他列都映射到 String 。

### 启用调试功能

重命名 `src/resources` 目录下的 `application.properties` 文件，新文件名 `application.yml`。

添加 `debug: on`，启用调试日志功能。

### 修改监听端口

``` yaml
server:
  port: 80
```



### 重写默认配置

在 `HelloController` 控制器类中添加一个新端点 `/hello`，

``` java
    @GetMapping("/hello")
    public String hello() {
        return "hello, custom spring security components!";
    }
```



#### 创建配置类

``` java
@Configuration
public class WebSecurityConfiguration {
}
```



#### 重写 UserDetailsService 组件

``` java
    @Bean
    UserDetailsService inMemoryUserDetailsService() {
        var userDetailsService = new InMemoryUserDetailsManager();
        var john = User.builder().username("jasper").password("12345").roles("READ").build();
        userDetailsService.createUser(john);
        return userDetailsService;
    }
```

#### 重写 PasswordEncoder 组件

``` java
    @Bean
    PasswordEncoder noOpPasswordEncoder() {
        return NoOpPasswordEncoder.getInstance();
    }
```

#### 调用端点测试

http://localhost/hello	

#### 重写端点授权配置

在 `HelloController` 控制器类中添加一个新端点 `/hi`，

``` java
    @GetMapping("/hi")
    public String hi() {
        return "hi, custom spring security components!";
    }
```

在配置类 `WebSecurityConfiguration` 中，定义 `SecurityFilterChain` 组件。

``` java
    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.httpBasic()
                .and()
                .authorizeRequests().antMatchers("/hello").permitAll()
                .and()
                .authorizeRequests().anyRequest().authenticated();
        return http.build();
    }
```

#### 调用端点测试

http://localhost/hello	可以无凭据访问

http://localhost/hi	需要输入用户名密码

