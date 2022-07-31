# InstantiationStrategy

> `org.springframework.beans.factory.support.InstantiationStrategy`

接口，**负责创建与根bean定义对应的实例**。
由于**可以采用各种方法**，包括使用 CGLIB 动态创建子类以支持方法注入，因此这被引入了一种策略。

## SimpleInstantiationStrategy

> `org.springframework.beans.factory.support.SimpleInstantiationStrategy`

在 `BeanFactory` 中使用的**简单对象实例化策略**。
**不支持方法注入**，尽管它为子类提供了可以重写的钩子来添加方法注入支持，例如通过重写方法。