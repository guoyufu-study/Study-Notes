## POM 参考文献

> https://maven.apache.org/pom.html

### 简介

[`POM 4.0.0 XSD`](http://maven.apache.org/xsd/maven-4.0.0.xsd)和[`描述符参考文档`](http://maven.apache.org/ref/current/maven-model/maven.html)

#### POM 是个啥?

 `POM`代表“项目对象模型”。它是一个maven项目的XML表示，保存在一个名为`pom.xml`的文件中。当Maven的人在场时，谈论一个项目是在哲学意义上说的，而不仅仅是包含代码的文件集合。项目包含配置文件、涉及的开发人员及其扮演的角色、缺陷跟踪系统、组织和许可证、项目所在位置的URL、项目的依赖项，以及所有其他为赋予代码生命而发挥作用的小部分。这是一个所有与项目有关的事情的一站式商店。事实上，在Maven世界中，项目根本不需要包含任何代码，只需要`pom.xml`。 

#### 快速概述

这是直接位于`POM`项目元素下的元素列表。 请注意，`modelVersion`包含`4.0.0`。 这是目前唯一支持`Maven 2`和3的`POM`版本，并且始终是必需的。

``` xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <!-- The Basics -->
    <groupId>...</groupId>
    <artifactId>...</artifactId>
    <version>...</version>
    <packaging>...</packaging>
    <dependencies>...</dependencies>
    <parent>...</parent>
    <dependencyManagement>...</dependencyManagement>
    <modules>...</modules>
    <properties>...</properties>

    <!-- Build Settings -->
    <build>...</build>
    <reporting>...</reporting>

    <!-- More Project Information -->
    <name>...</name>
    <description>...</description>
    <url>...</url>
    <inceptionYear>...</inceptionYear>
    <licenses>...</licenses>
    <organization>...</organization>
    <developers>...</developers>
    <contributors>...</contributors>

    <!-- Environment Settings -->
    <issueManagement>...</issueManagement>
    <ciManagement>...</ciManagement>
    <mailingLists>...</mailingLists>
    <scm>...</scm>
    <prerequisites>...</prerequisites>
    <repositories>...</repositories>
    <pluginRepositories>...</pluginRepositories>
    <distributionManagement>...</distributionManagement>
    <profiles>...</profiles>
</project>
```

### 基础知识

#### Maven坐标

#### POM关系

#### 属性

### 构建设置



### 更多项目信息

### 环境设置