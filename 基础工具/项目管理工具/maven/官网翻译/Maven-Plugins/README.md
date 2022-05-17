# 可用插件

> https://maven.apache.org/plugins/index.html

Maven 就是一个插件执行框架。

* 构建插件：在构建过程中执行，应在 POM 中的`<Build />`元素中配置它们。
* 报告插件：在站点生成期间执行，并且应在 POM 中的`<Reporting />`元素中配置它们。由于报告插件的结果是所生成的站点的一部分，因此报告插件应该是国际化和本地化的。

## 核心插件

与默认核心阶段对应的插件。

* [clean](基础工具/项目管理工具/maven/官网翻译/Maven-Plugins/maven-clean-plugin.md)
* [compiler](基础工具/项目管理工具/maven/官网翻译/Maven-Plugins/maven-compiler-plugin.md)
* deploy
* failsafe
* install
* [resources](基础工具/项目管理工具/maven/官网翻译/Maven-Plugins/maven-resources-plugin.md)
* site
* surefire
* verifier

## 打包类型和工具

这些插件与打包相应的构件类型相关。

* jar
* war
* shade
* jlink

## 报告插件

生成报告的插件，配置为POM中的报告，并在 site 生命周期下运行。

* checkstyle
* javadoc
* pmd
* project-info-reports
* surefire-report

## 工具

默认情况下，这些是通过Maven提供的杂项工具。

* archetype
* dependency
* gpg
* help
* plugin
* release
* scm
* [wrapper](基础工具/项目管理工具/maven/官网翻译/Maven-Plugins/maven-wrapper-plugin.md)