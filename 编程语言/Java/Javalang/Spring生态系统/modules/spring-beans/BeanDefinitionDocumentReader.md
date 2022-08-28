# `BeanDefinition` `Document` 读取器

## 前置知识点

顶级 `<beans>` 标签的 7 个属性

![顶级beans标签](images\顶级beans标签.png)

5 个根级别元素

![根级别元素](images\根级别元素.png)

## `BeanDefinitionDocumentReader`

> `org.springframework.beans.factory.xml.BeanDefinitionDocumentReader`

用于解析包含 Spring bean 定义的 XML 文档的 SPI。由 `XmlBeanDefinitionReader` 用于实际解析 DOM 文档。
按文档实例化以进行解析：实现可以在执行 `registerBeanDefinitions` 方法期间在实例变量中保存状态——例如，为文档中的所有 bean 定义定义的全局设置。

![beans.factory.xml.BeanDefinitionDocumentReader](images\beans.factory.xml.BeanDefinitionDocumentReader.png)



`registerBeanDefinitions` 从给定的 DOM 文档中读取 bean 定义，并将它们注册到给定读取器上下文中的注册表中。



## `DefaultBeanDefinitionDocumentReader`

> `org.springframework.beans.factory.xml.DefaultBeanDefinitionDocumentReader`

`BeanDefinitionDocumentReader` 接口的默认实现，该接口根据 `spring-beans` DTD 和 XSD 格式（Spring 的默认 XML bean 定义格式）读取 bean 定义。
所需 XML 文档的结构、元素和属性名称在此类中进行了**硬编码**。 （当然，如果需要生成这种格式，可以运行转换）。 `<beans>` 不需要是 XML 文档的根元素：该类将解析 XML 文件中的所有 bean 定义元素，而不考虑实际的根元素。



### 类结构

![DefaultBeanDefinitionDocumentReader结构](images\beans.factory.xml.DefaultBeanDefinitionDocumentReader-类结构.png)

### 处理流程

入口

![DefaultBeanDefinitionDocumentReader](images\beans.factory.xml.DefaultBeanDefinitionDocumentReader-registerBeanDefinitions.png)

下面注册 `BeanDefinition`s

![DefaultBeanDefinitionDocumentReader](images\beans.factory.xml.DefaultBeanDefinitionDocumentReader-doRegisterBeanDefinitions.png)

分四步走：

* 处理 `profile` 属性
* 预处理
* 解析 `BeanDefinition`s
* 后处理

下面解析 `BeanDefinition`s

![DefaultBeanDefinitionDocumentReader#parseBeanDefinitions](images\beans.factory.xml.DefaultBeanDefinitionDocumentReader-parseBeanDefinitions.png)

根据给定节点是否指示默认命名空间分别处理。

下面处理默认命名空间节点：

![DefaultBeanDefinitionDocumentReader#parseDefaultElement](images\beans.factory.xml.DefaultBeanDefinitionDocumentReader-parseDefaultElement.png)

默认命名空间根级别元素 `import`、`alias`、`bean`、`beans`。

下面处理 `BeanDefinition`s

![DefaultBeanDefinitionDocumentReader#processBeanDefinition](images\beans.factory.xml.DefaultBeanDefinitionDocumentReader-processBeanDefinition.png)

分四步走：

* **解析**提供的 `<bean>` 元素。如果在解析过程中出现错误，可能会返回 `null` 。错误报告给`org.springframework.beans.factory.parsing.ProblemReporter` 。
* 如果适用，通过命名空间处理程序**装饰**给定的 bean 定义。
* **注册**最终的装饰实例。
* 发送注册**事件**。