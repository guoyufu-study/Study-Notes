# spring-core

引入 `spring-core` 包

``` xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-core</artifactId>
    <version>5.3.22</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jcl</artifactId>
    <version>5.3.22</version>
</dependency>
```



## 封装配置文件

![Resource-类图](images\Resource-类图.png)

Spring 对其内部使用到的所有资源，实现了自己的抽象结构。可以对所有资源文件进行**统一管理**。

`Resource` 接口抽象了 Spring 内部使用到的所有底层资源。

针对不同来源的资源，提供了相应的 `Resource` 实现。

