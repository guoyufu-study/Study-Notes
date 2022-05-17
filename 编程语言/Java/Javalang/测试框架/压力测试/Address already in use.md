

# JMeter压测“java.net.BindException: Address already in use: connect”解决方法

[文章来源](https://www.cnblogs.com/ailiailan/p/11519474.html)

之前在windows机上用JMeter压测，50并发下出现大量接口报“java.net.BindException: Address already in use: connect”错误。

从字面的意思看，是地址被占用了。

查资料才知道是windows本身提供的端口数量有限制。导致接口请求时，端口被占用；Windows XP提供给 TCP/IP链接的端口为 1024-5000，并且要四分钟来循环回收他们。就导致我们在短时间内跑大量的请求时将端口占满了。

**解决步骤：**

1、cmd中，用regedit命令打开注册表

2、在 HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters

3、右键Parameters

4、添加新的DWORD，名字为MaxUserPort和TcpTimedWaitDelay

5、分别输入数值数据为65534和30，基数选择十进制；以增大可分配的tcp连接端口数、减小处于TIME_WAIT状态的连接的生存时间

6、修改配置完毕之后记得重启机器才会生效