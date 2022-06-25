# git add

> file:///D:/dev-tools/Git/mingw64/share/doc/git-doc/git-add.html

## 名称

`git-add`：将文件内容添加到索引

## 概要

```
git add [--verbose | -v] [--dry-run | -n] [--force | -f] [--interactive | -i] [--patch | -p]
          [--edit | -e] [--[no-]all | --[no-]ignore-removal | [--update | -u]] [--sparse]
          [--intent-to-add | -N] [--refresh] [--ignore-errors] [--ignore-missing] [--renormalize]
          [--chmod=(+|-)x] [--pathspec-from-file=<file> [--pathspec-file-nul]]
          [--] [<pathspec>…]
```

## 描述

此命令使用工作树中的当前内容更新索引，为下一次提交准备暂存的内容。它通常将现有路径的当前内容作为一个整体添加，但通过一些选项，它也可用于添加仅应用对工作树文件所做的部分更改的内容，或删除工作树中不存在的路径了。

**“索引”保存了工作树内容的快照**，正是这个快照被作为下一次提交的内容。因此，在对工作树进行任何更改之后，在运行 `commit` 命令之前，您必须使用 `add` 命令将任何新的或修改的文件添加到索引中。

在**提交之前可以多次执行**此命令。它仅在运行 `add` 命令时添加指定文件的内容；如果您希望在下一次提交中包含后续更改，则必须再次运行 `git add` 以将新内容添加到索引中。

`git status` 命令可用于获取哪些文件具有已为下一次提交暂存的更改的摘要。

`git add` 命令默认不会添加**被忽略的文件**。如果在命令行上明确指定了任何被忽略的文件，则 `git add` 将失败并显示被忽略文件的列表。目录递归或由 Git 执行的文件名通配（在 shell 之前引用你的 globs）到达的忽略文件将被静默忽略。`git add` 命令可用于添加带有 `-f` (force) 选项的忽略文件。

请参阅 [git-commit(1)](git-commit.html) 了解将内容添加到提交的替代方法。

## 选项

### `<pathspec>…`

可以给出从 `.` Fileglobs，比如 `*.c`，中添加内容的文件来添加所有匹配的文件。还可以给出一个前导目录名称（例如 `dir` 添加 `dir/file1` 和 `dir/file2`）来更新索引以匹配整个目录的当前状态（例如，指定`dir`将不仅记录工作树中修改的 `dir/file1`  文件，添加到工作目录中的 `dir/file2` 文件，但也记录从工作树中删除的 `dir/file3` 文件）。请注意，旧版本的 Git 过去常常忽略已删除的文件；如果要添加已修改的或新的文件但忽略已删除的文件，请使用 `--no-all` 选项。

有关 `<pathspec>` 语法的更多详细信息，请参阅 [gitglossary(7)](gitglossary.html) 中的*`pathspec`*条目。

### `-n` `--dry-run`

不会实际添加文件，只显示它们是否存在和/或将被忽略。

### `-v` `--verbose`

详细一点。

### `-f` `--force`

允许添加其他被忽略的文件。

### `--sparse`

允许更新稀疏检出锥之外的索引条目。通常，`git add`拒绝更新其路径不适合稀疏检出锥的索引条目，因为这些文件可能会在没有警告的情况下从工作树中删除。有关详细信息，请参阅 [git-sparse-checkout(1)](git-sparse-checkout.html)。

### `-i` `--interactive`

以交互方式将工作树中的修改内容添加到索引中。可以提供可选的路径参数来限制对工作树子集的操作。有关详细信息，请参阅“交互模式”。

### `-p` `--patch`

在索引和工作树之间以交互方式选择补丁块并将它们添加到索引中。这使用户有机会在将修改的内容添加到索引之前查看差异。

这有效地运行`add --interactive`，但绕过初始命令菜单并直接跳转到`patch`子命令。有关详细信息，请参阅“交互模式”。

### `-e` `--edit`

在编辑器中打开差异与索引并让用户编辑它。关闭编辑器后，调整大块标题并将补丁应用于索引。

此选项的目的是挑选和选择要应用的补丁行，甚至修改要暂存的行的内容。这比使用交互式大块选择器更快、更灵活。但是，很容易混淆自己，创建一个不适用于索引的补丁。请参阅下面的编辑补丁。

