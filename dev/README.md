##环境安装与配置方法
###服务器配置
* step1 [安装ansible](../README.MD)

* step2 下载配置文件(配置tftp的配置文件): `curl -o /var/tmp/tftpboot.tar.gz http://126.io/tftpboot`

* step3 安装虚拟机: `ansible-playbook playbook.yml` 

* step4 开启一台虚拟机，网络设置选择Host-only Adapter，ip地址设置为172.20.100.0/24网段。

* step5 配置虚拟机为pxe服务器：`ansible-playbook playbook.yml --extra-var=host=yourvirtualhostname`

###测试
* 虚拟机的网络设置选择Host-only Adapter，ip地址设置为172.20.100.0/24网段，并关闭其自带的DHCP服务。其他的默认即可。然后开机，选择网络安装即可测试。
