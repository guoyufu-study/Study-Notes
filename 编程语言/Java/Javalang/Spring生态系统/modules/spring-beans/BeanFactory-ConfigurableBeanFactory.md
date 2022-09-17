# `ConfigurableBeanFactory`

> `org.springframework.beans.factory.config.ConfigurableBeanFactory`



## `ConfigurableBeanFactory`

> `org.springframework.beans.factory.config.ConfigurableBeanFactory`

### 类声明

大多数 `BeanFactory` 要实现的配置接口。除了 `BeanFactory` 接口中的 bean factory **客户端方法**之外，还**提供了配置 bean factory 的工具**。
这个 bean factory 接口并**不意味着在正常的应用程序代码中使用**：坚持使用 `BeanFactory` 或`org.springframework.beans.factory.ListableBeanFactory` 来满足典型需求。这个扩展接口只是为了**允许框架内部的即插即用**和**对 bean factory 配置方法的特殊访问**。

![beans.factory.config.ConfigurableBeanFactory-类声明](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-beans\images\beans.factory.config.ConfigurableBeanFactory-类声明.png)

### 类结构

#### 类加载器

![beans.factory.config.ConfigurableBeanFactory-ClassLoader](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-beans\images\beans.factory.config.ConfigurableBeanFactory-ClassLoader.png)

#### 表达式解析器



#### 嵌入值解析器

![beans.factory.config.ConfigurableBeanFactory-EmbeddedValueResolver](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-beans\images\beans.factory.config.ConfigurableBeanFactory-EmbeddedValueResolver.png)

#### `BeanPostProcessor`





#### 作用域

##### 声明

注册作用域、获取作用域：

![beans.factory.config.ConfigurableBeanFactory-scope-create-get](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-beans\images\beans.factory.config.ConfigurableBeanFactory-scope-create-get.png)

销毁 bean

![beans.factory.config.ConfigurableBeanFactory-scope-destroyScopedBean](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-beans\images\beans.factory.config.ConfigurableBeanFactory-scope-destroyScopedBean.png)

##### 实现方法

使用 `LinkedHashMap` 缓存注册的作用域。

![beans.factory.support.AbstractBeanFactory-scopes](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-beans\images\beans.factory.support.AbstractBeanFactory-scopes.png)

注册作用域、获取作用域：

![beans.factory.support.AbstractBeanFactory-scope-create-get](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-beans\images\beans.factory.support.AbstractBeanFactory-scope-create-get.png)

销毁 bean

![beans.factory.support.AbstractBeanFactory-scope-destroyScopedBean](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-beans\images\beans.factory.support.AbstractBeanFactory-scope-destroyScopedBean.png)



## `ConfigurableListableBeanFactory`

> `org.springframework.beans.factory.config.ConfigurableListableBeanFactory`

大多数可列出的 `BeanFactory` 要实现的配置接口。除了 `ConfigurableBeanFactory` 之外，它还提供了分析和修改 bean 定义以及预实例化单例的工具。
`org.springframework.beans.factory.BeanFactory` 的这个子接口并**不意味着在正常的应用程序代码中使用**：对于典型用例，请坚持使用`org.springframework.beans.factory.BeanFactory` 或 `ListableBeanFactory` 。这个接口**只是为了允许框架内部的即插即用**，即使在需要访问 `BeanFactory` 配置方法时也是如此。