# `DefaultListableBeanFactory`

### 类图

#### 原始功能

> `2001.04` 创建

<img src="G:/文档工具/docsify/study-notes/编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/images/DefaultListableBeanFactory-父级类图-2001.04.png" alt="DefaultListableBeanFactory-父级类图-2001.04" style="zoom:50%;" />

> `2001.04.13` 引入`org.springframework.beans.factory.BeanFactory`

用于访问 Spring bean 容器的根接口。
这是 bean 容器的基本客户端视图；其他接口，如 `ListableBeanFactory` 和 `org.springframework.beans.factory.config.ConfigurableBeanFactory` 可用于特定目的。

> `2001.04.15` 引入 `org.springframework.beans.factory.support.AbstractBeanFactory`

`BeanFactory` 实现的抽象基类，提供 `ConfigurableBeanFactory` SPI 的全部功能。不假定一个可列出的 bean 工厂：因此也可以用作 bean 工厂实现的基类，它从一些后端资源获取 bean 定义（其中 bean 定义访问是一项昂贵的操作）。

此类提供单例缓存（通过其基类 `DefaultSingletonBeanRegistry`）、单例/原型确定、 `FactoryBean` 处理、别名、合并子 bean 定义的 bean 定义和 bean 销毁（ `org.springframework.beans.factory.DisposableBean` 接口，自定义销毁方法） . 此外，它可以通过实现 `org.springframework.beans.factory.HierarchicalBeanFactory` 接口来管理 bean 工厂层次结构（在未知 bean 的情况下委托给父级）。

**子类实现的主要模板方法**是 `getBeanDefinition` 和 `createBean` ，分别是提供 bean 名称检索 bean 定义和提供 bean 定义创建 bean 实例。这些操作的默认实现可以在 `DefaultListableBeanFactory` 和 `AbstractAutowireCapableBeanFactory` 中找到。

> ``2001.04.15` 引入 `org.springframework.beans.factory.ListableBeanFactory`

`BeanFactory` 接口的扩展，由**可以枚举其所有 bean 实例**的 bean 工厂实现，而不是按照客户的要求逐个尝试按名称查找 bean。**预加载所有 bean 定义**的 `BeanFactory` 实现（例如基于 XML 的工厂）可以实现此接口。
如果这是 `HierarchicalBeanFactory` ，则返回值不会考虑任何 `BeanFactory` 层次结构，而只会与当前工厂中定义的 bean 相关。也可以使用 `BeanFactoryUtils` 辅助类来考虑祖先工厂中的 bean。
此接口中的方法将仅尊重此工厂的 bean 定义。他们将忽略任何已通过其他方式注册的单例 bean，例如 `org.springframework.beans.factory.config.ConfigurableBeanFactory` 的 `registerSingleton` 方法，但 `getBeanNamesForType` 和 `getBeansOfType` 除外，它们也会检查此类手动注册的单例。当然，`BeanFactory` 的 `getBean` 也允许对这些特殊 bean 进行透明访问。但是，在典型场景中，无论如何，所有 bean 都将由外部 bean 定义来定义，因此大多数应用程序不需要担心这种区分。
注意：除了 `getBeanDefinitionCount` 和 `containsBeanDefinition` 之外，此接口中的方法**不是为频繁调用而设计的**。实施可能很慢。

>``2001.04.15` 引入 `org.springframework.beans.factory.support.DefaultListableBeanFactory`

Spring 的 `ConfigurableListableBeanFactory` 和 `BeanDefinitionRegistry` 接口的默认实现：一个基于 bean 定义元数据的成熟 bean 工厂，可通过后处理器进行扩展。
典型用法是**在访问 bean 之前先注册所有 bean 定义**（可能从 bean 定义文件中读取）。因此，按名称查找 Bean 是本地 bean 定义表中的一种廉价操作，它对预先解析的 bean 定义元数据对象进行操作。
请注意，**特定 bean 定义格式的读取器通常是单独实现的**，而不是作为 bean 工厂子类：例如参见 `org.springframework.beans.factory.xml.XmlBeanDefinitionReader` 。
对于 `org.springframework.beans.factory.ListableBeanFactory` 接口的替代实现，请查看 `StaticListableBeanFactory` ，它管理现有的 bean 实例，而不是基于 bean 定义创建新实例。





