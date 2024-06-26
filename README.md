# ROS-cnip-script

此ip列表搬运自[kiddin9/china_ip_list](https://github.com/kiddin9/china_ip_list)，并在[MF2022/ROS-cnip-script](https://github.com/DMF2022/ROS-cnip-script)的基础上，增加了[Akamai-ASN-and-IPs-List](https://github.com/SecOps-Institute/Akamai-ASN-and-IPs-List)，使用合并ip解决国内分流无法覆盖的局限性（如某些厂商服务分流无法正常使用，比如联想应用商店，微软商店，微软更新等），并加入ROS的导入命令制作而成。


>此列表仅包含IPV4地址，没有IPV6地址。

>自动修改为ROS命令脚本文件，不定期更新。

>加了一条在导入前清空名为“CNIP”列表的命令，避免出现新旧列表交叉冲突。

>加了一条导入列表时关闭日志输出的指令，避免日志刷屏。

>增加了10.0.0.0/8，172.16.0.0/12，192.168.0.0/16三个内网网段到CN列表，避免本地网络和VPN网络走标记路由。

附：ROS导入脚本

>请确保ROS网络可以正常访问github。

###### 在/System Script下添加如下脚本内容
```
:log info ("CNIP列表更新中...")
/tool fetch url=https://raw.gitmirror.com/jiaoting/ROS-cnip-script/main/cnip.rsc
/system logging disable 0
:local CNIPold [:len [/ip firewall address-list find list="CNIP"]]
/import cnip.rsc
/import Apple.rsc
:local CNIPnew [:len [/ip firewall address-list find list="CNIP"]]
/system logging enable 0
:log info ("CNIP列表更新:".($CNIPnew)."条规则，增加".($CNIPnew-$CNIPold)."条")
```
建议手动执行，也可以在/System Scheduler下添加一个脚本定时
