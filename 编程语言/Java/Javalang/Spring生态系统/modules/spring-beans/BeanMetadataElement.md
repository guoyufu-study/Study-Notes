# BeanMetadataElement

> `org.springframework.beans.BeanMetadataElement`

承载配置源对象的 bean 元数据元素。

## 类结构

![BeanMetadataElement](images\BeanMetadataElement结构.png)

## 子类型

![子类型](images\BeanMetadataElement子类型.png)

### 可合并 Mergeable

> `org.springframework.beans.Mergeable`

对象的值集**可合并**父对象的值集。

> **支持父子定义合并**，且子定义会覆盖父定义。

#### 结构

![Mergeable 结构](images\Mergeable结构.png)

使用 `Object merge(@Nullable Object parent)` 方法执行合并操作。合并时，提供的对象被认为是父对象，被调用者的值集中的值必须**覆盖**提供的对象的值。

#### 子类型

![Mergeable子类型](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-beans\images\Mergeable的子类型.png)









### 方法重写 MethodOverride

> `org.springframework.beans.factory.support.MethodOverride`

 IoC 容器对托管对象的方法覆盖。

``` java
public abstract boolean matches(Method method);
```

子类必须重写这个抽象方法，以指示它们是否匹配给定的方法。这允许参数列表检查以及方法名称检查。

#### MethodOverrides

方法覆盖集合，确定 Spring IoC 容器将在运行时覆盖托管对象上的哪些方法（如果有）。
当前支持的 `MethodOverride` 变体是 `LookupOverride` 和 `ReplaceOverride` 。

> `AbstractBeanDefinition` 中持有该类型的属性。

#### LookupOverride

> `org.springframework.beans.factory.support.LookupOverride`

表示通过 bean 名称或 bean 类型（基于声明的方法返回类型）在同一 IoC 上下文中查找对象的方法的覆盖。
符合查找覆盖条件的方法可以声明参数，在这种情况下，给定的参数将传递给 bean 检索操作。

#### MethodReplacer

> `org.springframework.beans.factory.support.MethodReplacer`

可以**在 IoC 管理的对象上重新实现任何方法**的类的接口：依赖注入的**方法注入**形式。

这样的方法可以是（但不必是）抽象的，在这种情况下，容器将创建一个具体的子类来实例化。



### 别名 AliasDefinition

> `org.springframework.beans.factory.parsing.AliasDefinition`

在解析过程中注册的别名的表示。

### 属性 BeanMetadataAttribute

作为 bean 定义一部分的键值样式属性的持有者。除了键值对之外，还跟踪定义源。

![BeanMetadataAttribute 结构](images\BeanMetadataAttribute结构.png)

### 属性访问器 BeanMetadataAttributeAccessor

`AttributeAccessorSupport` 的扩展，将属性保存为 `BeanMetadataAttribute` 对象，以便跟踪定义源。

![BeanMetadataAttributeAccessor层次结构](images\BeanMetadataAttributeAccessor层次结构.png)

### BeanDefinitionHolder

> `org.springframework.beans.factory.config.BeanDefinitionHolder`

具有名称和别名的 `BeanDefinition` 的持有者。可以注册为内部 bean 的占位符。
也可用于内部 bean 定义的编程注册。如果不关心 `BeanNameAware` 之类的，注册 `RootBeanDefinition` 或 `ChildBeanDefinition` 就足够了。

![Bean Definition Holder 结构](images\BeanDefinitionHolder结构.png)



### 默认定义 DefaultsDefinition

> `org.springframework.beans.factory.parsing.DefaultsDefinition`

默认定义的标记接口，扩展 `BeanMetadataElement` 以继承源公开。
具体实现通常基于“文档默认值”，例如在 XML 文档的根标记级别指定

#### DocumentDefaultsDefinition

> `org.springframework.beans.factory.xml.DocumentDefaultsDefinition`

简单的 JavaBean，它包含在标准 Spring XML bean 定义文档中的 `<beans>` 级别指定的默认值： `default-lazy-init` 、 `default-autowire`等。

![spring xml](images\beans级别默认值.png)

![DocumentDefaultsDefinition 结构](images\DocumentDefaultsDefinition结构.png)