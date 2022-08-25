# Spring Beans

> `package org.springframework.beans`

该包包含用于**操作 Java bean** 的接口和类。大多数其他 Spring 包都使用它。
`BeanWrapper` 对象可用于单独或批量设置和获取 bean 属性。
此包中的类在 Rod Johnson 的 [Expert One-On-One J2EE Design and Development](https://www.amazon.com/exec/obidos/tg/detail/-/0764543857/) （Wrox，2002 年）的第 11 章中进行了讨论。

## 应用

### 引入

``` xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-beans</artifactId>
    <version>5.3.22</version>
</dependency>
```

### 包依赖

spring-beans 的依赖项：

<img src="images\spring-beans-dependencies.png" alt="spring-beans-dependencies" style="zoom:50%;" />

### 功能目标

`org.springframework.beans` 包包含**用于操作 Java beans 的接口和类**。大多数其他 Spring 包都使用它。
`BeanWrapper` 对象可用于单独或批量设置和获取 bean 属性。

[手写 spring-beans](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/handprinted-spring-beans.md)

## 核心功能

### Bean Factory

* [BeanFactory](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/BeanFactory.md)：Bean 工厂
  * [DefaultListableBeanFactory](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/DefaultListableBeanFactory.md)：Bean 工厂
* [getBean](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/getBean.md)：获取 `Bean` 实例。

[自动装配](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/自动装配功能.md)

[生成 bean 名称](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/BeanNameGenerator.md)

[实例化策略](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/InstantiationStrategy.md)

### bean 定义

[bean 定义](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/BeanDefinition.md)

[bean 定义读取器](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/BeanDefinitionReader.md)

[bean 元数据元素](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/BeanDefinitionReader.md)