#### 层次结构

> `2003.07` 引入 `org.springframework.beans.factory.HierarchicalBeanFactory`

<img src="G:/文档工具/docsify/study-notes/编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/images/DefaultListableBeanFactory-父级类图-2003.07.png" alt="DefaultListableBeanFactory-父级类图-2003.07" style="zoom:50%;" />

由可以成为层次结构一部分的 bean 工厂实现的子接口。
可以在 `ConfigurableBeanFactory` 接口中找到允许以可配置方式设置父级的 bean 工厂的相应 `setParentBeanFactory` 方法。

#### 工厂配置功能

> ``2003.11.03` 引入

<img src="G:/文档工具/docsify/study-notes/编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/images/DefaultListableBeanFactory-父级类图-2003.11.03.png" alt="DefaultListableBeanFactory-父级类图-2003.11.03" style="zoom:50%;" />

> `org.springframework.beans.factory.config.ConfigurableBeanFactory`

大多数 bean 工厂要实现的配置接口。除了 `BeanFactory` 接口中的 bean 工厂**客户端方法**之外，还**提供了配置 bean 工厂的工具**。
这个 bean factory 接口并**不意味着在正常的应用程序代码中使用**：坚持使用 `BeanFactory` 或`org.springframework.beans.factory.ListableBeanFactory` 来满足典型需求。这个扩展接口只是为了**允许框架内部的即插即用**和**对 bean 工厂配置方法的特殊访问**。

> `org.springframework.beans.factory.config.ConfigurableListableBeanFactory`

大多数可列出的 bean 工厂要实现的配置接口。除了 `ConfigurableBeanFactory` 之外，它还提供了分析和修改 bean 定义以及预实例化单例的工具。
`org.springframework.beans.factory.BeanFactory` 的这个子接口并**不意味着在正常的应用程序代码中使用**：对于典型用例，请坚持使用`org.springframework.beans.factory.BeanFactory` 或 `ListableBeanFactory` 。这个接口**只是为了允许框架内部的即插即用**，即使在需要访问 bean 工厂配置方法时也是如此。

#### `BeanDefinition` 注册表功能

> `2003.11.26` 引入 `org.springframework.beans.factory.support.BeanDefinitionRegistry`

<img src="G:/文档工具/docsify/study-notes/编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/images/DefaultListableBeanFactory-父级类图-2003.11.26.png" alt="DefaultListableBeanFactory-父级类图-2003.11.26" style="zoom:50%;" />

**包含 bean 定义的注册表**的接口，例如 `RootBeanDefinition` 和 `ChildBeanDefinition` 实例。通常由内部使用 `AbstractBeanDefinition` 层次结构的 `BeanFactorie`s 实现。
这是 Spring 的 bean factory 包中**唯一封装 bean 定义注册的接口**。标准 `BeanFactory` 接口仅涵盖对完全配置的工厂实例的访问。
Spring 的 bean 定义读取器期望在这个接口的实现上工作。 Spring 核心中的已知实现者是 `DefaultListableBeanFactory` 和 `GenericApplicationContext`。

#### 自动装配功能

> `2003.12` 引入  `org.springframework.beans.factory.config.AutowireCapableBeanFactory`

<img src="G:/文档工具/docsify/study-notes/编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/images/DefaultListableBeanFactory-父级类图-2003.12.png" alt="DefaultListableBeanFactory-父级类图-2003.12" style="zoom: 43%;" />

`BeanFactory` 接口的扩展，由能够自动装配的 bean 工厂实现，前提是他们希望为现有的 bean 实例公开此功能。
`BeanFactory` 的这个子接口并**不打算在正常的应用程序代码中使用**：对于典型的用例，请坚持使用 `BeanFactory` 或`org.springframework.beans.factory.ListableBeanFactory` 。
**其他框架的集成代码可以利用此接口**来装配和填充其生命周期不受 Spring 控制的现有 bean 实例。例如，这对于 `WebWork Actions` 和 `Tapestry Page` 对象特别有用。
请注意，这个接口不是由 `org.springframework.context.ApplicationContext` 门面实现的，因为它几乎不被应用程序代码使用。也就是说，它也可以从应用程序上下文中获得，可以通过 `ApplicationContext` 的 `org.springframework.context.ApplicationContext.getAutowireCapableBeanFactory()` 方法访问。
您还可以实现 `org.springframework.beans.factory.BeanFactoryAware` 接口，即使在 `ApplicationContext` 中运行时也会公开内部 `BeanFactory`，以访问 `AutowireCapableBeanFactory`：只需将传入的 `BeanFactory` 转换为 `AutowireCapableBeanFactory`。



#### 实现默认 bean 创建

> `2004.02` 引入 `org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory`

<img src="G:/文档工具/docsify/study-notes/编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/images/DefaultListableBeanFactory-父级类图-2004.02.png" alt="DefaultListableBeanFactory-父级类图-2004.02" style="zoom: 43%;" />

实现默认 bean 创建的抽象 bean 工厂超类，具有 `RootBeanDefinition` 类指定的全部功能。除了实现了 `AbstractBeanFactory` 的 `createBean` 方法外，还实现了 `AutowireCapableBeanFactory` 接口。
提供 bean 创建（使用构造函数解析）、属性填充、装配（包括自动装配）和初始化。处理运行时 bean 引用、解析托管集合、调用初始化方法等。支持自动装配构造函数、按名称的属性和按类型的属性。
子类要实现的主要模板方法是 `resolveDependency(DependencyDescriptor, String, Set, TypeConverter)` ，用于按类型自动装配。如果工厂能够搜索其 bean 定义，匹配的 bean 通常将通过这样的搜索来实现。对于其他工厂风格，可以实现简化的匹配算法。
请注意，此类不假定或实现 bean 定义注册表功能。有关 `org.springframework.beans.factory.ListableBeanFactory` 和 `BeanDefinitionRegistry` 接口的实现，请参见 `DefaultListableBeanFactory` ，它们分别表示此类工厂的 API 和 SPI 视图。



#### 单例管理

> `2.0` 引入

<img src="G:/文档工具/docsify/study-notes/编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/images/DefaultListableBeanFactory-父级类图-2.0.png" alt="DefaultListableBeanFactory-父级类图-2.0" style="zoom: 43%;" />

> `org.springframework.beans.factory.config.SingletonBeanRegistry`

为共享 bean 实例定义**注册表的接口**。可以由 `org.springframework.beans.factory.BeanFactory` 实现来实现，以便以统一的方式公开它们的单例管理设施。
`ConfigurableBeanFactory` 接口扩展了这个接口。

> `org.springframework.beans.factory.support.DefaultSingletonBeanRegistry`

共享 bean 实例的**通用注册表**，实现 `SingletonBeanRegistry` 。允许注册单例实例，以通过 bean 名称获取，这些单例实例应为注册表的所有调用者共享的。
还支持注册 `DisposableBean` 实例（可能对应于注册的单例，也可能不对应），以在注册表关闭时销毁。可以注册 bean 之间的依赖关系以强制执行适当的关闭顺序。
该类主要作为 `org.springframework.beans.factory.BeanFactory` 实现的基类，分解出单例 bean 实例的通用管理。注意 `org.springframework.beans.factory.config.ConfigurableBeanFactory` 接口扩展了 `SingletonBeanRegistry` 接口。
请注意，与 `AbstractBeanFactory` 和 `DefaultListableBeanFactory` （继承自它）相比，此类既不假定 bean 定义概念，也不假定 bean 实例的特定创建过程。或者也可以用作嵌套助手来委托。



#### `FactoryBean` 功能

> `2.5.1` 引入 `org.springframework.beans.factory.support.FactoryBeanRegistrySupport`

需要处理 `FactoryBean` 实例的单例注册表的支持基类，与 `DefaultSingletonBeanRegistry` 的单例管理集成。
作为 `AbstractBeanFactory` 的基类。

![DefaultListableBeanFactory-父级类图-2.5.1](G:/文档工具/docsify/study-notes/编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/images/DefaultListableBeanFactory-父级类图-2.5.1.png)

#### 别名功能

> `2.5.2` 引入 `org.springframework.core.AliasRegistry` 和 `org.springframework.core.SimpleAliasRegistry`

![DefaultListableBeanFactory-父级类图-2.5.2](G:/文档工具/docsify/study-notes/编程语言/Java/Javalang/Spring生态系统/modules/spring-beans/images/DefaultListableBeanFactory-父级类图-2.5.2.png)

