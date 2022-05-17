# 运行维护

> 阿里云官方镜像：https://developer.aliyun.com/mirror/

## 常用虚拟机软件

* [VMware ](运行维护/VMware/)
* [Hyper-V](运行维护/Hyper-V/)
* [VirtualBox](运行维护/VirtualBox/)

***

## 常用操作系统

* [Window 10](运行维护/Windows-10/)

* CentOS https://www.centos.org/
  
  * CentOS Linux https://www.centos.org/centos-linux/
    
    * [CentOS 7](运行维护/CentOS-7/)（EOL 2024/07/30）
    * ~~[CentOS Linux 8](运行维护/CentOS-Linux-8/)~~（EOL 2021/12/31）
  
  * CentOS Stream https://www.centos.org/centos-stream/
    
    * CentOS Stream 8
    * CentOS Stream 9
  
  * 要从 CentOS Linux 8 转换成 CentOS Stream 8，可以简单地执行以下命令：
    
    ```shell
    dnf swap centos-linux-repos centos-stream-repos
    dnf distro-sync
    ```

* [Ubuntu](运行维护/Ubuntu/)

***

## 常用容器

* [Docker](运行维护/Docker/)
* rkt：
* [k8s](运行维护/k8s/)

***

## 常见工具流

* [复制虚拟机并初始化配置](运行维护/常见工作流/复制虚拟机并初始化配置.md)
