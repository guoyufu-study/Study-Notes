# BeanDefinitionReader

> `org.springframework.beans.factory.support.BeanDefinitionReader`

**bean 定义读取器**的简单接口，它指定带有 `Resource` 和 `String` 位置参数的**加载方法**。

具体的 bean 定义读取器当然可以为 bean 定义添加额外的加载和注册方法，这些方法特定于它们的 bean 定义格式。

请注意，bean 定义读取器不必实现此接口。它仅作为希望遵循标准命名约定的 bean 定义读取器的**建议**。

## 结构

![Bean Definition Reader 结构](images\BeanDefinitionReader结构.png)

## 子类型

![Bean Definition Reader子类型](images\BeanDefinitionReader子类型.png)

![BeanDefinitionReader-类图](images\BeanDefinitionReader-类图.png)

### AbstractBeanDefinitionReader

实现 `BeanDefinitionReader` 接口的 bean 定义读取器的**抽象基类**。
**提供通用属性**，例如要处理的 bean 工厂和用于加载 bean 类的类加载器。

![Abstract Bean Definition Reader结构](images\AbstractBeanDefinitionReader结构.png)

### XmlBeanDefinitionReader

> `org.springframework.beans.factory.xml.XmlBeanDefinitionReader`

XML bean 定义的 bean 定义阅读器。将实际的 XML 文档读取委托给 `BeanDefinitionDocumentReader` 接口的实现。
通常应用于 `org.springframework.beans.factory.support.DefaultListableBeanFactory` 或`org.springframework.context.support.GenericApplicationContext`。
此类加载一个 DOM 文档并将 `BeanDefinitionDocumentReader` 应用到它。文档阅读器将向给定的 bean 工厂注册每个 bean 定义，并与后者的 `BeanDefinitionRegistry` 接口实现对话。

#### 入口：实例化 XMLBeanFactory

``` java
public class Main {
    public static void main(String[] args) {

        XmlBeanFactory beanFactory = new XmlBeanFactory(new ClassPathResource("application.xml"));

//        DefaultListableBeanFactory beanFactory = new DefaultListableBeanFactory();
//        XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(beanFactory);
//        reader.loadBeanDefinitions("application.xml");

        Arrays.stream(beanFactory.getBeanDefinitionNames()).forEach(System.out::println);
    }
}
```

流程图

![实例化XmlBeanFactory](images\实例化XmlBeanFactory.png)

#### 结构

![XmlBeanDefinitionReader结构](images\XmlBeanDefinitionReader结构.png)



#### DefaultBeanDefinitionDocumentReader

> `org.springframework.beans.factory.xml.DefaultBeanDefinitionDocumentReader`

`BeanDefinitionDocumentReader` 接口的默认实现，该接口根据 `spring-beans` DTD 和 XSD 格式（Spring 的默认 XML bean 定义格式）读取 bean 定义。
所需 XML 文档的结构、元素和属性名称在此类中进行了**硬编码**。 （当然，如果需要生成这种格式，可以运行转换）。 `<beans>` 不需要是 XML 文档的根元素：该类将解析 XML 文件中的所有 bean 定义元素，而不考虑实际的根元素。

##### 前置知识点

顶级 `<beans>` 标签的 7 个属性

![顶级beans标签](images\顶级beans标签.png)

5 个根级别元素

![根级别元素](images\根级别元素.png)

##### 结构

![DefaultBeanDefinitionDocumentReader结构](images\DefaultBeanDefinitionDocumentReader结构.png)

##### 处理流程

入口

![DefaultBeanDefinitionDocumentReader](images\DefaultBeanDefinitionDocumentReader#registerBeanDefinitions.png)

下面注册 BeanDefinitions

![DefaultBeanDefinitionDocumentReader](images\DefaultBeanDefinitionDocumentReader#doRegisterBeanDefinitions.png)

分四步走：

* 处理 `profile` 属性
* 预处理
* 解析 BeanDefinitions
* 后处理

下面解析 BeanDefinitions

![DefaultBeanDefinitionDocumentReader#parseBeanDefinitions](images\DefaultBeanDefinitionDocumentReader#parseBeanDefinitions.png)

根据给定节点是否指示默认命名空间分别处理。

下面处理默认命名空间节点：

![DefaultBeanDefinitionDocumentReader#parseDefaultElement](images\DefaultBeanDefinitionDocumentReader#parseDefaultElement.png)

默认命名空间根级别元素 `import`、`alias`、`bean`、`beans`。

下面处理 BeanDefinitions

![DefaultBeanDefinitionDocumentReader#processBeanDefinition](images\DefaultBeanDefinitionDocumentReader#processBeanDefinition.png)

分四步走：

* **解析**提供的 `<bean>` 元素。如果在解析过程中出现错误，可能会返回 `null` 。错误报告给`org.springframework.beans.factory.parsing.ProblemReporter` 。
* 如果适用，通过命名空间处理程序**装饰**给定的 bean 定义。
* **注册**最终的装饰实例。
* 发送注册**事件**。

### GroovyBeanDefinitionReader

### PropertiesBeanDefinitionReader

从 5.3 开始，支持 Spring 的通用 bean 定义格式和/或自定义读取器实现