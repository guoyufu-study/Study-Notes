# Yum

> 参考 https://linux.cn/article-12161-1.html

由于 Yum 中许多长期存在的问题仍未得到解决，因此 [Yum 包管理器](https://www.2daygeek.com/yum-command-examples-manage-packages-rhel-centos-systems/)已被 [DNF 包管理器](https://www.2daygeek.com/linux-dnf-command-examples-manage-packages-fedora-centos-rhel-systems/)取代。这些问题包括性能差、内存占用过多、依赖解析速度变慢等。















***

``` bash
[root@centos803 ~]# yum help install
usage: yum install [-c [config file]] [-q] [-v] [--version]
                   [--installroot [path]] [--nodocs] [--noplugins]
                   [--enableplugin [plugin]] [--disableplugin [plugin]]
                   [--releasever RELEASEVER] [--setopt SETOPTS]
                   [--skip-broken] [-h] [--allowerasing] [-b | --nobest] [-C]
                   [-R [minutes]] [-d [debug level]] [--debugsolver]
                   [--showduplicates] [-e ERRORLEVEL] [--obsoletes]
                   [--rpmverbosity [debug level name]] [-y] [--assumeno]
                   [--enablerepo [repo]] [--disablerepo [repo] | --repo
                   [repo]] [--enable | --disable] [-x [package]]
                   [--disableexcludes [repo]] [--repofrompath [repo,path]]
                   [--noautoremove] [--nogpgcheck] [--color COLOR] [--refresh]
                   [-4] [-6] [--destdir DESTDIR] [--downloadonly]
                   [--comment COMMENT] [--bugfix] [--enhancement]
                   [--newpackage] [--security] [--advisory ADVISORY]
                   [--bz BUGZILLA] [--cve CVES]
                   [--sec-severity {Critical,Important,Moderate,Low}]
                   [--forcearch ARCH]
                   软件包 [软件包 ...]

向系统中安装一个或多个软件包
General YUM options:
  -c [config file], --config [config file]
                        配置文件位置
  -q, --quiet           静默执行
  -v, --verbose         详尽执行
  --version             显示 YUM 版本并推出
  --installroot [path]  设置目标根目录
  --nodocs              不要安装文档
  --noplugins           禁用所有插件
  --enableplugin [plugin]
                        启用指定名称的插件
  --disableplugin [plugin]
                        禁用指定名称的插件
  --releasever RELEASEVER
                        覆盖在配置文件和仓库文件中 $releasever 的值
  --setopt SETOPTS      设置任意配置和仓库选项
  --skip-broken         通过跳过软件包来解决依赖问题
  -h, --help, --help-cmd
                        显示命令帮助
  --allowerasing        允许解决依赖关系时删除已安装软件包
  -b, --best            在事务中尝试最佳软件包版本。
  --nobest              不用把事务限制在最佳选择
  -C, --cacheonly       完全从系统缓存运行，不升级缓存
  -R [minutes], --randomwait [minutes]
                        最大命令等待时间
  -d [debug level], --debuglevel [debug level]
                        调试输出级别
  --debugsolver         转储详细解决结果至文件
  --showduplicates      在 list/search 命令下，显示仓库里重复的条目
  -e ERRORLEVEL, --errorlevel ERRORLEVEL
                        错误输出级别
  --obsoletes           对升级启用 yum 的过期处理逻辑，或对 info、list 和 repoquery 显示软件包过期的功能
  --rpmverbosity [debug level name]
                        rpm调试输出等级
  -y, --assumeyes       全部问题自动应答为是
  --assumeno            全部问题自动应答为否
  --enablerepo [repo]   启用其他存储库。列出选项。支持 glob，可以多次指定。
  --disablerepo [repo]  禁用存储库。列出选项。支持 glob，可以多次指定。
  --repo [repo], --repoid [repo]
                        启用指定 id 或 glob 的仓库，可以指定多次
  --enable              使用 config-manager 命令启用 repos (自动保存)
  --disable             使用 config-manager 命令禁用 repos (自动保存)
  -x [package], --exclude [package], --excludepkgs [package]
                        用全名或通配符排除软件包
  --disableexcludes [repo], --disableexcludepkgs [repo]
                        禁用 excludepkgs
  --repofrompath [repo,path]
                        要使用的附加存储库的标签和路径（与 baseurl 中相同的路径），可以多次指定。
  --noautoremove        禁用删除不再被使用的依赖软件包
  --nogpgcheck          禁用 gpg 签名检查 (如果 RPM 策略允许)
  --color COLOR         配置是否使用颜色
  --refresh             在运行命令之前将元数据标记为过期。
  -4                    仅解析 IPv4 地址
  -6                    仅解析 IPv6 地址
  --destdir DESTDIR, --downloaddir DESTDIR
                        设置软件包要复制到的目录
  --downloadonly        仅下载软件包
  --comment COMMENT     为事务添加一个注释
  --bugfix              在更新中包括与 bug 修复有关的软件包
  --enhancement         在更新中包括与功能增强有关的软件包。
  --newpackage          在更新中包括与新软件包有关的软件包
  --security            在更新中包括与安全有关的软件包
  --advisory ADVISORY, --advisories ADVISORY
                        在更新中包括修复指定公告所必须的软件包
  --bz BUGZILLA, --bzs BUGZILLA
                        在更新中包括修复给定 BZ 所必须的软件包
  --cve CVES, --cves CVES
                        在更新中包括修复给定 CVE 所必须的软件包
  --sec-severity {Critical,Important,Moderate,Low}, --secseverity {Critical,Important,Moderate,Low}
                        在更新中包括匹配给定安全等级的安全相关的软件包
  --forcearch ARCH      强制使用一个架构

  软件包                   软件包安装
```