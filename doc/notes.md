##可能出现的错误及处理方案
* 虚拟机配置为`host-only`,主机配置`iptables`作为路由器连接虚拟机和外网
```
vim /etc/sysctl.conf
cat /proc/sys/net/ipv4/ip_forward

iptables -t nat -xvnL

iptables -t nat -A POSTROUTING -s 172.20.100.0/24 -o eth0 -j MASQUERADE

```
*手动将某用户添加到根权限，即用`sudo`指令和用`sudo su -`都不用输入密码
终端输入：`sudo visudo`(一定要用visudo修改sudoers文件)
修改文件`/etc/sudoers`在最后一行`#includedir /etc/sudoers.d`后添加`%username ALL=NOPASSWD：ALL`

*配置.ssh/config文件
```
Host *
     ServerAliveInterval 60
     Compression	yes
     CompressionLevel   9
     ControlMaster      auto
     ControlPath        /temp/%r@%h: %p
     cipher		blowfish

Host loginpd
     hostname login-pd.corp.ajk.com
     user   Noelchen
```

*ssh密钥无效
ssh的key没有加入到ssh-agent中，加入方法是`ssh-add id_rsa`

*查看本机DNS服务器地址
`cat /etc/resolv.conf`

*Easiest way to copy ssh keys to anther machine:`ssh-copy-id -i user@hostname.example.com`

*用户是否已经存在，查看三个文件：`/etc/passwd`,`/etc/group`,`/etc/shadow`
