# NamespaceHandler

> `org.springframework.beans.factory.xml.NamespaceHandler`

## 标签处理器定义文件

Spring 把解析标签的类都放在了相应的 `META-INF\spring.handlers` 文件中。

比如：`mvc`标签

![sring-webmvc-标签处理器](images\sring-webmvc-标签处理器.png)



内容如下：

![sring-webmvc-标签处理器-内容](images\sring-webmvc-标签处理器-内容.png)

也就是说，Spring 使用 `org.springframework.web.servlet.config.MvcNamespaceHandler` 来处理 `mvc` 名称空间。

![xml-config-MvcNamespaceHandler](images\xml-config-MvcNamespaceHandler.png)

由代码可知，`MvcNamespaceHandler` 将解析 `<mvc:annotation-driven />` 的任务交给 `AnnotationDrivenBeanDefinitionParser` 处理。

## `NamespaceHandler` 子类型

![xml-config-NamespaceHandler-子类型](images\xml-config-NamespaceHandler-子类型.png)

![xml-config-NamespaceHandler](images\xml-config-NamespaceHandler.png)