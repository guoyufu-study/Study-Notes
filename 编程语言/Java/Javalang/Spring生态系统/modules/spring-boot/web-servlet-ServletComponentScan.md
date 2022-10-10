## `ServletComponentScan`

> `org.springframework.boot.web.servlet.ServletComponentScan`

### 分析

#### 类声明

启用对 Servlet 组件（ filters 、 servlets和listeners器）的扫描。仅在使用嵌入式 Web 服务器时才执行扫描。
通常，应指定 `value` 、 `basePackages` 或 `basePackageClasses` 来控制要扫描组件的包。在它们不存在的情况下，将从带有注解的类的包中执行扫描。

![web-servlet-ServletComponentScan-注解声明](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\web-servlet-ServletComponentScan-注解声明.png)

#### 注解方法

![web-servlet-ServletComponentScan-注解方法](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\web-servlet-ServletComponentScan-注解方法.png)

## `ServletComponentScanRegistrar`

> `org.springframework.boot.web.servlet.ServletComponentScanRegistrar`

`@ServletComponentScan` 使用的 `ImportBeanDefinitionRegistrar`。

