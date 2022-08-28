# Spring Context

## 引入

``` xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.3.22</version>
</dependency>
```



## JAR 结构

![spring-context-5.3.22](images\spring-context-5.3.22.png)



## context 包

> `package org.springframework.context`

### 包信息

这个包建立在 beans 包的基础上，增加了对消息源和观察者模式的支持，以及应用程序对象使用一致 API 获取资源的能力。

> 扩展功能

Spring 应用程序没有必要显式地依赖 `ApplicationContext` 甚至 `BeanFactory` 功能。 Spring 架构的优势之一是应用程序对象通常可以在不依赖于 Spring 特定 API 的情况下进行配置。

> 侵入性小

![org.springframework.context](images\org.springframework.context.png)

### 包结构

![org.springframework.context-包结构](images\org.springframework.context-包结构.png)

### 入口

#### `ApplicationContext` 接口

> `org.springframework.context.ApplicationContext`

![ApplicationContext-类层次结构](images\ApplicationContext-类层次结构.png)

> 从图中可以看出，相对于 `spring-beans` 扩展了以下功能：
>
> * 统一了资源获取方式
> * 消息源
> * 事件发布

#### `ApplicationContext` 实现

![ApplicationContext-实现类](images\ApplicationContext-实现类_2.png)

`org.springframework.context.support.ClassPathXmlApplicationContext`

`org.springframework.context.annotation.AnnotationConfigApplicationContext`

### 具体分析

* [ClassPathXmlApplicationContext](编程语言/Java/Javalang/Spring生态系统/modules/spring-context/ClassPathXmlApplicationContext.md)

* [AnnotationConfigApplicationContext](编程语言/Java/Javalang/Spring生态系统/modules/spring-context/AnnotationConfigApplicationContext.md)
  * [注册](编程语言/Java/Javalang/Spring生态系统/modules/spring-context/AnnotatedBeanDefinitionReader.md)
  * [扫描](编程语言/Java/Javalang/Spring生态系统/modules/spring-context/ClassPathBeanDefinitionScanner.md)
* [刷新](编程语言/Java/Javalang/Spring生态系统/modules/spring-context/AbstractApplicationContext-refresh.md) 