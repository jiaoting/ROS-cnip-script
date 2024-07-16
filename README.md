# ROS-cnip-script

该项目的CNIP列表整合自[kiddin9/china_ip_list](https://github.com/kiddin9/china_ip_list)、[Sereinfy/china_ip_list](https://github.com/Sereinfy/china_ip_list)，并新增CDN服务器IP列表（Akamai、CacheFly、CDNetworks、Cloudflare、CloudFront、DDoS Guard、Fastly、Incapsula、Limelight、MaxCDN、Qrator、StackPath、StormWall、Sucuri、X4B），解决国内分流无法覆盖的局限性（如某些厂商服务分流无法正常使用，比如联想应用商店，微软商店，微软更新等）
所有IP列表使用[cidr-merger](https://github.com/zhanhb/cidr-merger/)合并优化缩表，并参考[MF2022/ROS-cnip-script](https://github.com/DMF2022/ROS-cnip-script)添加了ROS脚本命令制作而成，可实现ROS一键导入。

CNIP参考源：
[qqwry](https://www.github.com/metowolf/iplist)、
[ipipnet](https://www.github.com/17mon/china_ip_list/)、
[clang](https://ispip.clang.cn/)、
[mayax](https://www.github.com/mayaxcn/china-ip-list/)、
[gaoyifan](https://www.github.com/gaoyifan/china-operator-ip/)、
[Hackl0us](https://www.github.com/Hackl0us/GeoIP2-CN/)、
[misakaio](https://www.github.com/misakaio/chnroutes2/)

CDN参考源：
[Akamai-ASN-and-IPs-List](https://github.com/SecOps-Institute/Akamai-ASN-and-IPs-List)
[CDN Ranges](https://github.com/schniggie/cdn-ranges)

>此项目中CNIP包含IPv4、IPv6地址，CDN仅包含IPv4

>自动修改为ROS命令脚本文件，使用Github Actions每小时定期更新。

>加了一条在导入前清空名为“CNIP”列表的命令，避免出现新旧列表交叉冲突。

>加了一条导入列表时关闭日志输出的指令，避免日志刷屏。

>增加了10.0.0.0/8，172.16.0.0/12，192.168.0.0/16三个内网网段到CNIP列表，避免本地网络和VPN网络走标记路由。


附：ROS导入脚本

>已添加ghproxy.com国内加速。

###### 在/System Script下添加如下脚本内容
```
:log info ("CNIP列表更新中...")

/tool fetch url=https://mirror.ghproxy.com/https://raw.githubusercontent.com/jiaoting/ROS-cnip-script/main/cnipv4.rsc
/tool fetch url=https://mirror.ghproxy.com/https://raw.githubusercontent.com/jiaoting/ROS-cnip-script/main/cnipv6.rsc
/tool fetch url=https://mirror.ghproxy.com/https://raw.githubusercontent.com/jiaoting/ROS-cnip-script/main/cdn.rsc

/system logging disable 0

:local CNIPv4old [:len [/ip firewall address-list find list="CNIP"]]
:local CNIPv6old [:len [/ipv6 firewall address-list find list="CNIP"]]
:local CDNold [:len [/ip firewall address-list find list="CDN"]]

/import cnipv4.rsc
/import cnipv6.rsc
/import cdn.rsc

:local CNIPv4new [:len [/ip firewall address-list find list="CNIP"]]
:local CNIPv6new [:len [/ipv6 firewall address-list find list="CNIP"]]
:local CDNnew [:len [/ip firewall address-list find list="CDN"]]

/system logging enable 0

:log info ("CNIP列表更新:IPv4共".($CNIPv4new)."条规则，增加".($CNIPv4new-$CNIPv4old)."条")
:log info ("CNIP列表更新:IPv6共".($CNIPv6new)."条规则，增加".($CNIPv6new-$CNIPv6old)."条")
:log info ("CNIP列表更新:CDN共".($CDNnew)."条规则，增加".($CDNnew-$CDNold)."条")
```

建议手动执行，也可以在/System Scheduler下添加一个脚本定时
