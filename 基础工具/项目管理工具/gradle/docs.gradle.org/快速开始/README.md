# 入门

每个人都必须从某个地方开始，如果您是 Gradle 新手，那么这就是你开始的地方。

## 在你开始前

为了有效地使用 Gradle，您需要了解它是什么，并理解它的一些基本概念。因此，在您开始认真使用 Gradle 之前，我们强烈建议您阅读[什么是 Gradle？](基础工具/项目管理工具/gradle/docs.gradle.org/介绍/#what_is_gradle).

即使您有使用 Gradle 的经验，我们也建议您阅读[关于 Gradle 需要了解的 5 件事](基础工具/项目管理工具/gradle/docs.gradle.org/介绍/#five_things)，因为它消除了一些常见的误解。

## 安装

如果您只想运行现有的 Gradle 构建，那么如果构建具有 [Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html#gradle_wrapper)，可通过构建根目录中的*`gradlew`*和/或*`gradlew.bat`*文件识别，则无需安装 Gradle 。你只需要确保你的系统[满足 Gradle 的先决条件](https://docs.gradle.org/current/userguide/installation.html#sec:prerequisites)。

Android Studio 附带了 Gradle 的有效安装，因此在这种情况下您无需单独安装 Gradle。

为了创建新构建，或将 Wrapper 添加到现有构建，您需要[根据这些说明](https://docs.gradle.org/current/userguide/installation.html#installation)安装 Gradle 。请注意，除了该页面上描述的方法之外，可能还有其他安装 Gradle 的方法，因为几乎不可能跟踪所有的包管理器。

## 试试 Gradle :id=try_gradle

积极使用 Gradle 是了解它的好方法，因此一旦安装了 Gradle，请尝试以下介绍性动手教程之一：

- [构建 Android 应用程序](https://docs.gradle.org/current/samples/sample_building_android_apps.html)
- [构建 Java 应用程序](https://docs.gradle.org/current/samples/sample_building_java_applications.html)
- [构建 Java 库](https://docs.gradle.org/current/samples/sample_building_java_libraries.html)
- [构建 Groovy 应用程序](https://docs.gradle.org/current/samples/sample_building_groovy_applications.html)
- [构建 Groovy 库](https://docs.gradle.org/current/samples/sample_building_groovy_libraries.html)
- [构建 Scala 应用程序](https://docs.gradle.org/current/samples/sample_building_scala_applications.html)
- [构建 Scala 库](https://docs.gradle.org/current/samples/sample_building_scala_libraries.html)
- [构建 Kotlin JVM 应用程序](https://docs.gradle.org/current/samples/sample_building_kotlin_applications.html)
- [构建 Kotlin JVM 库](https://docs.gradle.org/current/samples/sample_building_kotlin_libraries.html)
- [构建 C++ 应用程序](https://docs.gradle.org/current/samples/sample_building_cpp_applications.html)
- [构建 C++ 库](https://docs.gradle.org/current/samples/sample_building_cpp_libraries.html)
- [构建 Swift 应用程序](https://docs.gradle.org/current/samples/sample_building_swift_applications.html)
- [构建 Swift 库](https://docs.gradle.org/current/samples/sample_building_swift_libraries.html)
- [创建构建扫描](https://scans.gradle.com/)

[示例页面](基础工具/项目管理工具/gradle/docs.gradle.org/快速开始/示例.md)上提供了更多示例。

## 命令行与 IDE

有些人是硬核命令行用户，而另一些人则更喜欢永远不离开舒适的 IDE。更多的人乐于同时使用两者，Gradle 努力不歧视。Gradle 受到[几个主要 IDE](https://docs.gradle.org/current/userguide/third_party_integration.html#ides)的支持，并且可以从[命令行](https://docs.gradle.org/current/userguide/command_line_interface.html#command_line_interface)完成的所有操作都可以通过[Tooling API](https://docs.gradle.org/current/userguide/third_party_integration.html#embedding)提供给 IDE 。

Android Studio 和 IntelliJ IDEA 用户在编辑它们时应考虑使用[Kotlin DSL 构建脚本](https://docs.gradle.org/current/userguide/kotlin_dsl.html#kotlin_dsl)以获得卓越的 IDE 支持。

## 执行 Gradle 构建

如果您遵循[上面链接](https://docs.gradle.org/current/userguide/getting_started.html#try_gradle)的任何教程，您将执行 Gradle 构建。但是，如果您在没有任何说明的情况下获得 Gradle 构建，您会怎么做？

以下是一些有用的步骤：

1. 确定项目是否有 Gradle 包装器，[如果有就使用它](https://docs.gradle.org/current/userguide/gradle_wrapper.html#sec:using_wrapper)——主要的 IDE 默认在包装器可用时使用它。

2. 发现项目结构。

   使用 IDE 导入构建，或从命令行运行`gradle projects`。如果仅列出根项目，则它是单项目构建。否则它是一个[多项目构建](https://docs.gradle.org/current/userguide/intro_multi_project_builds.html#intro_multi_project_builds)。

3. 找出可以运行的任务。

   如果您已将构建导入 IDE，您应该可以访问显示所有可用任务的视图。从命令行运行`gradle tasks`.

4. 通过 `gradle help --task <taskname>` 了解有关任务的更多信息。

   `help` 任务可以显示有关任务的额外信息，包括哪些项目包含该任务以及该任务支持哪些选项。

5. 运行您感兴趣的任务。

   许多基于约定的构建与 Gradle 的[生命周期任务](https://docs.gradle.org/current/userguide/base_plugin.html#sec:base_tasks)集成，因此当您不想对构建执行更具体的操作时，请使用它们。例如，大多数构建都有 `clean`、`check`、`assemble` 和 `build` 任务。

   从命令行，只需运行 `gradle <taskname>` 即可执行特定任务。您可以在[相应的用户手册章节](https://docs.gradle.org/current/userguide/command_line_interface.html#command_line_interface)中了解有关命令行执行的更多信息。如果您使用的是 IDE，请查看其文档以了解如何运行任务。

Gradle 构建通常遵循项目结构和任务的标准约定，因此，如果您熟悉相同类型的其他构建（比如 Java、Android 或原生构建），那么对于构建的文件和目录结构，以及许多的任务和项目属性，你也应该很熟悉。

对于更专业的构建或具有重要自定义的构建，理想情况下，您应该可以访问有关如何运行构建以及可以配置哪些[构建属性](https://docs.gradle.org/current/userguide/build_environment.html#build_environment)的文档。

## 编写 Gradle 构建

学习创建和维护 Gradle 构建是一个过程，而且需要一点时间。我们建议您从适合您的项目的核心插件及其约定开始，然后随着您对该工具的了解越来越多，逐步合并定制。

以下是掌握 Gradle 之旅的一些有用的第一步：

1. 尝试一两个[基本教程](基础工具/项目管理工具/gradle/docs.gradle.org/快速开始/#try_gradle)来了解 Gradle 构建的样子，尤其是那些与您使用的项目类型（Java、原生、Android 等）相匹配的教程。
2. 确保您已阅读[有关 Gradle 需要了解的 5 件事](基础工具/项目管理工具/gradle/docs.gradle.org/介绍/#five_things)！
3. 了解 Gradle 构建的基本元素：[项目](https://docs.gradle.org/current/userguide/tutorial_using_tasks.html#sec:projects_and_tasks)、[任务](https://docs.gradle.org/current/userguide/more_about_tasks.html#more_about_tasks)和[文件 API](https://docs.gradle.org/current/userguide/working_with_files.html#working_with_files)。
4. 如果您正在为 JVM 构建软件，请务必阅读 [Building Java & JVM projects](https://docs.gradle.org/current/userguide/building_java_projects.html#building_java_projects) 和 [Testing in Java & JVM projects](https://docs.gradle.org/current/userguide/java_testing.html#java_testing) 中有关这些类型项目的详细信息。
5. 熟悉 Gradle 随附的[核心插件](https://docs.gradle.org/current/userguide/plugin_reference.html#plugin_reference)，因为它们提供了许多开箱即用的有用功能。
6. 了解如何[编写可维护的构建脚本](https://docs.gradle.org/current/userguide/authoring_maintainable_build_scripts.html#authoring_maintainable_build_scripts)并[最好地组织您的 Gradle 项目](https://docs.gradle.org/current/userguide/organizing_gradle_projects.html#organizing_gradle_projects)。

用户手册包含许多其他有用的信息，您可以在[示例页面](https://docs.gradle.org/current/samples/index.html)上找到演示各种 Gradle 功能的示例。

## 将第三方工具与 Gradle 集成

Gradle 的灵活性意味着它可以轻松地与其他工具一起使用，比如我们的[Gradle 和第三方工具](https://docs.gradle.org/current/userguide/third_party_integration.html#third_party_integration)页上列出的工具。

有两种主要的集成模式：

- 一个工具驱动 Gradle——使用它来提取有关构建的信息并运行它——通过[Tooling API](https://docs.gradle.org/current/userguide/third_party_integration.html#embedding)
- Gradle 通过第三方工具的 API 调用或生成工具的信息——这通常通过插件和自定义任务类型来完成

具有现有基于 Java 的 API 的工具通常易于集成。您可以在 Gradle 的[插件门户](https://plugins.gradle.org/)上找到许多此类集成。