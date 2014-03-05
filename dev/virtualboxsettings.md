#测试环境搭建

###安装virtualbox4.3
* 终端命令 编辑sources.list
```
sudo gedit /etc/apt/sources.list
```

* 添加 软件源

将下面的地址加入sources.list 的末尾，保存并退出
```
deb http://download.virtualbox.org/virtualbox/debian precise contrib
```

* 终端命令 导入公钥，并更新源(一定要更新，不然即使安装了VirtualBox也无法使用)

```
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-get update

```

* 正式安装
```	
$ sudo apt-get install virtualbox-4.3
```

* 设置虚拟机
虚拟机的网络设置选择Host-only Adapter，ip地址设置为172.20.100.0/24网段，并关闭其自带的DHCP服务。其他的默认即可。

###配置DHCP+TFTP+APACHE服务器
* 将虚拟机所在的物理机作为服务器，服务器的配置和脚本的设置参见[design.md](design.md)文档。

###配置路由转发规则
安装过程中，选择的mirror非本地镜像，Host-only模式下的虚拟机需要连接外网时，需要设置主机的iptables。设置方法如下：

```
sudo sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -s 172.20.100.0/24 -o eth0 -j MASQUERADE

```

到此，完成所有配置，打开虚拟机，按F12，选择网络启动，选择待安装的操作系统的版本即可。
