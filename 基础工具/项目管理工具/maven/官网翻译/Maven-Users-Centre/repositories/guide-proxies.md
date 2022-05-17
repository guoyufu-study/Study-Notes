## 配置代理

> https://maven.apache.org/guides/mini/guide-proxies.html

您可以使用 Maven 配置代理以用于部分或全部 HTTP 请求。仅当您的代理需要基本身份验证时才需要用户名和密码（请注意，以后的版本可能支持将您的密码存储在安全的密钥库中 - 同时，请确保您的 `settings.xml` 文件（通常是 `${user.home}/.m2/settings.xml`）使用适合您的操作系统的权限进行保护）。

`nonProxyHosts` 设置接受通配符，每个不代理的主机由 `|` 字符分隔。这与 JDK 配置等价。

```xml
    <settings>
      .
      .
      <proxies>
       <proxy>
          <id>example-proxy</id>
          <active>true</active>
          <protocol>http</protocol>
          <host>proxy.example.com</host>
          <port>8080</port>
          <username>proxyuser</username>
          <password>somepassword</password>
          <nonProxyHosts>www.google.com|*.example.com</nonProxyHosts>
        </proxy>
      </proxies>
      .
      .
    </settings>
```

请注意，目前不支持 NTLM 代理，因为它们尚未经过测试。您可以使用 JDK 1.4+ 上的相关系统属性来完成这项工作。

### 资源

1. [设置描述符文档](https://maven.apache.org/maven-settings/settings.html)
2. [配置 Maven](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/Guides/guide-configuring-maven.md)


