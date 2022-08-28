# `BeanDefinition` 读取器

> `org.springframework.beans.factory.support.BeanDefinitionReader`

## 核心流程

需求：解读给定的配置文件，生成 `BeanDefinition`，并缓存结果。

### 入口：实例化 XMLBeanFactory

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

### 调用流程

![实例化XmlBeanFactory](images\实例化XmlBeanFactory.png)



## 类层次结构

![Bean Definition Reader 类层次结构](images\beans.factory.support.BeanDefinitionReader-类层次结构.png)

<img src="images\beans.factory.support.BeanDefinitionReader-类图.png" alt="BeanDefinitionReader-类图" style="zoom: 40%;" />



## `BeanDefinitionReader`

**bean 定义读取器**的简单接口，它指定带有 `Resource` 位置参数和 `String` 位置参数的**加载方法**。

具体的 bean 定义读取器当然可以为 bean 定义添加额外的加载和注册方法，这些方法特定于它们的 bean 定义格式。

请注意，bean 定义读取器不必实现此接口。它仅作为希望遵循标准命名约定的 bean 定义读取器的**建议**。

### 类结构

![Bean Definition Reader 结构](images\beans.factory.support.BeanDefinitionReader-类结构.png)

提供了 4 个重载的 `BeanDefinition` 加载方法。

同时提供了 4 个属性，用来辅助加载。

### 辅助属性

#### `BeanDefinitionRegistry`

返回 bean 工厂以注册 bean 定义。
工厂通过 `BeanDefinitionRegistry` 接口公开，封装了与 bean 定义处理相关的方法。

![beans.factory.support.BeanDefinitionReader-getRegistry](images\beans.factory.support.BeanDefinitionReader-getRegistry.png)

#### `ResourceLoader`

返回 `ResourceLoader`。 `ResourceLoader` 用于资源位置。
可以检查 `ResourcePatternResolver` 接口并进行相应的转换，以便为给定的资源模式加载多个资源。
返回值 `null` 表明绝对资源加载不适用于这个 bean 定义阅读器。
这主要用于从 bean 定义资源中导入更多资源，例如通过 XML bean 定义中的 `import` 标签。但是，建议相对于定义资源应用此类导入；只有显式的完整资源位置才会触发基于绝对路径的资源加载。
还有一个 `loadBeanDefinitions(String)` 方法可用，用于从资源位置（或位置模式）加载 bean 定义。这可以方便地避免显式 `ResourceLoader` 处理。

![beans.factory.support.BeanDefinitionReader-getResourceLoader](images\beans.factory.support.BeanDefinitionReader-getResourceLoader.png)

#### `ClassLoader`

返回用于 bean 类的类加载器。
`null` 建议不要急切地加载 bean 类，而只是用类名注册 bean 定义，稍后（或永远不会）解析相应的类。

![beans.factory.support.BeanDefinitionReader-getBeanClassLoader](images\beans.factory.support.BeanDefinitionReader-getBeanClassLoader.png)

#### `BeanNameGenerator`

返回 `BeanNameGenerator` 以用于匿名 bean（未指定显式 bean 名称）。

![beans.factory.support.BeanDefinitionReader-getBeanNameGenerator](images\beans.factory.support.BeanDefinitionReader-getBeanNameGenerator.png)

### 加载 `BeanDefinition` 方法

#### Resource 资源

从指定资源加载 bean 定义。

![beans.factory.support.BeanDefinitionReader-loadBeanDefinitions-Resource](images\beans.factory.support.BeanDefinitionReader-loadBeanDefinitions-Resource.png)

#### String 位置或位置模式

从指定的资源位置加载 bean 定义。
位置也可以是位置模式，前提是此 bean 定义读取器的 `ResourceLoader` 是 `ResourcePatternResolver`。

![beans.factory.support.BeanDefinitionReader-loadBeanDefinitions-location](images\beans.factory.support.BeanDefinitionReader-loadBeanDefinitions-location.png)



## `AbstractBeanDefinitionReader`

实现 `BeanDefinitionReader` 接口的 bean 定义读取器的**抽象基类**。
**提供通用属性**，例如要处理的 bean 工厂和用于加载 bean 类的类加载器。

![Abstract Bean Definition Reader结构](images\AbstractBeanDefinitionReader结构.png)



