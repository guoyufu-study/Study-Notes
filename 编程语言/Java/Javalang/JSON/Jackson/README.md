# Jackson

> https://github.com/FasterXML/jackson

## 活动项目

下面列出的大多数项目都是由 Jackson 开发团队领导的;还有一些是 Jackson 社区的其他成员写的。我们试图保持模块的版本兼容，以减少关于哪些版本一起工作的混淆。

### 核心模块

核心模块是扩展(模块)构建的基础。目前有 3 个这样的模块(截至Jackson 2.x):

- [Streaming](https://github.com/FasterXML/jackson-core) ([docs](https://github.com/FasterXML/jackson-core/wiki)) ("jackson-core") 定义了低级的流 API，包括特定于 JSON 的实现
- [Annotations](编程语言/Java/Javalang/JSON/Jackson/jackson-annotations.md) ([docs](https://github.com/FasterXML/jackson-annotations/wiki)) ("jackson-annotations") 包含标准的 Jackson 注解
- [Databind](https://github.com/FasterXML/jackson-databind) ([docs](https://github.com/FasterXML/jackson-databind/wiki)) ("jackson-databind") 实现对 `streaming` 包的数据绑定(和对象序列化)支持；它同时依赖于 `streaming` 和 `annotations` 包。

### 第三方数据类型模块

### 数据格式模块

