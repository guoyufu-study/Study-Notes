# getBean

## 概述

### 声明

在 `BeanFactory` 接口中声明了**获取 `Bean` 实例**的功能。

> `org.springframework.beans.factory.BeanFactory` 

![org.springframework.beans.factory.BeanFactory-结构](images\beans.factory.BeanFactory-getBean-声明.png)

`BeanFactory` 接口中声明了两类获取 `Bean` 实例的方式：

* 通过 `name` 获取 `Bean` 实例
* 通过 `Class<T>` 获取 `Bean` 实例

### 实现

在 `AbstractBeanFactory` 抽象类中实现了**通过 `name` 获取 `Bean` 实例**功能

> `org.springframework.beans.factory.support.AbstractBeanFactory` 

![org.springframework.beans.factory.support.AbstractBeanFactory-getBean](images\beans.factory.support.AbstractBeanFactory-getBean-实现.png)

在 `DefaultListableBeanFactory` 类中实现了**通过 `Class<T>` 获取 `Bean` 实例**功能。

> `org.springframework.beans.factory.support.DefaultListableBeanFactory` 

![org.springframework.beans.factory.support.DefaultListableBeanFactory-getBean](images\beans.factory.support.DefaultListableBeanFactory-getBean-实现.png)

## 通过名称获取

### API 入口

![org.springframework.beans.factory.support.AbstractBeanFactory-getBean-代码](images\beans.factory.support.AbstractBeanFactory-getBean-代码.png)

### 内部实现 doGetBean

返回指定 bean 的一个实例，该实例可以是共享的，也可以是独立的。

<img src="images\doGetBean.png" alt="doGetBean"  />

源代码如下：

![org.springframework.beans.factory.support.AbstractBeanFactory-doGetBean-01](images\beans.factory.support.AbstractBeanFactory-doGetBean-01.png)

参数说明：

* `name`：要检索的 bean 的名称 
* `requiredType`：需要检索的 bean 类型
* `args`：使用显式参数创建 bean 实例时使用的参数（仅在创建新实例时应用，而不是检索现有实例时应用）

> 创建新实例时，传入的 `args` 会被应用。检索现有实例时，传入的 `args` 会被忽略。
>
> 比如，以下代码：
>
> ``` java
> XmlBeanFactory factory = new XmlBeanFactory(new ClassPathResource("spring.xml"));
> Person aaron = factory.getBean("jasper", Person.class, "Aaron", "America", LocalDate.of(2000, 1, 1));
> System.out.println(aaron);
> Person jasper = factory.getBean("jasper", Person.class, "jasper", "China", LocalDate.of(2000, 2, 2));
> System.out.println(jasper);
> ```
>
> 两次打印结果相同。因为只有第一次传入的 `args` 被应用了，第二次传入的 `args` 被完全无视。



### 具体流程

* [规范 bean 名称](编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/AbstractBeanFactory-transformedBeanName.md)



### 获取 Bean

![org.springframework.beans.factory.support.AbstractBeanFactory-doGetBean-02](images\beans.factory.support.AbstractBeanFactory-doGetBean-02.png)

从单例缓存中查找

* 如果找到了相应单例，并且无参数要求：直接获取给定 bean 实例的对象。
* 如果没有找到，或者虽然找到但有参数要求：分情况讨论

#### 单例缓存

##### 单例缓存中查找单例

返回在给定名称下注册的（原始）单例对象。
检查已经实例化的单例，也允许对当前创建的单例进行早期引用（解决循环引用）。

* 没有完整的单例锁的情况下，快速检查现有的实例。
* 在完整的单例锁中一致地创建早期引用

![org.springframework.beans.factory.support.DefaultSingletonBeanRegistry-getSingleton-代码](images\beans.factory.support.DefaultSingletonBeanRegistry-getSingleton-代码.png)



##### 获取给定 bean 实例的对象

获取给定 bean 实例的对象，要么是 bean 实例本身，要么是其创建的对象（如果给定 bean 实例是 `FactoryBean`）。

![org.springframework.beans.factory.support.AbstractBeanFactory-getObjectForBeanInstance](images\beans.factory.support.AbstractBeanFactory-getObjectForBeanInstance.png)

按照名称是否有工厂解引用前缀 `&` 分两种情况：

* 有前缀 `&` 
* 没有前缀 `&` 

###### 工厂解引用前缀 `&`

如果 bean 不是工厂，不要让调用代码尝试解引用工厂。

![org.springframework.beans.factory.support.AbstractBeanFactory-getObjectForBeanInstance-01](images\beans.factory.support.AbstractBeanFactory-getObjectForBeanInstance-01.png)



###### 普通名称

现在我们有了 bean 实例，它可能是普通的 bean，也可能是 `FactoryBean`。如果它是一个 `FactoryBean`，我们使用它来创建一个 bean 实例，除非调用者实际上想要一个对工厂的引用。

![org.springframework.beans.factory.support.AbstractBeanFactory-getObjectForBeanInstance-02](images\beans.factory.support.AbstractBeanFactory-getObjectForBeanInstance-02.png)

#### 分情况讨论



##### 原型循环引用

如果发现循环引用原型，抛异常。

![org.springframework.beans.factory.support.AbstractBeanFactory-doGetBean-03-原型循环引用](images\beans.factory.support.AbstractBeanFactory-doGetBean-03-原型循环引用.png)

`prototypesCurrentlyInCreation`  是一个 线程本地变量。存储当前正在创建的 bean 的名称。

``` java
private final ThreadLocal<Object> prototypesCurrentlyInCreation =
    new NamedThreadLocal<>("Prototype beans currently in creation");
```

