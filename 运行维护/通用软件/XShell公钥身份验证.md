# Xshell 公钥用户身份验证

> 打开 Xshell ，单击 **帮助** 下拉菜单中的 **Xshell帮助** 选项，就能看到 **Xshell 6 Help** 面板。

## 创建用户密钥

要创建用户密钥，请执行以下操作：

1.从[Tools]菜单中选择[New User Key Wizard]。

2.根据**新建用户密钥向导**给出的说明创建用户密钥。

## 在服务器中注册公钥

要在服务器中注册公钥，请执行以下操作：

1.从[Tools]菜单中选择[User Key Manager]，打开**用户密钥**对话框。

2.选择要注册的用户密钥。

3.单击[Properties]。将显示**用户密钥属性**对话框。

4.单击[公钥]选项卡。

5.从[Public Key Format]列表中选择适当的类型。

6.单击[Save as a file]保存或复制密钥内容，并按照上述公钥注册方法将密钥注册到服务器。

> 在密钥创建的最后阶段在服务器上注册公钥。注册方法因服务器类型而异。
>
> * *SSH1*:  复制公钥文本内容，并将其保存到 `$HOME/.SSH/authorized_keys` 文件。执行下面的命令来关闭文件和目录的写权限。
>
> ``` bash
> $ cd
> $ chmod go-w . .ssh  .ssh/authorized_keys
> ```
>
> * *SSH2-OpenSSH*:  OpenSSH servers use this format. 复制公钥文本内容，并将其保存到`$HOME/.ssh/authorized_keys2` 文件。执行下面的命令来关闭文件和目录的写权限。
>
>   ``` bash
>   $ cd
>   $ chmod go-w . .ssh  .ssh/authorized_keys2
>   ```
>
> * *SSH2-IETF  SECSH*:  Certain commercial SSH servers, such as ssh.com server, use this format. Save a  public key under an intrinsic name, such as `mypublickey.pub` and copy it to  `$HOME/.ssh2` directory. Add the following line to `$HOME/.ssh2/authorization`  file:
>      `Key mypublickey.pub`
>     Execute  the following command to turn off the write permission of the files and  directories. 
>
>     ``` bash
>     $ cd
>     $ chmod go-w . .ssh2
>     $ chmod go-w  .ssh2/authorization .ssh2/mypublickey.pub
>     ```
>
> 

## 更改用户密钥密码短语

要更改用户密钥密码短语，请执行以下操作：

1.打开**用户密钥**对话框。

2.选择要更改其密码短语的用户密钥。

3.单击[Properties]。将显示**用户密钥属性**对话框。

4.单击[General]选项卡。

5.单击[Change Passphrase]。