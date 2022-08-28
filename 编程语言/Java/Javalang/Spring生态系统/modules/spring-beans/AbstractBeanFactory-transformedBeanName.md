### 规范 bean 名称

> `org.springframework.beans.factory.support.AbstractBeanFactory#transformedBeanName`

返回 bean 名称，必要时去除工厂解引用前缀，并将别名解析为规范名称。

![org.springframework.beans.factory.support.AbstractBeanFactory-transformedBeanName](images\beans.factory.support.AbstractBeanFactory-transformedBeanName.png)

#### 转换后的 Bean 名称

> `org.springframework.beans.factory.BeanFactoryUtils#transformedBeanName`

返回实际的 bean 名称。如果有工厂解引用前缀，去掉前缀。如果有重复的工厂解引用前缀，也去掉重复的前缀。

![beans.factory.BeanFactoryUtils-transformedBeanName](images\beans.factory.BeanFactoryUtils-transformedBeanName.png)

#### 规范名称

> `org.springframework.core.SimpleAliasRegistry#canonicalName`

确定原始名称，将别名解析为规范名称。

![core.SimpleAliasRegistry-canonicalName](images\core.SimpleAliasRegistry-canonicalName.png)

`org.springframework.core.SimpleAliasRegistry#aliasMap` ：从别名映射到规范名称

![core.SimpleAliasRegistry-aliasMap](images\core.SimpleAliasRegistry-aliasMap.png)