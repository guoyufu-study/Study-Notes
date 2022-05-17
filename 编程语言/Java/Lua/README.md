# Lua

> 官网：[The Programming Language Lua](http://www.lua.org/home.html)

一种轻量级的可嵌入脚本语言。

## 下载安装

### 从源码构建

``` powershell
curl -R -O http://www.lua.org/ftp/lua-5.4.4.tar.gz
tar zxf lua-5.4.4.tar.gz
cd lua-5.4.4
make all test
```

> 需要提前准备环境：
>
> ``` powershell
> sudo apt install make gcc
> ```



## 示例代码

绘制南半球娥眉月：

``` lua
-- 圆
function disk(cx, cy, r)
    return function (x, y)
        return ((x-cx)^2 + (y-cy)^2) <= r^2
    end
end 

-- 交集
function diff (r1, r2)
    return function (x, y)
        return r1(x,y) and not r2(x,y)
    end
end

-- 平移
function translate (r, dx, dy)
    return function (x, y)
        return r(x-dx, y-dy)
    end
end 

-- 绘制
function plot (r, M, N)
    io.output("moon.pbm")
    io.write("P1\n", M, " ", N, "\n") -- 文件头
    for i = 1, N do
        local y = (N - i*2) /N
        for j = 1, M do
            local x = (j*2 - M)/M
            io.write(r(x,y) and "1" or "0")
        end
    end
    io.flush()
    io.close()
end

-- 执行
c1 = disk(0, 0, 1)
plot(diff(c1, translate(c1, 0.3, 0)), 500, 500)
```

