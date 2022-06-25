# 核心技术

> version 5.3.21

参考文档的这一部分涵盖了 Spring 框架中绝对不可或缺的所有技术。

其中最重要的是 Spring Framework 的控制反转 (IoC) 容器。在对 Spring Framework 的 IoC 容器进行彻底处理之后，紧接着是对 Spring 的面向切面编程 (AOP) 技术的全面介绍。Spring 框架有自己的 AOP 框架，它在概念上很容易理解，并且成功地解决了 Java 企业编程中 80% 的 AOP 需求甜蜜点。

还提供了 Spring 与 AspectJ 的集成（目前最丰富的——就特性而言——当然也是 Java 企业领域中最成熟的 AOP 实现）。

##  1 IoC 容器

本章介绍 Spring 的控制反转 (IoC) 容器。

### 1.1 Spring IoC 容器和 Bean 简介

本章介绍了控制反转 (IoC) 原则的 Spring Framework 实现。IoC 也称为依赖注入 (DI)。这是一个过程，对象仅通过构造函数参数、工厂方法的参数或在对象实例被构造或从工厂方法返回后设置的属性来定义它们的依赖关系（即与它们一起工作的其他对象） . 然后容器在创建 bean 时注入这些依赖项。这个过程基本上是 bean 本身通过使用类的直接构造或诸如服务定位器模式之类的机制来控制其依赖关系的实例化或位置的逆过程（因此称为控制反转）。

`org.springframework.beans`和`org.springframework.context`包是 Spring Framework 的 IoC 容器的基础。该 [`BeanFactory`](https://docs.spring.io/spring-framework/docs/5.3.21/javadoc-api/org/springframework/beans/factory/BeanFactory.html) 接口提供了一种高级配置机制，能够管理任何类型的对象。 [`ApplicationContext`](https://docs.spring.io/spring-framework/docs/5.3.21/javadoc-api/org/springframework/context/ApplicationContext.html) 是 `BeanFactory` 的子接口。它补充说：

- 更容易与 Spring 的 AOP 功能集成
- 消息资源处理（用于国际化）
- 活动发布
- 应用层特定上下文，例如 `WebApplicationContext` 用于 Web 应用程序的上下文。

简而言之，`BeanFactory` 提供了配置框架和基本功能，`ApplicationContext` 增加了更多的企业特定功能。`ApplicationContext` 是 `BeanFactory` 的 完整超集，并且在本章中专门用于描述 Spring 的 IoC 容器。有关使用`BeanFactory`代替的更多信息，`ApplicationContext,`请参阅涵盖 [`BeanFactory`API](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-beanfactory)的部分。

在 Spring 中，构成应用程序主干并由 Spring IoC 容器管理的对象称为 bean。bean 是由 Spring IoC 容器实例化、组装和管理的对象。否则，bean 只是应用程序中的众多对象之一。Bean 以及它们之间的依赖关系反映在容器使用的配置元数据中。

 