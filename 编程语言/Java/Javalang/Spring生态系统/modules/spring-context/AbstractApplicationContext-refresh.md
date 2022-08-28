# `refresh`

## 概述

![ApplicationContext-实现类_refresh-应用](images\ApplicationContext-实现类_refresh.png)

### 声明

> `org.springframework.context.ConfigurableApplicationContext#refresh`

![context.ConfigurableApplicationContext-refresh](images\context.ConfigurableApplicationContext-refresh.png)



### 实现

> `org.springframework.context.support.AbstractApplicationContext#refresh`

只有一个内置实现。

### 调用

在多个 `AbstractApplicationContext` 实现类的构造函数中都有调用。

## 方法内容分析

### 同步监视器

“刷新”和“销毁”的同步监视器。

![context.support.AbstractApplicationContext-startupShutdownMonitor](images\context.support.AbstractApplicationContext-startupShutdownMonitor.png)



#### 刷新

![context.support.AbstractApplicationContext-refresh-加锁](images\context.support.AbstractApplicationContext-refresh-加锁.png)

#### JVM 关闭挂钩

向 JVM 运行时注册一个名为 `SpringContextShutdownHook` 的关闭钩子，在 JVM 关闭时关闭此上下文，除非它当时已经关闭。
委托 `doClose()` 执行实际的关闭过程。

![context.support.AbstractApplicationContext-registerShutdownHook](images\context.support.AbstractApplicationContext-registerShutdownHook.png)

#### 关闭

关闭此应用程序上下文，销毁其 bean 工厂中的所有 bean。
委托 `doClose()` 执行实际的关闭过程。如果注册了一个 JVM 关闭挂钩，还会删除这个挂钩，因为它不再需要了。

![context.support.AbstractApplicationContext-destroy](images\context.support.AbstractApplicationContext-destroy.png)

### 具体流程

#### 准备上下文

为刷新准备这个上下文，设置它的启动日期和活动标志，以及执行任何属性源的初始化。

![context.support.AbstractApplicationContext-prepareRefresh](images\context.support.AbstractApplicationContext-prepareRefresh.png)

##### 设置启动日期和活动标志

![context.ConfigurableApplicationContext-flags](images\context.ConfigurableApplicationContext-flags.png)

###### `active` 标志

指示这个上下文当前是否处于活动状态。

在 6 个地方使用了 `active` ：

* `prepareRefresh` 方法，为刷新准备这个上下文。一开始就设置成 `true`。
* `cancelRefresh` 方法：取消这个上下文的刷新尝试，在抛出异常后重置 `active` 标志。设置成 `false`。
* `doClose` 方法：实际执行上下文关闭。先检查 `active` 是否 `true`，关闭上下文后，设置成 `false`。
* `isActive` 方法：判断此应用上下文是否处于活动状态，即是否至少刷新过一次且尚未关闭。
* `assertBeanFactoryActive` 方法：断言此上下文的 `BeanFactory` 当前处于活动状态。

###### `closed` 标志

指示这个上下文是否已关闭。

在 3 个位置使用了 `closed` ：

* `prepareRefresh` 方法，为刷新准备这个上下文。一开始就设置成 `false`。
* `doClose` 方法：实际执行上下文关闭。一开始，执行原子操作，将 `false` 设置成 `true`。
* `assertBeanFactoryActive` 方法：断言此上下文的 `BeanFactory` 当前处于活动状态。

##### 初始化属性源

###### 抽象模板

用实际实例替换任何存根属性源。

![context.support.AbstractApplicationContext-initPropertySources-抽象](images\context.support.AbstractApplicationContext-initPropertySources-抽象.png)

###### 内置实现

`spring-web` 在下面三个类中分别提供了内置实现。

![context.support.AbstractApplicationContext-initPropertySources-重写](images\context.support.AbstractApplicationContext-initPropertySources-重写.png)

##### 验证必要属性

验证标记为必需的所有属性都是可解析的：请参阅 `ConfigurablePropertyResolver#setRequiredProperties`

###### 声明

验证 `setRequiredProperties` 指定的每个属性是否存在并解析为非 `null` 值

![core.env.ConfigurablePropertyResolver-requiredProperties](images\core.env.ConfigurablePropertyResolver-requiredProperties.png)

###### 实现

`org.springframework.core.env.AbstractPropertyResolver` 实现

![core.env.AbstractPropertyResolver-requiredProperties](images\core.env.AbstractPropertyResolver-requiredProperties.jpg)

`org.springframework.core.env.AbstractEnvironment` 实现

![core.env.AbstractEnvironment-requiredProperties](images\core.env.AbstractEnvironment-requiredProperties.png)

##### 监听器

...

#### 获取新鲜 `BeanFactory`

告诉子类刷新内部 bean 工厂。

##### 声明

子类必须实现此方法才能执行实际的配置加载。该方法在任何其他初始化工作之前由 `refresh()` 调用。
子类将创建一个新的 bean 工厂并持有对它的引用，或者返回它持有的单个 `BeanFactory` 实例。在后一种情况下，如果多次刷新上下文，它通常会抛出 `IllegalStateException`。

![context.support.AbstractApplicationContext-抽象方法](images\context.support.AbstractApplicationContext-抽象方法.png)

##### 实现

`org.springframework.context.support.GenericApplicationContext#refreshBeanFactory` 实现

什么也不做：我们持有一个单独的内部 `BeanFactory`，并依赖调用者通过我们的公共方法(或 `BeanFactory` 的)注册 bean。

![context.support.GenericApplicationContext-refreshBeanFactory](images\context.support.GenericApplicationContext-refreshBeanFactory.png)

`org.springframework.context.support.AbstractRefreshableApplicationContext#refreshBeanFactory` 实现

此实现执行这个上下文的底层 bean 工厂的实际刷新，如果先前有 bean 工厂，先关闭先前的 bean 工厂，并为上下文生命周期的下一阶段初始化一个新的 bean 工厂。

![context.support.AbstractRefreshableApplicationContext-refreshBeanFactory](images\context.support.AbstractRefreshableApplicationContext-refreshBeanFactory.png)

#### 准备 `BeanFactory`

准备在这个上下文中使用的 bean 工厂。

告诉内部 bean 工厂使用上下文的类加载器等





#### `BeanFactory` 后处理

允许在上下文子类中对 bean 工厂进行后处理。