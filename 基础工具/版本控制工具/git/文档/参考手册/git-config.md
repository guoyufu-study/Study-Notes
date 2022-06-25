# git config

> https://git-scm.com/docs/git-config

## 名称

git-config：获取和设置存储库或全局选项

## 概要

``` powershell
git config [<file-option>] [--type=<type>] [--fixed-value] [--show-origin] [--show-scope] [-z|--null] <name> [<value> [<value-pattern>]]
# 添加新行
git config [<file-option>] [--type=<type>] --add <name> <value>
# 替换匹配的所有行
git config [<file-option>] [--type=<type>] [--fixed-value] --replace-all <name> <value> [<value-pattern>]
# 获取匹配的最后一个值
git config [<file-option>] [--type=<type>] [--show-origin] [--show-scope] [-z|--null] [--fixed-value] --get <name> [<value-pattern>]
# 获取匹配的所有值
git config [<file-option>] [--type=<type>] [--show-origin] [--show-scope] [-z|--null] [--fixed-value] --get-all <name> [<value-pattern>]
git config [<file-option>] [--type=<type>] [--show-origin] [--show-scope] [-z|--null] [--fixed-value] [--name-only] --get-regexp <name-regex> [<value-pattern>]
git config [<file-option>] [--type=<type>] [-z|--null] --get-urlmatch <name> <URL>
# 删除匹配的行
git config [<file-option>] [--fixed-value] --unset <name> [<value-pattern>]
# 删除匹配的所有行
git config [<file-option>] [--fixed-value] --unset-all <name> [<value-pattern>]
# 重命名部分
git config [<file-option>] --rename-section <old-name> <new-name>
# 移除部分
git config [<file-option>] --remove-section <name>
# 列出所有行
git config [<file-option>] [--show-origin] [--show-scope] [-z|--null] [--name-only] -l | --list
git config [<file-option>] --get-color <name> [<default>]
git config [<file-option>] --get-colorbool <name> [<stdout-is-tty>]
git config [<file-option>] -e | --edit
```

## 描述

您可以使用此命令查询/设置/替换/复原选项。名称实际上是由点分隔的段和键，值将被转义。

