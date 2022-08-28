## `AliasRegistry`

> `org.springframework.core.AliasRegistry`

### 概述

`AliasRegistry` 接口的简单实现。
作为`org.springframework.beans.factory.support.BeanDefinitionRegistry` 实现的基类。

> DAG，有向无环图。
>
> `registerAlias` 相当于添加一条有向边，如果添加后会形成环，则抛异常

#### 类结构

![core.SimpleAliasRegistry-结构](images\core.SimpleAliasRegistry-结构.png)