### `-u` `--update`

在索引已经有一个匹配 <pathspec> 的地方更新索引。这会删除并修改索引条目以匹配工作树，但不会添加新文件。

如果在`-u`使用选项时没有给出 <pathspec>，则整个工作树中的所有跟踪文件都会更新（旧版本的 Git 用于限制对当前目录及其子目录的更新）。

### `-A` `--all` `--no-ignore-removal`

不仅在工作树有一个匹配 <pathspec> 的文件的地方更新索引，而且在索引已经有一个条目的地方更新索引。这将添加、修改和删除索引条目以匹配工作树。

如果`-A`使用选项时没有给出 <pathspec>，则整个工作树中的所有文件都会更新（旧版本的 Git 用于将更新限制为当前目录及其子目录）。

### `--no-all` `--ignore-removal`

通过添加索引未知的新文件和工作树中修改的文件来更新索引，但忽略已从工作树中删除的文件。当不使用 <pathspec> 时，此选项是无操作的。

这个选项主要是为了帮助习惯了旧版本 Git 的用户，他们的“git add <pathspec>...”是“git add --no-all <pathspec>...”的同义词，即忽略删除的文件。

### `-N` `--intent-to-add`

仅记录稍后将添加路径的事实。路径的条目被放置在没有内容的索引中。除其他外，这对于显示此类文件的未暂存内容`git diff`并使用`git commit -a`.

### `--refresh`

不要添加文件，而只在索引中刷新它们的 stat() 信息。

### `--ignore-errors`

如果某些文件由于索引错误而无法添加，请不要中止操作，而是继续添加其他文件。该命令仍应以非零状态退出。可以将配置变量`add.ignoreErrors`设置为 true 以使其成为默认行为。

### `--ignore-missing`

此选项只能与 --dry-run 一起使用。通过使用此选项，用户可以检查是否有任何给定文件将被忽略，无论它们是否已经存在于工作树中。

### `--no-warn-embedded-repo`

默认情况下，`git add`将嵌入式存储库添加到索引而不使用`git submodule add`在`.gitmodules`. 此选项将抑制警告（例如，如果您手动对子模块执行操作）。

### `--renormalize`

对所有跟踪的文件重新应用“清理”过程，以强制将它们再次添加到索引中。`core.autocrlf`这在更改配置或属性后很有用`text`，以便更正添加了错误 CRLF/LF 行结尾的文件。该选项暗示`-u`.

### `--chmod=(+|-)x`

覆盖添加文件的可执行位。可执行位仅在索引中更改，磁盘上的文件保持不变。

### `--pathspec-from-file=<file>`

传入 Pathspec`<file>`而不是命令行参数。如果 `<file>`恰好是，`-`则使用标准输入。Pathspec 元素由 LF 或 CR/LF 分隔。Pathspec 元素可以按照配置变量的说明引用`core.quotePath` （参见[git-config(1)](git-config.html)）。另请参阅`--pathspec-file-nul`和全局`--literal-pathspecs`。

### `--pathspec-file-nul`

只对 有意义`--pathspec-from-file`。Pathspec 元素用 NUL 字符分隔，所有其他字符都按字面意思表示（包括换行符和引号）。

### `--`

此选项可用于将命令行选项与文件列表分开（当文件名可能被误认为命令行选项时很有用）。

## 示例

* 添加 `Documentation` 目录及其子目录下所有 `*.txt` 文件的内容：

  ``` powershell
  git add Documentation/\*.txt
  ```

  请注意，在此示例中，星号 `*` 是从 shell 引用的；这让命令包含 `Documentation/` 目录的子目录中的文件。

* 考虑从所有 `git-*.sh` 脚本中添加内容：

  ``` powershell
  git add git-*.sh
  ```

  因为这个例子让 shell 扩展星号（即你明确列出文件），所以它不考虑 `subdir/git-foo.sh`。

## 交互模式

### status

### update

### revert

### add untracked

### patch



### diff

## 编辑补丁



## 也可以看看

[git-status(1) ](git-status.html)

[git-rm(1) ](git-rm.html)

[git-reset(1) ](git-reset.html)

[git-mv(1) ](git-mv.html)

[git-commit(1) ](git-commit.html)

[git-update-index(1)](git-update-index.html)

## GIT

[git(1)](git.html)套件的一部分