使用 `--add` 选项可以将多行**添加**到一个选项中。如果要**更新或复原**可能出现在多行上的一个选项，则需要给出一个 `value-pattern`（这是一个扩展的正则表达式，除非给出 `--fixed-value` 选项）。只有与模式匹配的现有值才会被更新或复原。如果要处理与模式**不**匹配的行，只需在前面添加一个感叹号（另请参见[示例](https://git-scm.com/docs/git-config#EXAMPLES)），但请注意，这仅在不使用 `--fixed-value` 选项时有效。

`--type=<type>` 选项指示 `git config` 确保传入和传出值在给定 `<type>` 下是可规范化的。如果没有 `--type=<type>` 给出，则不会执行规范化。调用者可以使用 `--no-type` 复原现有的 `--type` 说明符。

**读取**时， 默认情况下从系统、全局和存储库本地配置文件中读取值，选项 `--system`、`--global`、`--local`、`--worktree` 和 `--file <filename>` 可用于告诉命令仅从该指定位置读取（请参阅[FILES](https://git-scm.com/docs/git-config#FILES)）。

**写入**时，默认将新值写入存储库本地配置文件，而选项 `--system`, `--global`, `--worktree`,`--file <filename>` 可用于告诉命令写入该指定位置（您可以用 `--local`，但这是默认值）。

此命令将在**出错**时以非零状态失败。一些退出代码是：

- 段或键无效（`ret=1`），
- 没有提供段或名称（`ret=2`），
- 配置文件无效（`ret=3`），
- 无法写入配置文件（`ret=4`），
- 您尝试复原不存在的选项（`ret=5`），
- 您尝试复原/设置多行匹配的选项（`ret = 5`），或
- 您尝试使用无效的正则表达式 (`ret=6`)。

**成功**时，该命令返回退出代码 `0`。

可以使用 `git help --config` 命令获取所有可用配置变量的列表。

## 选项

### `--replace-all`

默认行为是最多替换一行。这将替换与键（以及可选的`value-pattern`）匹配的所有行。

### `--add`

在不更改任何现有值的情况下向选项添加新行。这与在 `--replace-all` 中提供*`^$`*作为`value-pattern` 相同。

### `--get`

获取给定键的值（可选地由匹配该值的正则表达式过滤）。如果未找到键，则返回错误代码 1；如果找到多个键值，则返回最后一个值。

### `--get-all`

与 `get` 类似，但返回多值键的所有值。

### `--get-regexp`

### `--get-urlmatch <name> <URL>`



### `--global`

对于写入选项：写入全局 `~/.gitconfig` 文件而不是存储库 `.git/config`，如果 `$XDG_CONFIG_HOME/git/config` 文件存在而 `~/.gitconfig` 文件不存在，则写入 `$XDG_CONFIG_HOME/git/config` 文件。

对于读取选项：仅从全局 `~/.gitconfig` 和 `$XDG_CONFIG_HOME/git/config` 而不是从所有可用文件中读取。

另请参阅[文件](#FILES)。

### `--system`

对于写入选项：写入系统范围 `$(prefix)/etc/gitconfig` 而不是存储库 `.git/config`。

对于读取选项：仅从系统范围 `$(prefix)/etc/gitconfig` 内读取， 而不是从所有可用文件中读取。

另请参阅[文件](#FILES)。

### `--local`

对于写入选项：写入存储库 `.git/config` 文件。这是**默认行为**。

对于读取选项：仅从存储库 `.git/config` 中读取，而不是从所有可用文件中读取。

另请参阅[文件](#FILES)。

### `--work-tree`



### `-f <config-file>`

对于写入选项：写入指定文件而不是存储库 `.git/config`。

对于读取选项：仅从指定文件而不是从所有可用文件中读取。

另请参阅[文件](#FILES)。

### `--blob <blob>`



### `--remove-section`

从配置文件中删除给定的部分。

### `--rename-section`

将给定部分重命名为新名称。

### `--unset`

从配置文件中删除与键匹配的行。

### `--unset-all`

从配置文件中删除与键匹配的所有行。

### `-l` 和 `--list`

列出配置文件中设置的所有变量及其值。

### TODO

## 配置

`pager.config` 仅在列出配置时，即在使用 `--list` 或其中任何一个 `--get-*` 可能返回多个结果时，才受到尊重。默认是使用 pager。

## 文件

如果没有用 `--file` 明确设置，则 `git config` 将在四个文件中搜索配置选项：

- `$(prefix)/etc/gitconfig`

  系统范围的配置文件。

- `$XDG_CONFIG_HOME/git/config`

  第二个用户特定的配置文件。如果 `$XDG_CONFIG_HOME` 未设置或为空，`$HOME/.config/git/config` 将被使用。此文件中设置的任何单值变量都将被 `~/.gitconfig` 中的任何变量覆盖。如果你有时使用旧版本的 Git，最好不要创建这个文件，因为最近才添加了对这个文件的支持。

- `~/.gitconfig`

  用户特定的配置文件。也称为“全局”配置文件。

- `$GIT_DIR/config`

  存储库特定的配置文件。

- `$GIT_DIR/config.worktree`

  这是可选的，仅在 `$GIT_DIR/config` 中存在 `extensions.worktreeConfig` 时才被搜索 。

如果没有给出更多选项，所有读取选项都将读取所有这些可用的文件。如果全局或系统范围的配置文件不可用，它们将被忽略。如果存储库配置文件不可用或不可读，`git config` 将以非零错误代码退出。但是，在这两种情况下都不会发出错误消息。

文件按上面给出的**顺序读取**，最后找到的值优先于之前读取的值。当取多个值时，将使用所有文件中的键的所有值。

在运行任何 `git` 命令时，您可以**使用 `-c` 选项覆盖单个配置参数**。有关详细信息，请参阅[git(1)](git.html)。

默认情况下，所有写入选项都将写入存储库特定的配置文件。请注意，这也会影响 `--replace-all` 和 `--unset` 之类的选项。**`git config`一次只会更改一个文件**。

您可以使用 `--global`、`--system`、 `--local`、`--worktree` 和 `--file` 命令行选项覆盖这些规则；见上面的[选项](#OPTIONS)。

## 环境

## 示例

给定一个 `.git/config`：

``` 
#
# 这是配置文件，'#' 或 ';' 字符表明一个注释。
#

; core variables
[core]
	; Don't trust file modes
	filemode = false

; Our diff algorithm
[diff]
	external = /usr/local/bin/diff-wrapper
	renames = true

; Proxy settings
[core]
	gitproxy=proxy-command for kernel.org
	gitproxy=default-proxy ; for all the rest

; HTTP
[http]
	sslVerify
[http "https://weak.example.com"]
	sslVerify = false
	cookieFile = /tmp/cookie.txt
```

你可以将 `filemode` 设置为 `true`

```bash
git config core.filemode true
```

假设的代理命令条目实际上有一个后缀来辨别它们应用于哪个URL。下面是如何将 `kernel.org` 的条目更改为"ssh"。

```bash
git config core.gitproxy '"ssh" for kernel.org' 'for kernel.org$'
```

这将确保只有 `kernel.org` 的键/值对被替换。

要删除 `renames` 项，请执行

``` bash
git config --unset diff.renames
```

如果你想删除 multivar 的一个条目(像上面的 `core.gitproxy`)，你必须提供一个正好匹配一行值的正则表达式。

要查询给定键的值，执行

``` bash
git config --get core.filemode
```

或者

``` bash
git config core.filemode
```

或者，查询一个 multivar。

``` bash
git config --get core.gitproxy "for kernel.org$"
```

如果你想知道一个 multivar 的所有值，执行

``` bash
git config --get-all core.gitproxy
```

如果你喜欢危险的生活，你可以用下面的命令替换所有的 `core.gitproxy`

``` bash
git config --replace-all core.gitproxy ssh
```

然而，如果你真的只想替换默认代理的行，即没有后缀“for…”的那行，可以这样做：

``` bash
git config core.gitproxy ssh '! for '
```

要真正匹配带有感叹号的值，你必须这样做

``` bash
git config section.key value '[!]'
```

要添加新的代理，而不更改任何现有代理，请使用

``` bash
git config --add core.gitproxy '"proxy-command" for example.com'
```

一个使用脚本中配置的自定义颜色的示例：

``` bash
#!/bin/sh
WS=$(git config --get-color color.diff.whitespace "blue reverse")
RESET=$(git config --get-color "" "reset")
echo "${WS}your whitespace color or blue reverse${RESET}"
```

对于 `https://weak.example.com` 中的 URLs, `http.sslVerify` 设置为 `false`，而其他所有URLs都设置为 `true`：

``` bash
% git config --type=bool --get-urlmatch http.sslverify https://good.example.com
true
% git config --type=bool --get-urlmatch http.sslverify https://weak.example.com
false
% git config --get-urlmatch http https://weak.example.com
http.cookieFile /tmp/cookie.txt
http.sslverify false
```

## 配置文件

Git 配置文件包含许多影响 Git 命令行为的变量。每个存储库中的文件 `.git/config` 和可选的 `config.worktree`（请参阅 [git-worktree(1)](git-worktree.html) 的“配置文件”部分 ）用于存储该存储库的配置，`$HOME/.gitconfig` 用于将每个用户的配置存储为 `.git/config` 文件的后备值。`/etc/gitconfig` 文件可用于存储系统范围的默认配置。

Git 管道和瓷器(the Git plumbing and the porcelains)都使用配置变量。**变量被划分为段**，其中变量本身的完全限定变量名是最后一个以点分隔的段，段名是最后一个点之前的所有内容。**变量名**不区分大小写，只允许使用字母数字字符和 `-`，并且必须以字母字符开头。有些变量可能会出现多次；我们说这个变量是**多值的**。

### 语法

语法相当灵活和宽松；**空格**大多被忽略。*`#`* 和*`;`* 字符开始**注释**到行尾，**空白行**被忽略。

该文件由段和变量组成。一个**段**以方括号中的段名开始，一直持续到下一个段开始。**段名**不区分大小写。只允许在段名中使用字母数字字符，`-` 和 `.`。每个变量必须属于某个段，这意味着在第一次设置变量之前必须有**段标题**。

段可以进一步划分为**分段**。要开始一个分段，请将其名称放在双引号中，并在段标题中与段名用空格分隔，如下例所示：

```
[section "subsection"]
```

**分段名**区分大小写，可以包含除换行符和 null字节以外的任何字符。可以通过将双引号 `"` 和反斜杠分别转义为 `\"` 和 `\\` 来包含它们。读取时会删除其他字符前面的反斜杠；比如，`\t` 读作 `t` ，`\0`读作 `0`。段标题不能跨越多行。变量可以直接属于一个段或一个给定的分段。如果你有 `[section "subsection"]`，你可以有 `[section]`，但你不需要。

还有一个不推荐使用的 `[section.subsection]` 语法。使用此语法，分段名将转换为小写，并且区分大小写。这些分段名遵循与段名相同的限制。

所有其他行（以及段标题之后的行的其余部分）都被识别为设置变量，**形式**为 *`name = value`*（或只有*`name`*，这是表示变量为布尔值 `true` 的简写形式）。**变量名**不区分大小写，只允许使用字母数字字符和`-`，并且必须以字母字符开头。

定义**值**的行可以通过以 `\` 结束来继续到下一行。反斜杠和行尾被剥离。*`name =`*之后的前导空格，第一个注释字符*`#`*或*`;`*之后的行的其余部分 , 和行的尾随空格将被丢弃，除非它们用双引号引起来。值中的内部空格会逐字保留。

在双引号内，必须对双引号 `"` 和反斜杠 `\` 字符进行转义：使用 `\"` 转义 `"`，`\\`转义 `\`。

以下转义序列（除 `\"` 和 `\\` 之外）被识别： `\n`换行符 (NL)、`\t`水平制表 (HT、TAB) 和`\b`退格 (BS)。其他字符转义序列（包括八进制转义序列）无效。

### Includes

### Conditional includes

### 示例

``` 
# Core variables
[core]
	; Don't trust file modes
	filemode = false

# Our diff algorithm
[diff]
	external = /usr/local/bin/diff-wrapper
	renames = true

[branch "devel"]
	remote = origin
	merge = refs/heads/devel

# Proxy settings
[core]
	gitProxy="ssh" for "kernel.org"
	gitProxy=default-proxy ; for the rest

[include]
	path = /path/to/foo.inc ; include by absolute path
	path = foo.inc ; find "foo.inc" relative to the current file
	path = ~/foo.inc ; find "foo.inc" in your `$HOME` directory

; include if $GIT_DIR is /path/to/foo/.git
[includeIf "gitdir:/path/to/foo/.git"]
	path = /path/to/foo.inc

; include for all repositories inside /path/to/group
[includeIf "gitdir:/path/to/group/"]
	path = /path/to/foo.inc

; include for all repositories inside $HOME/to/group
[includeIf "gitdir:~/to/group/"]
	path = /path/to/foo.inc

; relative paths are always relative to the including
; file (if the condition is true); their location is not
; affected by the condition
[includeIf "gitdir:/path/to/group/"]
	path = foo.inc

; include only if we are in a worktree where foo-branch is
; currently checked out
[includeIf "onbranch:foo-branch"]
	path = foo.inc

; include only if a remote with the given URL exists (note
; that such a URL may be provided later in a file or in a
; file read after this file is read, as seen in this example)
[includeIf "hasconfig:remote.*.url:https://example.com/**"]
	path = foo.inc
[remote "origin"]
	url = https://example.com/git
```

### Values

许多变量的值被视为一个简单的字符串，但有些变量采用特定类型的值，并且有关于如何拼写它们的规则。

#### boolean

当一个变量被认为是一个 boolean 值时，许多同义词被接受为*`true`*和*`false`*；这些都是不区分大小写的。

##### true

布尔真字面量是 `yes`、`on`、`true` 和 `1`。此外，没有定义的变量 `= <value>` 被视为真。

##### false

布尔假字面量是 `no`、 `off`、`false`、 `0` 和空字符串。

使用 `--type=bool` 类型说明符将值转换为其规范形式时，*`git config`*将确保输出为 `true` 或 `false`（用小写字母拼写）。

#### integer

许多指定各种大小的变量的值可以用 `k`，`M`，... 后缀表示“将数字缩放 1024”、“缩放 1024x1024”等。

#### color

采用颜色的变量的值是颜色列表（最多两种，一种用于前景，一种用于背景）和属性（任意数量），以空格分隔。

接受的**基本颜色**是`normal`, `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`,`white`和`default`。给出的第一个颜色是前景；第二个是背景。除了 `normal` 和 `default` 之外的所有基本颜色都有一个明亮的变体，可以通过在颜色前面加上 `bright` 来指定，比如 `brightred`。

颜色 `normal` 不会改变颜色。它与空字符串相同，但可以在单独指定背景颜色时用作前景色（比如，`normal red`）。

颜色 `default` 明确地将颜色重置为终端默认值，比如指定清除背景。虽然它在终端之间有所不同，但这通常与设置为 `white black` 不同。

颜色也可以用 0 到 255 之间的**数字**给出；这些使用 ANSI 256 色模式（但请注意，并非所有终端都支持此模式）。如果您的终端支持它，您还可以将 24 位 RGB 值指定为十六进制，例如 `#ff0ab3`.

可接受的**属性**是`bold`, `dim`, `ul`, `blink`, `reverse`, `italic`, 和`strike`（用于划掉或“删除线”的字母）。任何属性相对于颜色的位置（之前、之后或中间）都无关紧要。可以通过在它们前面加上 `no` 或`no-`（比如`noreverse`、`no-ul` 等）来关闭特定属性。

伪属性 `reset` **在应用指定的颜色之前重置所有颜色和属性**。比如，`reset green` 将导致绿色前景和没有任何活动属性的默认背景。

**空的颜色字符串**根本不会产生颜色效果。这可用于避免为特定元素着色而不完全禁用颜色。

对于 git 的预定义颜色槽，属性意味着在彩色输出中每个项目的开头重置。因此，设置 `color.decorate.branch`为`black`将在 plain `black` 中绘制该分支名称，即使同一输出行上的前一个内容（例如输出中的分支名称列表之前的左括号`log --decorate` ）设置为使用 `bold` 或其他属性进行绘制。但是，自定义日志格式可能会进行更复杂和分层的着色，并且否定形式可能在那里有用。

#### pathname

可以给带有路径名值的变量一个以 `~/` 或 `~user/` 开头的字符串，并且通常的波浪号扩展发生在这样的字符串上：`~/` 扩展为 `$HOME` 的值，并扩展`~user/`为指定用户的主目录。

如果路径以 `%(prefix)/` 开头，则其余部分被解释为相对于 Git 的“运行时前缀”的路径，即相对于 Git 本身的安装位置。比如，`%(prefix)/bin/` 指的是 Git 可执行文件本身所在的目录。如果 Git 是在没有运行时前缀支持的情况下编译的，则将替换为已编译的前缀。万一需要指定不应扩展的文字路径*，*则需要以  `./` 为前缀，比如：`./%(prefix)/bin`。

### 变量

请注意，此列表不全面，也不一定完整。对于特定于命令的变量，您将在相应的手册页中找到更详细的说明。

其他与 git 相关的工具可能并且确实使用它们自己的变量。在为您自己的工具发明新变量时，请确保它们的名称与 Git 本身和其他流行工具使用的名称不冲突，并在您的文档中描述它们。

#### `core.pager`

#### `core.quotePath`

输出路径的命令（比如*`ls-files`*、*`diff`*）将**通过用双引号将路径名括起来并用反斜杠转义这些字符来引用路径名中的“不寻常”字符**，这与 C 转义控制字符（比如 `\t` 用于 TAB，`\n`用于LF，`\\`用于反斜杠）或值大于 `0x80` 的字节（比如`\302\265`，UTF-8 中“micro”的八进制）的方式相同。如果此变量设置为 `false`，则高于 `0x80` 的字节不再被视为“不寻常”。无论此变量的设置如何，双引号、反斜杠和控制字符总是被转义。一个简单的空格字符不被认为是“不寻常的”。许多命令可以使用 `-z` 选项完全逐字输出路径名。默认值是 `true`。

#### safe.directory 

> https://git-scm.com/docs/git-config#Documentation/git-config.txt-safedirectory

这些配置条目指定 Git 跟踪目录，即使这些目录的所有者不是当前用户，它们也被认为是安全的。

默认情况下，Git 甚至会拒绝解析他人拥有的存储库的 Git 配置，更不用说运行它的钩子了，并且这个配置设置允许用户指定异常，例如对于有意共享的存储库(参见 [Git -init[1]](https://git-scm.com/docs/git-init) 中的 `--shared` 选项)。

这是一个多值设置，比如，你可以通过 `git config -add` 添加多个目录。要重置安全目录列表（比如，覆盖系统配置中指定的任何这样的目录)，添加一个空值的 `safe.directory` 条目。

只有在系统或全局配置中指定时，才会尊重此配置设置，而不是在存储库配置中或通过命令行选项 `-c safe.directory=<path>` 指定时。

此设置的值是内插的，即 `~/<path>` 扩展到相对于主目录的路径，`%(prefix)/<path>` 扩展到相对于Git（运行时）前缀的路径。

要完全选择退出此安全检查，请将 `safe.directory` 设置为字符串 `*`。这将允许将所有存储库视为它们的目录列在 `safe.directory` 列表中。如果在系统配置中设置了 `safe.directory=*`，并且您希望重新启用这个保护，那么在列出您认为安全的存储库之前，用一个空值初始化您的列表。

#### TODO



#### `user.name`

#### `user.email`

#### `author.name`

#### `author.email`

#### `committer.name`

#### `committer.email`

`user.name` 和 `user.email`变量决定了提交对象的 `author` 和 `committer` 字段中的内容。如果您需要 `author` 或 `committer` 不同， 可以设置 `author.name`、`author.email`、`committer.name` 或 `committer.email` 变量。此外，所有这些都可以被 `GIT_AUTHOR_NAME`、 `GIT_AUTHOR_EMAIL`、`GIT_COMMITTER_NAME`、`GIT_COMMITTER_EMAIL` 和  `EMAIL` 环境变量覆盖。

请注意，这些变量的 `name` 形式通常指的是某种形式的个人姓名。有关这些设置和选项的更多信息，请参阅 [git-commit(1)](git-commit.html) 和 [git(1)](git.html) 的环境变量部分，如果您正在寻找身份验证凭据，请参阅 `credential.username`。

#### `user.useConfigOnly`

指示 Git 避免尝试猜测 `user.email` 和 `user.name` 的默认值，而是仅从配置中检索值。例如，如果您有多个电子邮件地址并且想为每个存储库使用不同的电子邮件地址，那么在全局配置中将此配置选项设置为 `true` ，连同名称一起，Git 会在进行新提交之前提示您在新克隆的存储库中设置电子邮件地址。默认为`false`。

#### `user.signingKey`

如果 [git-tag(1)](git-tag.html) 或 [git-commit(1)](git-commit.html) 在创建签名标签或提交时没有选择您希望它自动选择的密钥，您可以使用此变量覆盖默认选择。该选项原封不动地传递给 gpg 的 --local-user 参数，因此您可以使用 gpg 支持的任何方法指定密钥。如果 gpg.format 设置为`ssh`这可以包含您的私有 ssh 密钥或使用 ssh-agent 时的公共密钥的路径。或者，它可以包含一个带有前缀的公钥`key::` 直接（例如：“key::ssh-rsa XXXXXX 标识符”）。私钥需要通过 ssh-agent 提供。如果未设置，git 将调用 gpg.ssh.defaultKeyCommand（例如：“ssh-add -L”）并尝试使用第一个可用的密钥。为了向后兼容，以“ssh-”开头的原始密钥，例如“ssh-rsa XXXXXX identifier”，被视为“key::ssh-rsa XXXXXX identifier”，但这种形式已被弃用；改用`key::`表格。

#### web.browser 

> https://git-scm.com/docs/git-config#Documentation/git-config.txt-webbrowser

指定某些命令可能使用的浏览器。目前只有 [git-instaweb[1]](https://git-scm.com/docs/git-instaweb) 和 [git-help[1]](https://git-scm.com/docs/git-help) 可以使用它。

## BUGS

当使用废弃的 `[section.subsection]` 语法时，如果 `subsection` 至少有一个大写字符，更改一个值将导致添加一个多行键，而不是更改。例如，当前配置是

``` 
  [section.subsection]
    key = value1
```

运行 `git config section.Subsection.key value2` ，结果为

```
  [section.subsection]
    key = value1
    key = value2
```



## GIT

[git[1]]() 套件的一部分。