### 构造器

为给定的 bean 工厂创建一个新的 `AbstractBeanDefinitionReader`。
如果传入的 bean factory 不仅实现了 `BeanDefinitionRegistry` 接口，还实现了 `ResourceLoader` 接口，那么它也会被用作默认的 `ResourceLoader`。这通常是 `org.springframework.context.ApplicationContext` 实现的情况。
如果给定一个普通的 `BeanDefinitionRegistry`，默认的 `ResourceLoader` 将是一个`PathMatchingResourcePatternResolver` 。
如果传入的 bean 工厂也实现了 `EnvironmentCapable` 它的环境将被这个读取器使用。否则，读取器将初始化并使用 `StandardEnvironment` 。所有的 `ApplicationContext` 实现都是 `EnvironmentCapable`，而普通的 `BeanFactory` 实现不是。

![beans.factory.support.AbstractBeanDefinitionReader-构造函数](images\beans.factory.support.AbstractBeanDefinitionReader-构造函数.png)

### 辅助属性

在 `BeanDefinition` 接口的基础上提供了 `Environment` 属性，并实现了 `EnvironmentCapable` 接口。

![beans.factory.support.AbstractBeanDefinitionReader-属性](images\beans.factory.support.AbstractBeanDefinitionReader-属性.png)

 `registry` 是 `final` 的，也就没有为 `registry` 属性提供设置器。构造实例时，将传入的 `BeanDefinitionRegistry` 赋值给它。

`resourceLoader` 默认值是 `PathMatchingResourcePatternResolver`。

`environment` 默认值是 `StandardEnvironment`。

`beanNameGenerator` 默认值是 `DefaultBeanNameGenerator`。

`beanClassLoader` 默认值是 `null`。这表明不要急切地加载 bean 类，而只是用类名注册 bean 定义，并在以后（或永远不会）解析相应的类。

### 加载 `BeanDefinition`

#### Resource 资源

两个接口方法，在这里只实现了一个。

![beans.factory.support.AbstractBeanDefinitionReader-loadBeanDefinitions-resource](images\beans.factory.support.AbstractBeanDefinitionReader-loadBeanDefinitions-resource.png)

#### String 位置或位置模式

两个接口方法，都在这里实现。

![beans.factory.support.AbstractBeanDefinitionReader-loadBeanDefinitions-location](images\beans.factory.support.AbstractBeanDefinitionReader-loadBeanDefinitions-location.png)

给定 String 位置或位置模式的两个加载方法实现，最终都委托给下面的加载方法进行处理。

![beans.factory.support.AbstractBeanDefinitionReader-loadBeanDefinitions](images\beans.factory.support.AbstractBeanDefinitionReader-loadBeanDefinitions.png)

根据 `ResourceLoader` 分三种情况：

* 不存在：抛异常。
* `ResourcePatternResolver` 类型：资源模式匹配可用。将位置模式（例如，Ant 样式的路径模式）解析为 `Resource` 对象数组。
* 其它：只能通过绝对 URL 加载单个资源。

![beans.factory.support.AbstractBeanDefinitionReader-loadBeanDefinitions-2](images\beans.factory.support.AbstractBeanDefinitionReader-loadBeanDefinitions-2.png)

### 抽象方法

> `BeanDefinitionReader#loadBeanDefinitions(org.springframework.core.io.Resource)` 

所有的加载 `BeanDefinition` 方法，最终都委托给这个方法进行处理。

![beans.factory.support.BeanDefinitionReader-loadBeanDefinitions-Resource-single](images\beans.factory.support.BeanDefinitionReader-loadBeanDefinitions-Resource-single.png)

`AbstractBeanDefinitionReader` 没有实现这个方法，它把最终加载逻辑，留给子类实现。

## `XmlBeanDefinitionReader`

> `org.springframework.beans.factory.xml.XmlBeanDefinitionReader`

XML bean 定义的 bean 定义阅读器。将实际的 XML 文档读取委托给 `BeanDefinitionDocumentReader` 接口的实现。
通常应用于 `org.springframework.beans.factory.support.DefaultListableBeanFactory` 或`org.springframework.context.support.GenericApplicationContext`。
此类加载一个 DOM 文档并将 `BeanDefinitionDocumentReader` 应用到它。文档阅读器将向给定的 bean 工厂注册每个 bean 定义，并与后者的 `BeanDefinitionRegistry` 接口实现对话。

