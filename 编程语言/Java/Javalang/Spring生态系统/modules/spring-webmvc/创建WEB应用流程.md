# 创建 WEB 应用

IDEA 2022.2 (Ultimate Edition)

## 准备工作

### 配置构建工具

如 Maven

![在 IDEA 中配置构建工具 Maven](images\IDEA中配置构建工具Maven.png)

### 配置应用服务器

如 Tomcat

![在 IDEA 中配置应用服务器 Tomcat](images\IDEA中配置应用服务器Tomcat.png)

## 创建 WEB 应用

![在 IDEA 中创建 WEB 应用](images\IDEA中创建WEB应用.png)

### 模板

模板有三个选项

* WEB 应用程序（`servlet`、`web.xml`、`index.jsp`）
* REST服务（JAX-RS 资源）
* 库（仅依赖项）

此处选择 WEB 应用程序。

### 应用程序服务器

应用程序服务器的下拉列表展示的是准备工作阶段配置的应用服务器。

应用程序服务器的选择会影响下一步操作的选择，因为不同的服务器版本，支持的 Java EE 或 Jakarta EE 版本是不同的。

此处选择 Tomcat 9.x。

点击下一步。

### 版本和依赖项

![选择版本和依赖项](images\IDEA中创建WEB应用-选择版本.png)

Tomcat 不同版本支持不同 Java EE 或 Jakarta EE 版本

* Tomcat 9.x 支持 Java EE 8
* Tomcat 10.0.x 支持 Jakarta EE 9
* Tomcat 10.1.x 支持 Jakarta EE 10（开发中）

因为上一步选择 Tomcat 9.x，所以此处选择 Java EE 8。

在依赖项中的规范分支中，默认选中了 Servlet 。

点击创建，IDEA 根据配置自动创建 WEB 应用程序。

![结果](images\IDEA中创建WEB应用-结果.png)

### 测试

![测试](images\IDEA中创建WEB应用-测试.png)