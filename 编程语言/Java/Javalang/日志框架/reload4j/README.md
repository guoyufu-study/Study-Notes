## reload4j 项目

> https://reload4j.qos.ch/

reload4j 项目由 Apache log4j 1.x 的原作者 Ceki Gülcü 发起，是 Apache log4j 版本 1.2.17 的一个分支，旨在解决紧迫的安全问题。它旨在**作为 log4j 版本 1.2.17 的直接替代品**。通过插入，我们的意思是在您的构建中用 *reload4j.jar* 替换 *log4j .jar*， 而无需更改*.java*文件中的源代码 。

reload4j 项目为成千上万迫切需要修复 log4j 1.2.17 中的漏洞的用户提供了一条清晰而简单的迁移路径。

### 目标

如上所述，reload4j 项目旨在修复 log4j 1.2.17 中最紧迫的问题。这是通过以下步骤完成的：

- 标准化和[清理](https://github.com/qos-ch/reload4j/issues/1) 构建 - 在 1.2.18.0 中修复
- [CVE-2021-4104 (JMSAppender)](https://cve.report/CVE-2021-4104) - 通过强化在 1.2.18.0 中修复
- [CVE-2022-23302 (JMSSink)](https://cve.report/CVE-2022-23302) - 通过强化在 1.2.18.1 中修复
- [CVE-2019-17571 (SocketServer)](https://cve.report/CVE-2019-17571) - 通过强化在 1.2.18.0 中修复
- [CVE-2020-9493](https://cve.report/CVE-2020-9493) 和[CVE-2022-23307（电锯）](https://cve.report/CVE-2022-23307) - 通过强化在 1.2.18.1 中修复
- [CVE-2022-23305 (JDBCAppender)](https://cve.report/CVE-2022-23305) - 通过强化组件在 1.2.18.2 中修复。
- [较新 JDK 中损坏的 MDC](https://github.com/qos-ch/reload4j/issues/4) - 已在 1.2.18.0 中修复
- XML 实体注入攻击 - 通过强化在 1.2.18.3 中修复
- [CVE-2020-9488 (SMTPAppender)](https://cve.report/CVE-2020-9488)通过强化在 1.2.18.3 中修复
- 修复了新发现的针对1.2.22 中通过加固修复的[电锯的 XXE 漏洞](https://github.com/qos-ch/reload4j/issues/53)

请参阅[新闻页面](https://reload4j.qos.ch/news.html)了解更多详情。

由于 log4j 1.x 和 reload4j 都没有提供消息查找机制，因此它们没有受到臭名昭著的[log4shell](https://www.slf4j.org/log4shell.html) 漏洞的影响。