![XmlBeanDefinitionReader结构](images\beans.factory.xml.XmlBeanDefinitionReader-类结构.png)

### 辅助属性

有两类属性：加载文档相关，包括验证；文档读取器相关。

#### 加载文档相关

![beans.factory.xml.XmlBeanDefinitionReader-属性-加载文档-验证相关](images\beans.factory.xml.XmlBeanDefinitionReader-属性-加载文档-验证相关.png)

![beans.factory.xml.XmlBeanDefinitionReader-属性-加载文档相关](images\beans.factory.xml.XmlBeanDefinitionReader-属性-加载文档相关.png)

#### 文档读取器相关

![beans.factory.xml.XmlBeanDefinitionReader-属性-文档读取器相关](images\beans.factory.xml.XmlBeanDefinitionReader-属性-文档读取器相关.png)

#### 资源循环加载快速失败

![beans.factory.xml.XmlBeanDefinitionReader-属性-资源循环加载](images\beans.factory.xml.XmlBeanDefinitionReader-属性-资源循环加载.png)



### 构造器

为给定的 bean 工厂创建新的 `XmlBeanDefinitionReader`。

![beans.factory.xml.XmlBeanDefinitionReader-构造函数](images\beans.factory.xml.XmlBeanDefinitionReader-构造函数.png)



### 加载 `BeanDefinition`



#### 准备加载

封装 `EncodedResource`。为给定的 `Resource` 创建一个新的 `EncodedResource` ，而不是指定显式编码或 `Charset` 。

![beans.factory.xml.XmlBeanDefinitionReader-loadBeanDefinitions-resource](images\beans.factory.xml.XmlBeanDefinitionReader-loadBeanDefinitions-resource.png)

循环加载快速失败：加载前，添加加载记录。如果添加失败，说明当前已经在加载这个 `EncodedResource`，现在是在循环加载，抛异常。加载后，移除记录。

![beans.factory.xml.XmlBeanDefinitionReader-resourcesCurrentlyBeingLoaded](images\beans.factory.xml.XmlBeanDefinitionReader-resourcesCurrentlyBeingLoaded.png)

封装 `org.xml.sax.InputSource`，包括设置字符编码。

![beans.factory.xml.XmlBeanDefinitionReader-loadBeanDefinitions-2](images\beans.factory.xml.XmlBeanDefinitionReader-loadBeanDefinitions-EncodedResource.png)

#### 实际加载

实际地从指定的 XML 文件加载 bean 定义。

![beans.factory.xml.XmlBeanDefinitionReader-doLoadBeanDefinitions](images\beans.factory.xml.XmlBeanDefinitionReader-doLoadBeanDefinitions.png)

加载文档：使用配置的 `DocumentLoader` 实际加载指定的文档。

![beans.factory.xml.XmlBeanDefinitionReader-doLoadDocument](images\beans.factory.xml.XmlBeanDefinitionReader-doLoadDocument.png)

注册 `BeanDefinition`：

注册包含在给定 DOM 文档中的 bean 定义。由 `loadBeanDefinitions` 调用。
创建解析器类的新实例并在其上调用 `registerBeanDefinitions` 。

![beans.factory.xml.XmlBeanDefinitionReader-registerBeanDefinitions](images\beans.factory.xml.XmlBeanDefinitionReader-registerBeanDefinitions.png)

创建 `BeanDefinitionDocumentReader` 和 `XmlReaderContext` ：

创建 `BeanDefinitionDocumentReader` 以用于从 XML 文档中实际读取 bean 定义。
默认实现实例化指定的 `documentReaderClass`。

创建 `XmlReaderContext` 以传递给文档阅读器。

![beans.factory.xml.XmlBeanDefinitionReader-createBeanDefinitionDocumentReader](images\beans.factory.xml.XmlBeanDefinitionReader-createBeanDefinitionDocumentReader.png)



最后委托 `org.springframework.beans.factory.xml.DefaultBeanDefinitionDocumentReader#registerBeanDefinitions`。

## `GroovyBeanDefinitionReader`

## `PropertiesBeanDefinitionReader`

从 5.3 开始，支持 Spring 的通用 bean 定义格式和/或自定义读取器实现