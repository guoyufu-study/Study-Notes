# 安装后配置



用户邮箱、用户名、中文路径

``` powershell
git config --global user.email "guoyufu_study@163.com"
git config --global user.name "guoyufu-study"
git config --global core.quotepath false
```

检查是否已存在 SSH 密钥

``` powershell
ls -al ~/.ssh
```

> https://docs.github.com/cn/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys

可以更改现有私钥的密码而无需重新生成密钥对：

```shell
ssh-keygen -p -f ~/.ssh/id_ed25519
```

生成新 SSH 密钥以用于身份验证

> https://docs.github.com/cn/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

``` powershell
ssh-keygen -t ed25519 -C "guoyufu_study@163.com"
```



将密钥添加到 ssh-agent。

> https://docs.github.com/cn/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases

可以在打开 bash 或 Git shell 时自动运行 `ssh-agent`。 复制以下行并将其粘贴到 Git shell 中的 `~/.profile` 或 `~/.bashrc` 文件中：

```bash
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env
```

如果您的私钥没有存储在默认位置之一（如 `~/.ssh/id_rsa`），您需要告知 SSH 身份验证代理其所在位置。 要将密钥添加到 ssh-agent，请输入 `ssh-add ~/path/to/my_key`。

现在，当您初次运行 Git Bash 时，系统将提示您输入密码。