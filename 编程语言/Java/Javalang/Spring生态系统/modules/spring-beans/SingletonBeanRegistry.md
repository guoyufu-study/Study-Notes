# `SingletonBeanRegistry`

> `org.springframework.beans.factory.config.SingletonBeanRegistry`

## 概述

为共享 bean 实例定义注册表的接口。可以由 `org.springframework.beans.factory.BeanFactory` 实现来实现，以便以统一的方式公开它们的单例管理设施。
`ConfigurableBeanFactory` 接口扩展了这个接口

### 类结构

![beans.factory.config.SingletonBeanRegistry-结构](images\beans.factory.config.SingletonBeanRegistry-结构.png)

### 实现

![beans.factory.support.DefaultSingletonBeanRegistry-结构](images\beans.factory.support.DefaultSingletonBeanRegistry-结构.png)

## `getSingleton`

