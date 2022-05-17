# git remote

> https://git-scm.com/docs/git-remote

## 名字

git-remote - 管理被跟踪的存储库集

## 概要

```
git remote [-v | --verbose]
git remote add [-t <branch>] [-m <master>] [-f] [--[no-]tags] [--mirror=(fetch|push)] <name> <URL>
git remote rename <old> <new>
git remote remove <name>
git remote set-head <name> (-a | --auto | -d | --delete | <branch>)
git remote set-branches [--add] <name> <branch>…
git remote get-url [--push] [--all] <name>
git remote set-url [--push] <name> <newurl> [<oldurl>]
git remote set-url --add [--push] <name> <newurl>
git remote set-url --delete [--push] <name> <URL>
git remote [-v | --verbose] show [-n] <name>…
git remote prune [-n | --dry-run] <name>…
git remote [-v | --verbose] update [-p | --prune] [(<group> | <remote>)…]
```



## 描述

管理您跟踪其分支的存储库集（“远程”）。

## 选项

**`-v`**

**`--verbose`**

稍微详细一点，并在名称后显示远程 url。注意：这个选项必须放在`remote`和子命令之间。



## 命令

不带参数，显示现有的 remotes 的列表。有几个子命令可用于在 remotes 上执行操作。

### `add`

