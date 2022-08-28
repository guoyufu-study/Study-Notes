# `AnnotationConfigApplicationContext`

> `org.springframework.context.annotation.AnnotationConfigApplicationContext`

## 概述

### API 文档

独立的应用程序上下文，接受组件类作为输入——特别是被 `@Configuration` 注解的类，也可以使用普通的 `@Component` 类型和使用 `javax.inject` 注解的兼容 JSR-330 的类。
允许使用 `register(Class...)` 逐个注册类以及使用 `scan(String...)` 进行类路径扫描。
在多个 `@Configuration` 类的情况下，后面的类中定义的 `@Bean` 方法将覆盖早期类中定义的方法。这可以用来通过额外的 `@Configuration` 类故意覆盖某些 bean 定义。
有关使用示例，请参阅 `@Configuration` 的文档。

### 文档内容分析

* 接受组件类作为输入。组件类被  `@Configuration` 、 `@Component` 和使用它作为元注解的注解、`javax.inject` 进行了注解。
* 可以逐个注册，也可以类路径扫描批量注册
* 后定义的 `@Bean` 方法后覆盖前面定义的 `@Bean` 方法。

### 类图

![AnnotationConfigApplicationContext-类图](images\AnnotationConfigApplicationContext-类图.png)

### 类结构

![AnnotationConfigApplicationContext-结构](images\AnnotationConfigApplicationContext-结构.png)

类中的方法分为三类：

* 构造函数
* `reader` 和 `scanner` 相关：包括设置和使用
* 重写的 `registerBean` 方法

#### 读取器和扫描器

##### 声明

`AnnotationConfigApplicationContext` 类组合了两个字段 `AnnotatedBeanDefinitionReader reader` 和 `ClassPathBeanDefinitionScanner scanner`。

> `ClassPathBeanDefinitionScanner scanner` 用于包扫描
>
>  `AnnotatedBeanDefinitionReader reader` 用于类注册

##### 设置

该类还提供了三个方法用来设置 ` scanner` 和 `reader` 。

* `setEnvironment` ：将给定的自定义 `Environment` 传播到底层的 ` scanner` 和 `reader` ，默认是 `StandardEnvironment`。
* `setBeanNameGenerator` ：设置 bean 名称生成器，默认是 `AnnotationBeanNameGenerator`，并且使用了单例模式。
* `setScopeMetadataResolver`： 设置作用域元数据解析器，默认是 `AnnotationScopeMetadataResolver`，非单例。

注意，对这些设置方法的调用，必须在调用 `register` 和 `scanner` 方法之前。

##### 应用

请注意，必须调用 `refresh()` 才能使上下文完全处理新类。

###### 注册

注册一个或多个要处理的组件类。`register` 调用是幂等的；多次添加相同的组件类没有额外的效果。

![context.annotation.AnnotationConfigApplicationContext-register](images\context.annotation.AnnotationConfigApplicationContext-register.png)

###### 扫描

在指定的基本包中执行扫描。

![context.annotation.AnnotationConfigApplicationContext-scan](images\context.annotation.AnnotationConfigApplicationContext-scan.png)

#### 构造函数

该类内置了四个构造函数：无参、父级 bean 工厂、组件类、组件类所在包。

##### 无组件类

前两种构造函数，主要操作是初始化 `scanner` 和 `reader`。

![context.annotation.AnnotationConfigApplicationContext-constructor-1](images\context.annotation.AnnotationConfigApplicationContext-constructor-1.png)

如果使用这两种构造函数，还需要手动 `register` 或 `scan`，并 `refresh`。

##### 有组件类

后两种构造函数，主要操作是注册或扫描组件类，并刷新。

![context.annotation.AnnotationConfigApplicationContext-constructor-2](images\context.annotation.AnnotationConfigApplicationContext-constructor-2.png)

#### `registerBean`

##### 委托

`org.springframework.context.support.GenericApplicationContext` 类中的所有的 `registerBean` 方法都委托给同一个 `registerBean` 方法：

![context.support.GenericApplicationContext-registerBean](images\context.support.GenericApplicationContext-registerBean.png)

##### 实现

方法内容如下：

![context.support.GenericApplicationContext-registerBean-内容](images\context.support.GenericApplicationContext-registerBean-内容.png)

从给定的 bean 类 `beanClass` 注册一个 bean，使用给定的供应商 `supplier` 获取新实例（通常声明为 lambda 表达式或方法引用），可选择自定义其 bean 定义元数据（再次通常声明为 lambda 表达式）。
可以重写此方法以适应所有 `registerBean` 方法的注册机制（因为它们都委托给这个方法）。

##### 重写

`GenericApplicationContext` 的四个内置实现类中，只有 `AnnotationConfigApplicationContext` 类重写了 `registerBean` 方法。

![context.annotation.AnnotationConfigApplicationContext-registerBean](images\context.annotation.AnnotationConfigApplicationContext-registerBean.png)



## 具体流程

三步走：

* 构造并初始化 `ApplicationContext`
* 配置 `reader` 和 `scanner`，并注册组件类，扫描组件类包。
* 刷新