创建非单例 bean 前，会向 `prototypesCurrentlyInCreation` 中添加记录。

![org.springframework.beans.factory.support.AbstractBeanFactory-beforePrototypeCreation](images\beans.factory.support.AbstractBeanFactory-beforePrototypeCreation.png)

创建非单例 bean 完成后，会从 `prototypesCurrentlyInCreation` 中移除记录。

![org.springframework.beans.factory.support.AbstractBeanFactory-afterPrototypeCreation](images\beans.factory.support.AbstractBeanFactory-afterPrototypeCreation.png)

判断当前线程中，指定的非单例 bean 是否正在创建中。

![org.springframework.beans.factory.support.AbstractBeanFactory-isPrototypeCurrentlyInCreation](images\beans.factory.support.AbstractBeanFactory-isPrototypeCurrentlyInCreation.png)



##### 委托父级 `BeanFactory`

如果存在父级 `BeanFactory`，并且在当前 `BeanFactory` 中没有找到指定 bean 定义，则委托父级 `BeanFactory` 

![org.springframework.beans.factory.support.AbstractBeanFactory-doGetBean-03-委托父级BF](images\beans.factory.support.AbstractBeanFactory-doGetBean-03-委托父级BF.png)



##### 创建 bean 实例

分三步走：

* 转换 `BeanDefinition` 
* 递归实例化依赖的 bean：保证当前 bean 所依赖的 bean 的初始化。
* 实例化当前 bean：根据当前 bean 的作用域分三种情况实例化
  * 单例
  * 原型
  * 其他作用域

![org.springframework.beans.factory.support.AbstractBeanFactory-doGetBean-04-beanCreation](images\beans.factory.support.AbstractBeanFactory-doGetBean-04-beanCreation.png)

###### 转换 bean 定义

返回一个合并的 `RootBeanDefinition`，如果指定的 bean 对应于子 bean 定义，则遍历父 bean 定义。

![org.springframework.beans.factory.support.AbstractBeanFactory-getMergedLocalBeanDefinition](images\beans.factory.support.AbstractBeanFactory-getMergedLocalBeanDefinition.png)

> 如果 bean 定义不存在，会在调用 `getBeanDefinition()` 方法时，抛出 `NoSuchBeanDefinitionException` 异常。

先从 `mergedBeanDefinitions` 缓存中查找。`mergedBeanDefinitions` 是一个 `ConcurrentHashMap`，从 bean 名称映射到合并的 `RootBeanDefinition`

```java
private final Map<String, RootBeanDefinition> mergedBeanDefinitions = new ConcurrentHashMap<>(256);
```

如果给定 bean 的定义是子 bean 定义，则通过与父 bean 定义合并返回给定 bean 的 `RootBeanDefinition`。

> 使用全锁进行检查，以强制执行相同的合并实例。

![org.springframework.beans.factory.support.AbstractBeanFactory-getMergedBeanDefinition](images\beans.factory.support.AbstractBeanFactory-getMergedBeanDefinition.png)

两类 bean 定义：

* 根 bean 定义：使用给定根 bean 定义的副本。
* 子 bean 定义：需要与父合并。

![org.springframework.beans.factory.support.AbstractBeanFactory-getMergedBeanDefinition-01](images\beans.factory.support.AbstractBeanFactory-getMergedBeanDefinition-01.png)

如果之前没有配置作用域，设置默认的单例作用域。

包含在非单例 bean 中的 bean 本身不能是单例。让我们在这里动态地纠正这个问题，因为这可能是外部 bean 的父-子合并的结果，在这种情况下，原始内部 bean 定义将不会继承合并的外部 bean 的单例状态。

暂时缓存合并的 bean 定义（为了获得元数据的变更，以后仍然可能重新合并）

![org.springframework.beans.factory.support.AbstractBeanFactory-getMergedBeanDefinition-02](images\beans.factory.support.AbstractBeanFactory-getMergedBeanDefinition-02.png)

###### 检查合并后的 bean 定义

检查给定的合并 bean 定义，可能会引发验证异常。

![org.springframework.beans.factory.support.AbstractBeanFactory-checkMergedBeanDefinition](images\beans.factory.support.AbstractBeanFactory-checkMergedBeanDefinition.png)

###### 递归实例化依赖的 bean

![org.springframework.beans.factory.support.AbstractBeanFactory-doGetBean-04-beanCreation-dependson](images\beans.factory.support.AbstractBeanFactory-doGetBean-04-beanCreation-dependson.png)

###### 单例

![org.springframework.beans.factory.support.AbstractBeanFactory-doGetBean-04-beanCreation-singleton](images\org.springframework.beans.factory.support.AbstractBeanFactory-doGetBean-04-beanCreation-singleton.png)



###### 原型

![org.springframework.beans.factory.support.AbstractBeanFactory-doGetBean-04-beanCreation-prototype](images\beans.factory.support.AbstractBeanFactory-doGetBean-04-beanCreation-prototype.png)

###### 其它作用域

![org.springframework.beans.factory.support.AbstractBeanFactory-doGetBean-04-beanCreation-scope](images\beans.factory.support.AbstractBeanFactory-doGetBean-04-beanCreation-scope.png)



### 适配 Bean 实例

检查所需类型是否与实际 bean 实例的类型匹配。

* 不匹配，使用转换器转换。
* 匹配，直接强转。

![org.springframework.beans.factory.support.AbstractBeanFactory-adaptBeanInstance](images\beans.factory.support.AbstractBeanFactory-adaptBeanInstance.png)









## 通过类型获取

![org.springframework.beans.factory.support.DefaultListableBeanFactory-getBean-代码](images\beans.factory.support.DefaultListableBeanFactory-getBean-代码.png)



