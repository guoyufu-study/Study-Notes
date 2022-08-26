# Spring 表达式语言（SpEL）

> https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions

Spring 表达式语言（简称 `SpEL`）是一种强大的表达式语言，**支持在运行时查询和操作对象图**。语言语法类似于统一表达式语言（`Unified EL`），但提供了额外的功能，最值得注意的是**方法调用**和**基本的字符串模板**功能。

虽然还有**其他几种可用的 Java 表达式语言**——`OGNL`、`MVEL` 和 `JBoss EL` 等等——但创建 Spring 表达式语言的目的是**为 Spring 社区提供一种可在所有产品中使用的受良好支持的单一表达式语言**。它的语言特性由 Spring 产品组合中的项目需求驱动，包括 [Spring Tools for Eclipse](https://spring.io/tools) 中代码完成支持的工具需求。也就是说，`SpEL` 基于与技术无关的 API，如果需要，**可以集成其他表达式语言实现**。

虽然 `SpEL` 是 Spring 产品组合中表达式求值的基础，但它不直接与 Spring 绑定，**可以独立使用**。为了自成一体，本章中的许多例子都把 `SpEL` 当作一种独立的表达语言来使用。这需要创建一些引导基础设施类，例如解析器。大多数 Spring 用户不需要处理这个基础设施，相反，可以只编写用于求值的字符串表达式。这种典型使用的一个示例是将 `SpEL` 集成到创建基于 XML 或基于注解的 bean 定义中，如 [对定义 bean 定义的表达式支持](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-beandef) 中所示。

本章介绍了表达式语言的**特性**、 **API** 和**语言语法**。在一些地方，`Inventor`类和 `Society` 类被用作表达式求值的目标对象。这些类声明和用于填充它们的数据在本章末尾列出。

表达式语言支持以下功能：

- 字面量表达
- 布尔和关系运算符
- 常用表达
- 类表达式
- 访问属性、数组、列表和映射
- 方法调用
- 关系运算符
- 任务
- 调用构造函数
- Bean 引用
- 数组构造
- 内联列表
- 内联地图
- 三元运算符
- 变量
- 用户自定义函数
- 收藏投影
- 收藏选择
- 模板化表达式

***

[求值](编程语言/Java/Javalang/Spring生态系统/projects/Spring-Framework/expressions-evaluation.md)

[Bean 定义中的表达式](编程语言/Java/Javalang/Spring生态系统/projects/Spring-Framework/expressions-beandef.md)

[语言参考](编程语言/Java/Javalang/Spring生态系统/projects/Spring-Framework/expressions-language-ref.md)

[示例中使用的类](编程语言/Java/Javalang/Spring生态系统/projects/Spring-Framework/expressions-example-classes.md)