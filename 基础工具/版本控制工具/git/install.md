# 安装 Git

## Windows 系统

### 下载

建议从 [git 官网](https://git-scm.com/)下载最新版本。当前最新版本：**2.37.2**  

> 不建议从 [360 软管家](https://soft.360.cn/) 这类托管平台下载，因为它们不般不是最新版本。

### 安装

双击 Git 安装文件，开始安装。

#### 阅读安装信息

![install-git-windows-information](images\install-git-windows-information.png)

继续后面的安装之前，请先阅读下面的重要信息。当准备好继续设置时，单击 `Next`。

#### 选择目标位置

![install-git-windows-location](images\install-git-windows-location.png)

> 默认目标位置： `C:\Program Files\Git`

Git 应该安装在哪里？

安装程序将把 Git 安装到以下文件夹中。

若要继续，请单击 `Next`，如果要选择不同的文件夹，请单击 `Browse`。

至少需要 266.5 MB 的空闲磁盘空间。

#### 选择组件

![install-git-windows-components](images\install-git-windows-components.png)

应该安装哪些组件？

选择要安装的组件；清除不想安装的组件。当您准备好继续时，单击 `Next`。

- [ ] 额外图标
  - [ ] 桌面图标
- [x] Windows 资源管理器集成
  - [x] Git Bash here
  - [x] Git GUI here
- [x] Git LFS（大文件支持）
- [x] 将 `.git*` 配置文件与默认编辑器关联
- [x] 将要运行的 `.sh` 文件与 Bash 关联
- [ ] 每天检查 Windows 版 Git 更新
- [ ] （新！）将 Git Bash 配置文件添加到 Windows 终端



https://www.nano-editor.org/dist/v2.8/nano.html

#### 选择开始菜单文件夹

![install-git-windows-start-menu](images\install-git-windows-start-menu.png)

安装程序应该在哪里放置程序的快捷方式？

安装程序将在以下开始菜单文件夹中创建程序的快捷方式。

要继续，请单击 `Next1。 如果您想选择不同的文件夹，请单击 `Browse`。

#### 选择 Git 使用的默认编辑器

你希望 Git 使用哪个编辑器？

##### Vim

![install-git-windows-default-editor](images\install-git-windows-default-editor-vim.png)

使用 `Vim`，无处不在的文本编辑器，作为 Git 的默认编辑器。

[Vim 编辑器](https://www.vim.org/)虽然功能强大，但[可能很难使用](https://stackoverflow.blog/2017/05/23/stack-overflow-helping-one-million-developers-exit-vim/)。 它的用户界面不直观，按键绑定也很尴尬。

注意：Vim 是 Windows 版 Git 的默认编辑器，仅出于历史原因，强烈建议改用现代 GUI 编辑器。

注意：这将使 `core.editor` 选项未设置。而未设置 `core.editor` 选项将使 Git 回退到 `EDITOR` 环境变量。 默认编辑器是 Vim，但您可以将其设置为您选择的其他编辑器

##### Nano

> https://www.nano-editor.org/dist/v2.8/nano.html

![install-git-windows-default-editor-Nano](images\install-git-windows-default-editor-Nano.png)

##### Notepad++

> https://notepad-plus-plus.org

![install-git-windows-default-editor-Notepad-plus-plus](images\install-git-windows-default-editor-Notepad-plus-plus.png)

##### Visual Studio Code

> https://code.visualstudio.com//

![install-git-windows-default-editor-Visual-Studio-Code](images\install-git-windows-default-editor-Visual-Studio-Code.png)

##### Sublime Text

> https://www.sublimetext.com

![install-git-windows-default-editor-Sublime-text](images\install-git-windows-default-editor-Sublime-text.png)

##### Atom

> https://atom.io

![install-git-windows-default-editor-Atom](images\install-git-windows-default-editor-Atom.png)

##### VSCodium

> https://vscodium.com/

![install-git-windows-default-editor-VSCodium](images\install-git-windows-default-editor-VSCodium.png)

##### Notepad

![install-git-windows-default-editor-NotePad](images\install-git-windows-default-editor-NotePad.png)

##### Wordpad

![install-git-windows-default-editor-Wordpad](images\install-git-windows-default-editor-Wordpad.png)

##### 其它编辑器

![install-git-windows-default-editor-other-editor](images\install-git-windows-default-editor-other-editor.png)



#### 调整初始分支名

![install-git-windows-initial-branch-name](images\install-git-windows-initial-branch-name.png)

调整新存储库中初始分支的名称。

您希望 Git 在 `git init` 之后将初始分支命名为什么？

##### 让 Git 决定 

让 Git 使用其默认分支名称（当前：`master`）作为新创建的存储库中的初始分支。 Git 项目[打算](https://sfconservancy.org/news/2020/jun/23/gitbranchname/)在不久的将来将此默认更改为更具包容性的名称。

##### 覆盖新存储库的默认分支名称

新！许多团队已经重命名了他们的默认分支； 常见的选择是 `main`、`trunk` 和 `development`。 指定 `git init` 应用于初始分支的名称：`main`。

此设置不会影响现有存储库。

#### 调整你的 PATH 环境

![install-git-windows-path-environment](images\install-git-windows-path-environment.png)

##### 仅从 Git Bash 中使用  Git 

这是最谨慎的选择，因为您的 `PATH` 根本不会被修改。 您将只能使用 Git Bash 中的 Git 命令行工具。

##### 从命令行和第三方软件使用 Git 

（推荐）此选项仅将一些最小的 Git 包装器添加到您的 `PATH` 中，以避免使用可选的 Unix 工具干扰您的环境。 您将能够从 Git Bash、命令提示符和 Windows PowerShell 以及任何在 `PATH` 中寻找 Git 的第三方软件使用 Git

##### 从命令提示符使用 Git 和可选的 Unix 工具

Git 和可选的 Unix 工具都将添加到您的 `PATH` 中。 

警告：这将覆盖 Windows 工具，如 `find` 和 `sort`。 仅当您了解其含义时才使用此选项。

#### 选择 SSH 可执行文件

![install-git-windows-ssh-executable](images\install-git-windows-ssh-executable.png)

你希望 Git 使用哪个 Secure Shell 客户端程序？

##### 使用捆绑的 OpenSSH 

这个使用 Git 自带的 `ssh.exe` 。

##### 使用外部 OpenSSH 

新！ 这里使用外部 `ssh.exe`。 Git 不会安装自己的 OpenSSH（和相关）二进制文件，而是使用在 `PATH` 上找到的。

#### 选择 HTTPS 传输后端

![install-git-windows-https-transport-backend](images\install-git-windows-https-transport-backend.png)

#### 配置行尾转换

![install-git-windows-line-ending-conversions](images\install-git-windows-line-ending-conversions.png)



#### 配置终端模拟器

![install-git-windows-terminal-emulator](images\install-git-windows-terminal-emulator.png)

配置终端模拟器以与 Git Bash 一起使用

#### 选择 `git pull` 的默认行为

![install-git-windows-git-pull-default-behavior](images\install-git-windows-git-pull-default-behavior.png)



#### 选择凭据助手

> https://github.com/GitCredentialManager/git-credential-manager
>
> https://github.com/GitCredentialManager/git-credential-manager/blob/HEAD/docs/faq.md#about-the-project

![install-git-windows-credential-manager](images\install-git-windows-credential-manager.png)



#### 配置额外选项

> https://github.com/git-for-windows/git/wiki/Symbolic-Links

![install-git-windows-extra-options](images\install-git-windows-extra-options.png)



#### 配置实验选项

> https://github.com/git-for-windows/git/discussions/3251

![install-git-windows-experimental-options](images\install-git-windows-experimental-options.png)

#### 安装中

![install-git-windows-installing](images\install-git-windows-installing.png)

#### 完成 Git 设置向导

![install-git-windows-completing](images\install-git-windows-completing.png)







