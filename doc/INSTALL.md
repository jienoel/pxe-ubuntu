# 通过网络自动化安装操作系统

##1、原理
参考网站 [1](https://help.ubuntu.com/12.04/installation-guide/powerpc/install-methods.html) [2](https://help.ubuntu.com/12.04/installation-guide/i386/automatic-install.html) [3](https://help.ubuntu.com/12.04/installation-guide/powerpc/ch05s01.html)
   
PXE Client通过PXE启动后，首先通过DHCP服务器获取IP地址、TFTP服务器的地址和启动文件的名称，然后通过TFTP协议下载启动文件、启动配置文件、安装用的内核与文件系统，最后通过NFS/WEB/FTP服务器获取自动应答和安装文件。


##2、安装环境与要求
* 服务器端要求：

配置：Kickstart + DHCP + TFTP + PXE

* 客户端要求：

1、客户端主板bios必须支持PXE网络启动

2、客户端与服务器的保持网络连接

##3、服务器端配置

###DHCP服务
* 安装[DHCP](https://help.ubuntu.com/lts/serverguide/dhcp.html)服务
```
$sudo apt-get	install isc-dhcp-server
```

* 修改[DHCP配置文件](http://manpages.ubuntu.com/manpages/precise/en/man5/dhcpd.conf.5.html)

```
$sudo vim /etc/dhcp/dhcpd.conf

ddns-update-style none;
option domain-name “example.org”;
option domain-name-servers ns.example.org;
default-lease-time 600;
max-lease-time 7200;
log-facility local7;
allow booting;
allow bootp;

**tips:网络配置可以根据实际环境进行修改

subnet 172.20.100.0 netmask 255.255.255.0 {

range 172.20.100.100 172.20.100.200;
option domain-name-servers 192.168.1.100;
option routers 172.20.100.1;
option broadcast-address 172.20.100.255;
default-lease-time 86400;
max-lease-time 172800;
filename "pxelinux.0";  #放在TFTP服务的文件夹下启动映像文件。
#       next-server 172.20.100.1; #TFTP服务器的地址，如果TFTP服务和DHCP服务部署在同一台机器时，可以省略。
	}
```

* 指定[监听端口](https://help.ubuntu.com/community/dhcp3-server)
```
sudo vim /etc/default/isc-dhcp-server
INTERFACES="eth0"
```
* 启动DHCP服务
```
sudo /etc/init.d/isc-dhcp-server start
```

###TFTP服务

* 安装[TFTP服务](http://en.wikipedia.org/wiki/Trivial_File_Transfer_Protocol)
```
sudo apt-get install tftpd-hpa
```
* 修改[TFTP](http://www.mmweg.rwth-aachen.de/~philipp.michalschik/wordpress/running-tftp-server-on-ubuntu-12-04-lts-precise/)配置文件

```
sudo vim /etc/default/tftpd-hpa

TFTP_USERNAME=”tftp”
TFTP_DIRECTORY=”/var/lib/tftpboot”
TFTP_ADDRESS=”0.0.0.0:69″
TFTP_OPTIONS=”–secure”

```

* 修改tftpboot权限
```
chmod 777 /var/lib/tftpboot
```

* 启动tftp
```
sudo /etc/init.d/tftpd-hpa restart
```

###HTTP服务
* 安装[apache](https://library.linode.com/web-servers/apache/installation/ubuntu-12.04-precise-pangolin)
```
apt-get install apache2
```
* 启动httpd
```
service apache2 start
```

* 在apache服务根目录下创建ubuntu文件夹，并将ubuntu镜像文件(xxx.iso)挂载到该目录

```
mkdir -p /var/www/ubuntu
mkdir -p /mnt/ubuntu/
mount -o loop xxx.iso /mnt/ubuntu
cp –r /mnt/Ubuntu/* /var/www/ubuntu

```

在浏览器中访问http://服务器ip/ubuntu,可以列出ubuntu目录，配置正常

* 将ubuntu/install目录下的netboot中的所有内容拷贝到tftpboot
```
cp -r /var/www/ubuntu/install/netboot/* /var/lib/tftpboot/
```

* 生成脚本文件，将其复制在web服务器的路径下。

###脚本文件
* [kickstart](https://help.ubuntu.com/12.04/installation-guide/i386/automatic-install.html)脚本

安装运行该工具

```
apt-get install system-config-kickstart
system-config-kickstart

```

因为kickstart的图形界面在ubuntu下没办法配置软件包，所以通过图形化界面进行基本配置并生成ks.cfg脚本后,再手动更改这个脚本。

* [preseed](https://help.ubuntu.com/12.04/installation-guide/i386/appendix-preseed.html)脚本
        
###修改配置文件
将[boot.txt](../pxe_config/boot.txt)和[default](../pxe_config/default)这两个文件复制到/var/lib/tftpboot/pxelinux.cfg目录下即可。或者按照如下指令进行手动配置。

```
sudo vim /var/lib/tftpboot/pxelinux.cfg/default

DISPLAY /pxelinux.cfg/boot.txt

DEFAULT install_ubuntu12.04_amd64
PROMPT 5
TIMEOUT 0

LABEL install_ubuntu12.04_amd64
	KERNEL /ubuntu-installer/amd64/linux

#unattended networking install ubuntu12.04 -using preseeding 
	APPEND auto=true priority=critical interface=auto http://one-740.i.ajkdns.com/preseed/os_preseed.cfg initrd=/ubuntu-installer/amd64/initrd.gz ramdisk_size=16432 root=/dev/rd/0 rw --

#unattended networking install ubuntu12.04 -using kickstart+preseeding(umcomment this line if you install it don't want to use kickstart files)
#APPEND ks=http://one-740.i.ajkdns.com/kickstart/os.cfg preseed/url=http://one-740.i.ajkdns.com/preseed/os.seed  initrd=/ubuntu-installer/amd64/initrd.gz ramdisk_size=16432 root=/dev/rd/0 rw --

label install_ubuntu12.04_i386_preseed
	#menu label install_ubuntu12.04_i386_preseed
	kernel ubuntu/i386/ubuntu-installer/i386/linux
	APPEND auto=true priority=critical interface=auto url=http://one-740.i.ajkdns.com/preseed/os_preseed.seed initrd=/ubuntu/i386/ubuntu-installer/i386/initrd.gz ramdisk_size=16432 root=/dev/rd/0 rw --

```

ps：url中的地址需设置成web服务器的地址;ubuntu 12.04只使用kickstart不能设置proxy，每次下载文件只能直接从外网下载，造成安装过程过慢。采用[kickstart](../kickstart/os_64_kickstart.cfg)+[preseed](../preseed/os_64_kickstart_preseed.seed)方式，或者直接采用[preseed](../preseed/os_64_preseed.seed)方式能实现设置了proxy的自动化安装。
启动的kernel文件和initrd文件来自与ubuntu的iso镜像中的netboot里。

## 4 客户端配置

连接安居客有线网络，开机从网络启动，PXE从DHCP获得ip，从server下载基础文件，开始安装。

