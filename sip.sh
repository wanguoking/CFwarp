#!/usr/bin/env bash

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[36m\033[01m$1\033[0m"
}
white(){
    echo -e "\033[1;37m\033[01m$1\033[0m"
}
bblue(){
    echo -e "\033[1;34m\033[01m$1\033[0m"
}
rred(){
    echo -e "\033[1;35m\033[01m$1\033[0m"
}
WARPIPv4Status=$(wget -T1 -t1 -qO- -4 www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
WARPIPv6Status=$(wget -T1 -t1 -qO- -6 www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
if [[ $WARPIPv6Status = plus || $WARPIPv4Status = plus || $WARPIPv6Status = on || $WARPIPv4Status = on ]]; then
red "稍等2秒……刷新中…………"
AE="阿联酋";AU="澳大利亚";BR="巴西";CA="加拿大";CH="瑞士";CL="智利";CN="中国";DE="德国";ES="西班牙";FI="芬兰";FR="法国";HK="香港";ID="印尼";IE="爱尔兰";IL="以色列";IN="印度";IT="意大利";JP="日本";KR="韩国";MY="马来西亚";NL="荷兰";NZ="新西兰";PH="菲律宾";RU="俄罗斯";SA="沙特";SE="瑞典";SG="新加坡";TW="台湾";UK="英国";US="美国";VN="越南";ZA="南非"
wg-quick down wgcf >/dev/null 2>&1
systemctl start wg-quick@wgcf >/dev/null 2>&1
wg-quick up wgcf >/dev/null 2>&1
v4=$(wget -T1 -t1 -qO- -4 ip.gs)
v6=$(wget -T1 -t1 -qO- -6 ip.gs)
until [[ -n $v4 || -n $v6 ]]
do
wg-quick down wgcf >/dev/null 2>&1
wg-quick up wgcf >/dev/null 2>&1
v4=$(wget -T1 -t1 -qO- -4 ip.gs)
v6=$(wget -T1 -t1 -qO- -6 ip.gs)
done

v44=`wget -T1 -t1 -qO- -4 ip.gs`
if [[ -n ${v44} ]]; then
gj4=`curl -s4 https://ip.gs/country-iso -k`
g4=$(eval echo \$$gj4)
WARPIPv4Status=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv4Status} in 
plus) 
WARPIPv4Status=$(green "IPV4 WARP状态：WARP+PLUS已开启 \n IPV4 当前地址：$v44 \n IPV4 所在区域：$g4") 
;;  
on) 
WARPIPv4Status=$(green "IPV4 WARP状态：WARP已开启 \n IPV4 当前地址：$v44 \n IPV4 所在区域：$g4") 
;; 
off) 
WARPIPv4Status=$(yellow "IPV4 WARP状态：WARP未开启 \n IPV4 当前地址：$v44 \n IPV4 所在区域：$g4")
esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")
fi 

v66=`wget -T1 -t1 -qO- -6 ip.gs`
if [[ -n ${v66} ]]; then 
gj6=`curl -s6 https://ip.gs/country-iso -k`
g6=$(eval echo \$$gj6)
WARPIPv6Status=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv6Status} in 
plus) 
WARPIPv6Status=$(green "IPV6 WARP状态：WARP+PLUS已开启 \n IPV6 当前地址：$v66 \n IPV6 所在区域：$g6") 
;;  
on) 
WARPIPv6Status=$(green "IPV6 WARP状态：WARP已开启 \n IPV6 当前地址：$v66 \n IPV6 所在区域：$g6") 
;; 
off) 
WARPIPv6Status=$(yellow "IPV6 WARP状态：WARP未开启 \n IPV6 当前地址：$v66 \n IPV6 所在区域：$g6")
esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")
fi 
green "安装结束，当前WARP及IP状态如下 "
white "=========================================="
blue " ${WARPIPv4Status}"
white "------------------------------------------"
blue " ${WARPIPv6Status}"
white "=========================================="
else
red "你的WARP没有开启，无法运行"
fi
