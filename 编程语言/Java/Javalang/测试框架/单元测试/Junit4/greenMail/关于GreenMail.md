# 关于GreenMail

**轻量级的和沙箱email服务器的开源套件，支持SMTP、POP3和IMAP。**

官网主页  http://www.icegreen.com/greenmail/

## 简介

`GreenMail`是一个email服务器测试套件，目的是用于测试。它是开源的，直观，并且易于使用。

典型的用例包括用于开发的邮件集成测试或轻量级沙箱邮件服务器。

* 支持SMTP, POP3和IMAP包括SSL
* 防止意外的电子邮件泄漏到真正的邮件服务器
* 提供不同的部署模型，如简单的独立JVM进程、WAR模块、JBoss GreenMail服务或docker映像
* 易于嵌入到JUnit测试中进行集成测试
* 轻量级的，很少依赖

`GreenMail`是第一个，也是唯一一个为从Java接收和检索电子邮件提供测试框架的库。



``` java
@Rule
public final GreenMailRule greenMail = new GreenMailRule(ServerSetupTest.SMTP);

@Test
public void testSend() throws MessagingException {
    GreenMailUtil.sendTextEmailTest("to@localhost.com", "from@localhost.com",
        "some subject", "some body"); // --- Place your sending code here instead
    assertEquals("some body", GreenMailUtil.getBody(greenMail.getReceivedMessages()[0]));
}
```

