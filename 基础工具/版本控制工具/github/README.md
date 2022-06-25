# GitHub

> https://github.com/

## 注册账号



## 配置访问

### SSH 和 GPG 密钥

[使用 SSH 连接到 GitHub](https://docs.github.com/cn/authentication/connecting-to-github-with-ssh)



## 创建本地已存在项目

github 上创建新项目

进入本地项目主目录 `${project}`：

``` powershell
# 建库
git init

# 1.连接远程库
git remote add origin git@github.com:guoyufu-study/Hello-JEPCofe-WordleKata.git

# 2.拉取到本地（可选：重命名分支）
git branch -m main dev
git pull origin dev救

# 3.提交、关联推送
git add .
git commit -m "xxx"
git push --set-upstream origin dev:dev
```



