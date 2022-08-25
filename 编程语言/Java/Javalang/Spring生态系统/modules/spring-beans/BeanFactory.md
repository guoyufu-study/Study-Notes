# BeanFactory

> `spring-beans` 包中的 `org.springframework.beans.factory.BeanFactory` 接口

![BeanFactory-类图](images\BeanFactory-类图.png)

##### 管理现有的 bean 实例

> `org.springframework.beans.factory.support.StaticListableBeanFactory` 

静态 `org.springframework.beans.factory.BeanFactory` 实现，它允许以编程方式注册现有的单例实例。
不支持原型 bean 或别名。
作为 `ListableBeanFactory` 接口的简单实现的示例，管理现有的 bean 实例而不是基于 bean 定义创建新的实例，并且不实现任何扩展的 SPI 接口（例如 `org.springframework.beans.factory.config.ConfigurableBeanFactory` ）。
对于基于 bean 定义的成熟工厂，请查看 `DefaultListableBeanFactory` 。

##### 基于 bean 定义创建新实例

> `org.springframework.beans.factory.support.DefaultListableBeanFactory`

Spring 的 `ConfigurableListableBeanFactory` 和 `BeanDefinitionRegistry` 接口的默认实现：一个基于 bean 定义元数据的成熟 bean 工厂，可通过后处理器进行扩展。
**典型用法**是在访问 bean 之前首先注册所有 bean 定义（可能从 bean 定义文件中读取）。因此，按名称查找 Bean 是本地 bean 定义表中的一种廉价操作，它对预先解析的 bean 定义元数据对象进行操作。
请注意，特定 bean 定义格式的读取器通常是单独实现的，而不是作为 bean 工厂子类：例如参见`org.springframework.beans.factory.xml.XmlBeanDefinitionReader` 。
对于 `org.springframework.beans.factory.ListableBeanFactory` 接口的替代实现，请查看 `StaticListableBeanFactory` ，它管理现有的 bean 实例，而不是基于 bean 定义创建新实例。