# Scoop

> https://github.com/ScoopInstaller/Scoop

Scoop 是 Windows 的命令行安装程序。

## Scoop 是做什么的？

Scoop 以最小的摩擦从命令行安装程序。它：

- 消除权限弹出窗口
- 隐藏 GUI 向导式安装程序
- 防止安装大量程序造成 PATH 污染
- 避免安装和卸载程序的意外副作用
- 自动查找并安装依赖项
- 自行执行所有额外的设置步骤以获得工作程序

## 安装

```shell
# 自定义安装目录
$env:SCOOP='D:\\Scoop'
# 自定义全局程序安装目录
$env:SCOOP_GLOBAL='F:\\GlobalScoopApps'
# 安装
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# or shorter
iwr -useb get.scoop.sh | iex
```

> 如果报错：`未能解析此远程名称: 'raw.githubusercontent.com'`，原因是DNS解析被污染了。
> 
> 在 https://www.ipaddress.com/ 中查一下，到 `C:\Windows\System32\drivers\etc\HOSTS` 文件中添加一条记录即可。
> 
> 比如 `185.199.109.133 raw.githubusercontent.com`

## 卸载

```shel
scoop uninstall scoop
```
