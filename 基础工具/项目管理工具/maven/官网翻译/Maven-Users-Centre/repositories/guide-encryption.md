## 密码加密

> https://maven.apache.org/guides/mini/guide-encryption.html

### 介绍

Maven 支持服务器密码加密。此解决方案解决的主要用例是：

- 多个用户共享同一台构建机器（服务器、CI box）
- 有些用户有权将 Maven 工件部署到存储库，有些则没有。
  - 这适用于任何需要授权的服务器操作，而不仅仅是部署
- `settings.xml` 在用户之间共享

实施的解决方案增加了以下功能：

- 授权用户的 `${user.home}/.m2` 文件夹中有一个附加 `settings-security.xml` 文件
  - 此文件包含加密的**主密码**，用于加密其他密码
  - 或者它可以包含**重定位**- 对另一个文件的引用，可能在可移动存储上
  - 现在首先通过 CLI 创建此密码
- `settings.xml` 中的服务器条目具有加密的密码和/或密钥库密码
  - 现在 - 这是在创建主密码并将其存储在适当位置**后**通过 CLI 完成的

### 如何创建主密码

使用以下命令行：

```powershell
mvn --encrypt-master-password <password>
```

> 注意：自 Maven 3.2.1 起，不应再使用密码参数（有关更多信息，请参阅下面的[提示](https://maven.apache.org/guides/mini/guide-encryption.html#Tips)）。Maven 将提示输入密码。早期版本的 Maven 不会提示输入密码，因此必须在命令行中以纯文本形式输入。

此命令将生成密码的加密版本，例如

```
{jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+9EF1iFQyJQ=}
```

将此密码存储在 `${user.home}/.m2/settings-security.xml`; 它应该看起来像

```xml
<settingsSecurity>
  <master>{jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+9EF1iFQyJQ=}</master>
</settingsSecurity>
```

完成后，您可以开始加密现有的服务器密码。

### 如何加密服务器密码

您必须使用以下命令行：

```powershell
    mvn --encrypt-password <password>
```

> 注意：就像`--encrypt-master-password`一样，从 Maven 3.2.1 起不再使用密码参数。有关更多信息，请参阅下面的[提示](https://maven.apache.org/guides/mini/guide-encryption.html#Tips)。

此命令生成它的加密版本，例如

``` 
{COQLCE6DU6GtcS5P=}
```

将其复制并粘贴到 `settings.xml` 文件的服务器部分。这看起来像：

```xml
    <settings>
    ...
      <servers>
    ...
        <server>
          <id>my.server</id>
          <username>foo</username>
          <password>{COQLCE6DU6GtcS5P=}</password>
        </server>
    ...
      </servers>
    ...
    </settings>
```

请注意，密码可以包含大括号之外的任何信息，因此以下内容仍然有效：

```xml
    <settings>
    ...
      <servers>
    ...
        <server>
          <id>my.server</id>
          <username>foo</username>
          <password>Oleg reset this password on 2009-03-11, expires on 2009-04-11 {COQLCE6DU6GtcS5P=}</password>
        </server>
    ...
      </servers>
    ...
    </settings>
```

然后你可以使用，比如说，部署插件，写入这个服务器：

```powershell
    mvn deploy:deploy-file -Durl=https://maven.corp.com/repo \
                           -DrepositoryId=my.server \
                           -Dfile=your-artifact-1.0.jar \
```

### 如何在可移动驱动器上保留主密码

完全按照上述方法创建主密码，并将其存储在可移动驱动器上，例如在 OSX 上，我的 USB 驱动器安装为 `/Volumes/mySecureUsb`，所以我存储

```xml
    <settingsSecurity>
      <master>{jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+9EF1iFQyJQ=}</master>
    </settingsSecurity>
```

在文件 `/Volumes/mySecureUsb/secure/settings-security.xml` 中。

然后我使用以下内容创建 `${user.home}/.m2/settings-security.xml`：

```xml
    <settingsSecurity>
      <relocation>/Volumes/mySecureUsb/secure/settings-security.xml</relocation>
    </settingsSecurity>
```

这可确保加密仅在操作系统安装 USB 驱动器时才有效。这解决了只有某些人被授权部署和获得这些设备的用例。

### 提示

#### 转义密码中的花括号文字

> Maven 2.2.0

有时，您可能会发现您的密码（或其加密形式）包含 `{` 或 `}` 作为文字值。如果您将这样的密码原样添加到您的 `settings.xml` 文件中，您会发现 Maven 用它做了一些奇怪的事情。具体来说，Maven 将 `{` 文字之前的所有字符和 `}` 文字之后的所有字符视为注释。显然，这不是您想要的行为。您真正需要的是一种**转义**密码中大括号文字的方法。

您可以使用广泛使用的 `\` 转义字符来做到这一点。如果您的密码如下所示：

``` 
jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+{EF1iFQyJQ=
```

然后，您将添加到 `settings.xml` 的值如下所示：

```xml
{jSMOWnoPFgsHVpMvz5VrIt5kRbzGpI8u+\{EF1iFQyJQ=}
```

#### 密码安全

编辑 `settings.xml` 和运行上述命令仍然可以将您的密码以明文形式存储在本地。您可能需要检查以下位置：

- Shell 历史记录（例如通过运行 `history`）。您可能希望在加密上述密码后清除您的历史记录
- 编辑器缓存（例如 `~/.viminfo`）

另请注意，加密密码可以由拥有主密码和设置安全文件的人解密。如果您预计`settings.xml` 文件可能会被检索，请确保此文件安全（或单独存储）。

#### 不同平台上的密码转义

在某些平台上，如果密码包含特殊字符，如 `%`、`!`、`$` 等，则可能需要引用密码。例如，在 Windows 上，您必须小心以下内容：

以下示例不适用于 Windows：

```powershell
    mvn --encrypt-master-password a!$%^b
```

而以下将在 Windows 上运行：

```powershell
    mvn --encrypt-master-password "a!$%^b"
```

如果您在 linux/unix 平台上，您应该使用单引号作为上述主密码。否则主密码将不起作用（由美元符号和感叹号引起）。

#### 提示输入密码

在 3.2.1 版之前的 Maven 中，您必须在命令行中提供密码作为参数，这意味着您可能需要转义密码。此外，shell 通常会存储您输入的命令的完整历史记录，因此任何可以访问您计算机的人都可以从 shell 的历史记录中恢复密码。

从 Maven 3.2.1 开始，密码是一个可选参数。如果您省略密码，系统会提示您输入密码，从而防止上述所有问题。

我们强烈建议使用 Maven 3.2.1 及更高版本来防止转义特殊字符的问题，当然还有与 bash 历史相关的安全问题或与密码相关的环境问题。
