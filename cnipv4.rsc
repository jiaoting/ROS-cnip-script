
/ip firewall address-list

remove [find list=CNIP]

add address=10.0.0.0/8 list=CNIP

add address=172.16.0.0/12 list=CNIP

add address=192.168.0.0/16 list=CNIP
add address=china_ip_list_v4.txt list=CNIP
