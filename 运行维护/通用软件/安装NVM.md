# 安装 nvm、nodejs、npm

## 手动安装 nvm

执行，

``` bash
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
```

并在`~/.bashrc`文件中追加

``` bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```



## 安装 nodejs 和 npm

cnpm 官网： https://github.com/cnpm/cnpm?spm=a2c6h.24755359.0.0.6d443dc18BqoY3

``` bash
# 淘宝镜像
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
# 安装
nvm current
nvm ls-remote 16
nvm install lts/gallium

# 安装 cnpm: npm client for China mirror of npm 
npm install cnpm -g --registry=https://registry.npmmirror.com
```

## 安装 docsify

一个神奇的文档网站生成器，https://docsify.js.org

``` bash
cnpm install docsify -g
```
