# Spring Boot Gradle Plugin

> https://docs.spring.io/spring-boot/docs/2.6.6/gradle-plugin/reference/htmlsingle/#getting-started

Spring Boot Gradle 插件在 Gradle 中提供 Spring Boot 支持。它允许我们打包可执行的 jar 或 war 归档、运行 Spring Boot 应用、并且使用 `spring-boot-dependencies` 提供的依赖管理。Spring Boot Gradle 插件需要 Gradle 6.8、6.9， 或 7.x，并且可以与 Gradle 的[配置缓存](https://docs.gradle.org/current/userguide/configuration_cache.html)一起使用。

## 入门

要开始使用这个插件，需要将它应用到你的项目中。

该插件[已发布到Gradle的插件门户网站](https://plugins.gradle.org/plugin/org.springframework.boot)，可以使用  `plugins` 块应用：

``` groovy
plugins {
    id 'org.springframework.boot' version '2.6.6'
}
```

单独应用插件对项目几乎没有什么改变。相反，当某些其他插件被应用时，插件会检测并做出相应的反应。例如，当应用 `java` 插件时，会自动配置构建可执行 jar 的任务。一个典型的 Spring Boot 项目最少应用 `groovy`、 `java 或 `org.jetbrains.kotlin.jvm` 插件，并且使用 `io.Spring.dependency-management` 插件或 Gradle 的本地 bom 支持来进行依赖管理。例如：

``` groovy
apply plugin: 'java'
apply plugin: 'io.spring.dependency-management'
```

要了解更多关于 Spring Boot 插件在其他插件被应用时的表现，请参阅[对其他插件的反应](https://docs.spring.io/spring-boot/docs/2.6.6/gradle-plugin/reference/htmlsingle/#reacting-to-other-plugins)部分。

## 管理依赖

