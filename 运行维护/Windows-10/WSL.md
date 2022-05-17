# WSL

> https://docs.microsoft.com/zh-cn/windows/wsl/

适用于 Linux 的 Windows 子系统 (WSL) 是 Windows 操作系统的一项功能，通过它可以直接在 Windows 上运行 Linux 文件系统以及 Linux 命令行工具和 GUI 应用，并可以运行传统的 Windows 桌面和应用。

## 管理工具 LxRunOffline

> https://github.com/DDoSolitary/LxRunOffline

一个用于管理 WSL 的全功能实用程序。

比如，把发行版`Ubuntu`移动到新目录`F:\WSL\Ubuntu`：

``` powershell
lxrunoffline.exe move -n Ubuntu -d F:\WSL\Ubuntu
```

并验证：

``` powershell
lxrunoffline.exe di -n Ubuntu
```

> wsl2 默认将发行版安装在`%USERPROFILE%\AppData\Local\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc`
