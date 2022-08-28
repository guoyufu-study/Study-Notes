# `BeanDefinition`

> `org.springframework.beans.factory.config.BeanDefinition`

## 概述

`BeanDefinition` 描述了一个 bean 实例，它具有属性值、构造函数参数值和具体实现提供的进一步信息。
这只是一个最小的接口：主要目的是允许 `BeanFactoryPostProcessor` 内省和修改属性值和其他 bean 元数据。

### 类结构

![Bean Definition 结构](images\beans.factory.config.BeanDefinition-类结构.png)

### 类层次结构

![BeanDefinition子类型](images\beans.factory.config.BeanDefinition-子类型.png)

#### spring-beans

##### `AbstractBeanDefinition`

<img src="images\beans.factory.support.AbstractBeanDefinition-类图.png" alt="beans.factory.support.AbstractBeanDefinition-类图" style="zoom:50%;" />



##### `AnnotatedGenericBeanDefinition`

<img src="images\beans.factory.annotation.AnnotatedGenericBeanDefinition-类图.png" alt="beans.factory.annotation.AnnotatedGenericBeanDefinition-类图" style="zoom:50%;" />

#### spring-context

##### `ConfigurationClassBeanDefinition`

<img src="images\context.annotation.ConfigurationClassBeanDefinitionReader.ConfigurationClassBeanDefinition-类图.png" alt="context.annotation.ConfigurationClassBeanDefinitionReader.ConfigurationClassBeanDefinition-类图" style="zoom: 40%;" />

##### `ScannedGenericBeanDefinition`

<img src="images\context.annotation.ScannedGenericBeanDefinition-类图.png" alt="context.annotation.ScannedGenericBeanDefinition-类图" style="zoom:45%;" />





