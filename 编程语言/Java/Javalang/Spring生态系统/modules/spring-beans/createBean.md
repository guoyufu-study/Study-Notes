# createBean

## 声明

`org.springframework.beans.factory.support.AbstractBeanFactory#createBean`

为给定的合并 bean 定义（和参数）创建一个 bean 实例。如果是子定义，bean 定义将已经与父定义合并。
所有 bean 检索方法都委托给此方法以**进行实际的 bean 创建**。

![org.springframework.beans.factory.support.AbstractBeanFactory-createBean](images\org.springframework.beans.factory.support.AbstractBeanFactory-createBean.png)

## 实现

> `org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#createBean(String, RootBeanDefinition, Object[])`

此类的中心方法：创建 bean 实例、填充 bean 实例、应用后处理器等。

具体步骤：

* 确保此时已经实际解析了 bean 类，如果动态解析的 Class 不能存储在共享合并 bean 定义中，则克隆bean定义。
* 准备方法覆盖。
* 让 `BeanPostProcessors` 有机会返回一个代理而不是目标 bean 实例。
* 创建 bean。

![org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory-createBean](images\org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory-createBean.png)

### 解析 bean 类

为指定的 bean 定义解析 bean 类。如果需要，将 bean 类名称解析为 Class 引用，并将解析的 Class 存储在 bean 定义中以供进一步使用。

> 先从合并后的 bean 定义 `mbd` 中找，如果找不到，则执行解析操作 `doResolveBeanClass`。

![org.springframework.beans.factory.support.AbstractBeanFactory-resolveBeanClass](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-beans\images\org.springframework.beans.factory.support.AbstractBeanFactory-resolveBeanClass.png)