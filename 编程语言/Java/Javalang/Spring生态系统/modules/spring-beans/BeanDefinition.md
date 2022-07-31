# BeanDefinition

> `org.springframework.beans.factory.config.BeanDefinition`

`BeanDefinition` 描述了一个 bean 实例，它具有属性值、构造函数参数值和具体实现提供的进一步信息。
这只是一个最小的接口：主要目的是允许 `BeanFactoryPostProcessor` 内省和修改属性值和其他 bean 元数据。

## 结构

![Bean Definition 结构](images\BeanDefination结构.png)

## 子类型

![Bean Definition 父类型](images\BeanDefinition父类型.png)

![BeanDefinition子类型](images\BeanDefinition子类型.png)