# 编程指南

> https://www.eclipse.org/aspectj/doc/released/progguide/index.html

本编程指南描述了 AspectJ 语言。配套指南描述了作为 AspectJ 开发环境的一部分的工具。

如果您对 AspectJ 完全陌生，您应该首先阅读 [AspectJ 入门](编程语言/Java/Javalang/AspectJ/编程指南/入门/)，以全面了解 AspectJ 中的编程。如果您已经熟悉 AspectJ，但想要更深入地了解它，您应该阅读 [AspectJ 语言](编程语言/Java/Javalang/AspectJ/编程指南/语言/)并查看本章中的示例。如果您想要更正式的 AspectJ 定义，您应该阅读[语义](编程语言/Java/Javalang/AspectJ/编程指南/语义/)。

* [前言](编程语言/Java/Javalang/AspectJ/编程指南/前言.md)

* [入门](编程语言/Java/Javalang/AspectJ/编程指南/入门/)

* [AspectJ 语言](编程语言/Java/Javalang/AspectJ/编程指南/语言/)

* [示例](编程语言/Java/Javalang/AspectJ/编程指南/示例/)

* 成语

* 陷阱

* [快速参考](编程语言/Java/Javalang/AspectJ/编程指南/快速参考/)

* [语言语义](编程语言/Java/Javalang/AspectJ/编程指南/语义/)

* 实现说明

### 新手的建议路径

要学习 AspectJ 语言，请阅读 [编程指南](编程语言/Java/Javalang/AspectJ/编程指南/)，将[语义附录](编程语言/Java/Javalang/AspectJ/编程指南/语义/)作为使用 AspectJ 的最佳参考。首先关注连接点模型和切点，这是 AOP 向 OOP 添加的概念。要了解[示例](编程语言/Java/Javalang/AspectJ/编程指南/示例/)的工作原理，请参阅[编程指南](编程语言/Java/Javalang/AspectJ/编程指南/)中的[示例](编程语言/Java/Javalang/AspectJ/编程指南/示例/)部分。使用[AJDT](http://eclipse.org/ajdt)查看和导航横切结构 ；如果您不能使用 Eclipse，请尝试 `ajbrowser` 结构查看器，如[开发环境指南](https://www.eclipse.org/aspectj/doc/released/devguide/index.html)中的 [AspectJ 浏览器](https://www.eclipse.org/aspectj/doc/released/devguide/ajbrowser.html)部分所述。

要开始在您自己的代码中使用 AspectJ，请修改示例切面以应用于您的类。在学习过程中，可以使用编译器的`-Xlint`标志来捕捉一些常见错误。（了解 [当前的实现](https://www.eclipse.org/aspectj/doc/released/progguide/implementation.html) 仅限于对编译器控件进行编码。）

要计划如何在项目中采用 AspectJ，请阅读关于开发时切面和生产时切面的[编程指南](编程语言/Java/Javalang/AspectJ/编程指南/)，以及[FAQ](https://www.eclipse.org/aspectj/doc/released/faq.html)条目[我应该如何开始使用 AspectJ ？](https://www.eclipse.org/aspectj/doc/released/faq.html#q:startUsingAJ) , [决定采用 AspectJ](https://www.eclipse.org/aspectj/doc/released/faq.html#adoption)、开发工具部分（[一](https://www.eclipse.org/aspectj/doc/released/faq.html#q:integrateWithDevTools)、 [二](https://www.eclipse.org/aspectj/doc/released/faq.html#devtools)、 [Load-time weaving](https://www.eclipse.org/aspectj/doc/released/faq.html#ltw) ）和 [AspectJ 作为开源](https://www.eclipse.org/aspectj/doc/released/faq.html#q:opensource)。
