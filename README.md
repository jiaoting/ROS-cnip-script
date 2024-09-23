# ROS-cnip-script

- 此项目中CNIP包含IPv4、IPv6地址，CDN仅包含IPv4
- 该项目的CNIP列表整合自[kiddin9/china_ip_list](https://github.com/kiddin9/china_ip_list)、[Sereinfy/china_ip_list](https://github.com/Sereinfy/china_ip_list)，CNIP参考源：
[qqwry](https://www.github.com/metowolf/iplist)、
[ipipnet](https://www.github.com/17mon/china_ip_list/)、
[clang](https://ispip.clang.cn/)、
[mayax](https://www.github.com/mayaxcn/china-ip-list/)、
[gaoyifan](https://www.github.com/gaoyifan/china-operator-ip/)、
[Hackl0us](https://www.github.com/Hackl0us/GeoIP2-CN/)、
[misakaio](https://www.github.com/misakaio/chnroutes2/)
- 为解决某些厂商服务分流后网速变慢或无法使用的情况（比如Apple更新、联想应用商店，微软商店，微软更新等），IPv4列表增加Extra文件夹里的IP列表内容
- 所有IP列表使用[cidr-merger](https://github.com/zhanhb/cidr-merger/)合并优化缩表
- 参考[MF2022/ROS-cnip-script](https://github.com/DMF2022/ROS-cnip-script)添加了ROS脚本命令制作而成，可实现ROS一键导入。
  >加了一条在导入前清空名为“CNIP”列表的命令，避免出现新旧列表交叉冲突。
  >
  >加了一条导入列表时关闭日志输出的指令，避免日志刷屏。
  >
  >增加了10.0.0.0/8，172.16.0.0/12，192.168.0.0/16三个内网网段到CNIP列表，避免本地网络和VPN网络走标记路由。
- 使用Github Actions每小时定期更新。




附：ROS导入脚本

>已添加ghp.ci国内加速。
>
>建议手动执行，也可以在/System Scheduler下添加一个脚本定时

###### 在/System Script下添加如下脚本内容
```
:log info ("CNIP列表更新中...")

/tool fetch url=https://ghp.ci/https://raw.githubusercontent.com/jiaoting/ROS-cnip-script/main/cnipv4.rsc
/tool fetch url=https://ghp.ci/https://raw.githubusercontent.com/jiaoting/ROS-cnip-script/main/cnipv6.rsc

/system logging disable 0

:local CNIPv4old [:len [/ip firewall address-list find list="CNIP"]]
:local CNIPv6old [:len [/ipv6 firewall address-list find list="CNIP"]]

/import cnipv4.rsc
/import cnipv6.rsc

:local CNIPv4new [:len [/ip firewall address-list find list="CNIP"]]
:local CNIPv6new [:len [/ipv6 firewall address-list find list="CNIP"]]

/system logging enable 0

:log info ("CNIP列表更新:IPv4共".($CNIPv4new)."条规则，增加".($CNIPv4new-$CNIPv4old)."条")
:log info ("CNIP列表更新:IPv6共".($CNIPv6new)."条规则，增加".($CNIPv6new-$CNIPv6old)."条")
:log info ("CNIP列表更新:CDN共".($CDNnew)."条规则，增加".($CDNnew-$CDNold)."条")
```

