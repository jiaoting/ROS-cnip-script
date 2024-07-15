# ROS-cnip-script

此ip列表整合了[kiddin9/china_ip_list](https://github.com/kiddin9/china_ip_list)、[Sereinfy/china_ip_list](https://github.com/Sereinfy/china_ip_list)，并参考[MF2022/ROS-cnip-script](https://github.com/DMF2022/ROS-cnip-script)添加了ROS脚本，另外增加了[Akamai-ASN-and-IPs-List](https://github.com/SecOps-Institute/Akamai-ASN-and-IPs-List)，使用合并ip解决国内分流无法覆盖的局限性（如某些厂商服务分流无法正常使用，比如联想应用商店，微软商店，微软更新等），并加入ROS的导入命令制作而成。


>此项目包含IPV4、IPV6地址。

>自动修改为ROS命令脚本文件，使用Github Actions每小时定期更新。

>加了一条在导入前清空名为“CNIP”列表的命令，避免出现新旧列表交叉冲突。

>加了一条导入列表时关闭日志输出的指令，避免日志刷屏。

>增加了10.0.0.0/8，172.16.0.0/12，192.168.0.0/16三个内网网段到CN列表，避免本地网络和VPN网络走标记路由。

附：ROS导入脚本

>请确保ROS网络可以正常访问github。

###### 在/System Script下添加如下脚本内容
```
:log info ("CNIP列表更新中...")

/tool fetch url=https://mirror.ghproxy.com/https://raw.githubusercontent.com/jiaoting/ROS-cnip-script/main/cnipv4.rsc
/tool fetch url=https://mirror.ghproxy.com/https://raw.githubusercontent.com/jiaoting/ROS-cnip-script/main/cnipv6.rsc

/system logging disable 0

:local CNIPv4old [:len [/ip firewall address-list find list="CNIP"]]
:local CNIPv6old [:len [/ipv6 firewall address-list find list="CNIP"]]

/import cnipv4.rsc
/import cnipv6.rsc

:local CNIPv4new [:len [/ip firewall address-list find list="CNIP"]]
:local CNIPv6new [:len [/ipv6 firewall address-list find list="CNIP"]]

/system logging enable 0

:log info ("CNIP列表更新:IPV4共".($CNIPv4new)."条规则，增加".($CNIPv4new-$CNIPv4old)."条")
:log info ("CNIP列表更新:IPV6共".($CNIPv6new)."条规则，增加".($CNIPv6new-$CNIPv6old)."条")
```

建议手动执行，也可以在/System Scheduler下添加一个脚本定时
