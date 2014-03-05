# RUNWAY

## 通过网络自动化安装操作系统

使用安居客办公室的有线网络，开机选择网络启动，正常情况下在自动获取到ip地址之后，在 `boot: ` 之后输入需要安装的操作系统版本，回车开始自动安装。安装完成后重启，默认以root用户登录，密码为r00tr00t。

* 可选择的操作系统版本：
  * `ubuntu 12.04.3 amd64`
  * `ubuntu 12.04.3 i386`

## 基础配置
* 添加用户且安装配置ansible,则在root账户下命令行执行 `curl -L http://126.am/runway | bash -s username password ` 

username和password两个参数用自定义的用户名和密码替换。
添加成功之后，可以看到`User has been added to system!`提示信息。

* 不添加用户，只安装与配置ansible的话，root账户下命令行执行 `curl -L http://126.am/runway | bash ` 

ansible安装与配置成功后，可以看到

```
localhost | success >> {
	"changed": false,
	"ping": "pong"
}
````



