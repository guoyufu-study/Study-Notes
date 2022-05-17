# 标准库

> http://www.lua.org/manual/5.4/manual.html#6

标准 Lua 库提供了有用的函数，这些函数通过 C API 在 C 中实现。其中一些函数为语言提供了基本服务（比如，[`type`](http://www.lua.org/manual/5.4/manual.html#pdf-type)和[`getmetatable`](http://www.lua.org/manual/5.4/manual.html#pdf-getmetatable)）；另外一些函数提供对外部服务的访问（例如，I/O）；还有一些函数，可以在 Lua 本身中实现，但由于不同的原因，应该在 C 中实现（例如，[`table.sort`](http://www.lua.org/manual/5.4/manual.html#pdf-table.sort)）。

所有库都通过官方 C API 实现，并作为单独的 C 模块提供。除非另有说明，否则这些库函数不会将其参数数量调整为预期参数。比如，记录为 `foo(arg)` 的函数，不应在没有参数的情况下调用。

目前，Lua 有以下标准库：

- 基本库（[§6.1](http://www.lua.org/manual/5.4/manual.html#6.1)）；
- 协程库（[第 6.2 节](http://www.lua.org/manual/5.4/manual.html#6.2)）；
- 包库（[§6.3](http://www.lua.org/manual/5.4/manual.html#6.3)）；
- 字符串操作（[第 6.4 节](http://www.lua.org/manual/5.4/manual.html#6.4)）；
- 基本的 UTF-8 支持（[§6.5](http://www.lua.org/manual/5.4/manual.html#6.5)）；
- 表操作（[第 6.6 节](http://www.lua.org/manual/5.4/manual.html#6.6)）；
- 数学函数（[第 6.7 节](http://www.lua.org/manual/5.4/manual.html#6.7)）（sin、log 等）；
- 输入和输出（[§6.8](http://www.lua.org/manual/5.4/manual.html#6.8)）；
- 操作系统设施（[§6.9](http://www.lua.org/manual/5.4/manual.html#6.9)）；
- 调试工具（[§6.10](http://www.lua.org/manual/5.4/manual.html#6.10)）。

除了基本库和包库之外，每个库都将其所有函数作为全局表的字段或作为其对象的方法提供。