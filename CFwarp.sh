#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

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
    echo -e "\033[37m\033[01m$1\033[0m"
}
bblue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
rred(){
    echo -e "\033[35m\033[01m$1\033[0m"
}

if [[ $EUID -ne 0 ]]; then
yellow "请以root模式运行脚本。"
exit 1
fi

if [[ -f /etc/redhat-release ]]; then
release="Centos"
elif cat /etc/issue | grep -q -E -i "debian"; then
release="Debian"
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
release="Ubuntu"
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
release="Centos"
elif cat /proc/version | grep -q -E -i "debian"; then
release="Debian"
elif cat /proc/version | grep -q -E -i "ubuntu"; then
release="Ubuntu"
elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
release="Centos"
else 
red "不支持你当前系统，请选择使用Ubuntu,Debian,Centos系统。请向作者反馈 https://github.com/wanguoking/CFwarp/issues"
rm -f CFwarp.sh
exit 1
fi

if ! type curl >/dev/null 2>&1; then 
yellow "检测到curl未安装，安装中 "
if [ $release = "Centos" ]; then
yum -y update && yum install curl -y
else
apt update -y && apt install curl -y
fi	   
else
green " curl已安装，继续 "
fi

yellow " 请稍等3秒……正在扫描vps类型及参数中……"
bit=`uname -m`
version=`uname -r | awk -F "-" '{print $1}'`
main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`
sys(){
[ -f /etc/redhat-release ] && awk '{print $0}' /etc/redhat-release && return
[ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
[ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}
op=`sys`
vi=`systemd-detect-virt`
AE="阿联酋";AU="澳大利亚";BR="巴西";CA="加拿大";CH="瑞士";CL="智利";CN="中国";CO="哥伦比亚";DE="德国";ES="西班牙";FI="芬兰";FR="法国";HK="香港";ID="印度尼西亚";IE="爱尔兰";IL="以色列";IN="印度";IT="意大利";JP="日本";KR="韩国";LU="卢森堡";MX="墨西哥";MY="马来西亚";NL="荷兰";NZ="新西兰";PH="菲律宾";RU="俄罗斯";SA="沙特";SE="瑞典";SG="新加坡";TW="台湾";UK="英国";US="美国";VN="越南";ZA="南非"
v66=`curl -s6m3 https://ip.gs -k`
v44=`curl -s4m3 https://ip.gs -k`
isp4=`curl -s https://api.ip.sb/geoip/$v44 -k | awk -F "isp" '{print $2}' | awk -F "offset" '{print $1}' | sed "s/[,\":]//g"`
isp6=`curl -s https://api.ip.sb/geoip/$v66 -k | awk -F "isp" '{print $2}' | awk -F "offset" '{print $1}' | sed "s/[,\":]//g"`
if [[ -n ${v44} ]]; then
gj4=`curl -s https://api.ip.sb/geoip/$v44 -k | awk -F "country_code" '{print $2}' | awk -F "region_code" '{print $1}' | sed "s/[,\":}]//g"`
g4=$(eval echo \$$gj4)
WARPIPv4Status=$(curl -s4m3 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2) 
case ${WARPIPv4Status} in 
plus) 
WARPIPv4Status=$(white "IPV4 WARP(+)状态：\c" ; rred "WARP+PLUS运行中" ; white " IPV4 当前地址：\c" ; rred "$v44" ; white " IPV4 所在区域：\c" ; rred "$g4" ; white " IPV4 IP服务商：\c" ; rred "$isp4") 
;;  
on) 
WARPIPv4Status=$(white "IPV4 WARP状态：\c" ; green "WARP运行中" ; white " IPV4 当前地址：\c" ; green "$v44" ; white " IPV4 所在区域：\c" ; green "$g4" ; white " IPV4 IP服务商：\c" ; green "$isp4")
;; 
off) 
WARPIPv4Status=$(white "IPV4 WARP状态：\c" ; yellow "WARP关闭中" ; white " IPV4 当前地址：\c" ; yellow "$v44" ; white " IPV4 所在区域：\c" ; yellow "$g4" ; white " IPV4 IP服务商：\c" ; yellow "$isp4")
esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")
fi 
if [[ -n ${v66} ]]; then 
gj6=`curl -s https://api.ip.sb/geoip/$v66 -k | awk -F "country_code" '{print $2}' | awk -F "region_code" '{print $1}' | sed "s/[,\":}]//g"`
g6=$(eval echo \$$gj6)
WARPIPv6Status=$(curl -s6m3 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2) 
case ${WARPIPv6Status} in 
plus) 
WARPIPv6Status=$(white "IPV6 WARP(+)状态：\c" ; rred "WARP+PLUS运行中" ; white " IPV6 当前地址：\c" ; rred "$v66" ; white " IPV6 所在区域：\c" ; rred "$g6" ; white " IPV6 IP服务商：\c" ; rred "$isp6") 
;;  
on) 
WARPIPv6Status=$(white "IPV6 WARP状态：\c" ; green "WARP运行中" ; white " IPV6 当前地址：\c" ; green "$v66" ; white " IPV6 所在区域：\c" ; green "$g6" ; white " IPV6 IP服务商：\c" ; green "$isp6")
;; 
off) 
WARPIPv6Status=$(white "IPV6 WARP状态：\c" ; yellow "WARP关闭中" ; white " IPV6 当前地址：\c" ; yellow "$v66" ; white " IPV6 所在区域：\c" ; yellow "$g6" ; white " IPV6 IP服务商：\c" ; yellow "$isp6")
esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")
fi 

ud4='sed -i "5 s/^/PostUp = ip -4 rule add from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "6 s/^/PostDown = ip -4 rule delete from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf'
ud6='sed -i "7 s/^/PostUp = ip -6 rule add from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "8 s/^/PostDown = ip -6 rule delete from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf'
ud4ud6='sed -i "5 s/^/PostUp = ip -4 rule add from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "6 s/^/PostDown = ip -4 rule delete from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "7 s/^/PostUp = ip -6 rule add from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "8 s/^/PostDown = ip -6 rule delete from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf'
c1="sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf"
c2="sed -i '/\:\:\/0/d' wgcf-profile.conf"
c3="sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf"
c4="sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf"
c5="sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf"
c6="sed -i 's/1.1.1.1/2001:4860:4860::8888,8.8.8.8/g' wgcf-profile.conf"

Print_ALL_Status_menu() {
white " 操作系统名称: $(blue "$op")"
white " 系统内核版本: $(blue "$version")" 
white " CPU架构名称 : $(blue "$bit")"
white " 虚拟架构类型: $(blue "$vi")"
white "=========================================="
white " 当前IPV4接管出站流量情况如下"
blue " ${WARPIPv4Status}"
white "------------------------------------------"
white " 当前IPV6接管出站流量情况如下"
blue " ${WARPIPv6Status}"
white "=========================================="
}

get_char() {
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}

function ins(){
systemctl stop wg-quick@wgcf >/dev/null 2>&1
rm -rf /usr/local/bin/wgcf /etc/wireguard/wgcf.conf /etc/wireguard/wgcf-account.toml /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf

if [[ ${vi} == "openvz" ]]; then
yellow "正在检测lxc/openvz架构的vps是否开启TUN………！"
sleep 2s
TUN=$(cat /dev/net/tun 2>&1)
if [[ ${TUN} == "cat: /dev/net/tun: File descriptor in bad state" ]]; then
green "检测完毕：已开启TUN，支持安装wireguard-go模式的WARP(+)，继续……"
else
red "检测完毕：未开启TUN，不支持安装WARP(+)，请与VPS厂商沟通或后台设置以开启TUN，反馈地址 https://github.com/wanguoking/CFwarp/issues"
exit 1
fi
fi

if [[ ${vi} == "lxc" ]] && [ $release = "Centos" ]; then
echo -e nameserver 2a01:4f8:c2c:123f::1 > /etc/resolv.conf
fi

if [ $release = "Centos" ]; then  
yum -y install epel-release
yum -y install net-tools wireguard-tools	
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
if [[ ${vi} == "kvm" || ${vi} == "xen" || ${vi} == "microsoft" ]]; then
green "经检测，内核小于5.6版本，安装WARP内核模块模式"
yellow "内核升级到5.6版本以上，即可安装最高效的WARP内核集成模式"
sleep 2s
vsid=`grep -i version_id /etc/os-release | cut -d \" -f2 | cut -d . -f1`
curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-$vsid/jdoss-wireguard-epel-$vsid.repo
yum -y install epel-release wireguard-dkms
fi
fi	
yum -y update

elif [ $release = "Debian" ]; then
apt update -y 
apt -y install lsb-release
echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | tee /etc/apt/sources.list.d/backports.list
apt update -y
apt -y --no-install-recommends install net-tools iproute2 openresolv dnsutils wireguard-tools               		
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then
if [[ ${vi} == "kvm" || ${vi} == "xen" || ${vi} == "microsoft" ]]; then
green "经检测，内核小于5.6版本，安装WARP内核模块模式"
yellow "内核升级到5.6版本以上，即可安装最高效的WARP内核集成模式"
sleep 2s
apt -y --no-install-recommends install linux-headers-$(uname -r);apt -y --no-install-recommends install wireguard-dkms
fi
fi		
apt update -y
	
elif [ $release = "Ubuntu" ]; then
apt update -y  
apt -y --no-install-recommends install net-tools iproute2 openresolv dnsutils wireguard-tools			
fi
	
if [[ ${bit} == "x86_64" ]]; then
wget -N https://cdn.jsdelivr.net/gh/wanguoking/CFwarp/wgcf_2.2.9_amd64 -O /usr/local/bin/wgcf && chmod +x /usr/local/bin/wgcf         
elif [[ ${bit} == "aarch64" ]]; then
wget -N https://cdn.jsdelivr.net/gh/wanguoking/CFwarp/wgcf_2.2.9_arm64 -O /usr/local/bin/wgcf && chmod +x /usr/local/bin/wgcf
fi
if [[ ${vi} == "lxc" || ${vi} == "openvz" ]]; then
wget -N https://cdn.jsdelivr.net/gh/wanguoking/CFwarp/wireguard-go -O /usr/bin/wireguard-go && chmod +x /usr/bin/wireguard-go
fi

mkdir -p /etc/wireguard/ >/dev/null 2>&1
yellow "执行申请WARP账户过程中可能会多次提示：429 Too Many Requests，请耐心等待。"
echo | wgcf register
until [[ -e wgcf-account.toml ]]
do
sleep 1s
echo | wgcf register
done

yellow "继续使用原WARP账户请按回车跳过 \n启用WARP+PLUS账户，请复制WARP+的按键许可证秘钥(26个字符)后回车"
read -p "按键许可证秘钥(26个字符):" ID
if [[ -n $ID ]]; then
sed -i "s/license_key.*/license_key = \"$ID\"/g" wgcf-account.toml
wgcf update
green "启用WARP+PLUS账户中，如上方显示：400 Bad Request，则使用原WARP账户,相关原因请看本项目Github说明" 
fi
wgcf generate

yellow "开始自动设置WARP(+)的MTU最佳网络吞吐量值，以优化网速！"
v66=`curl -s6m3 https://ip.gs -k`
v44=`curl -s4m3 https://ip.gs -k`
MTUy=1500
MTUc=10
if [[ -n ${v66} && -z ${v44} ]]; then
ping='ping6'
IP1='2606:4700:4700::1001'
IP2='2001:4860:4860::8888'
else
ping='ping'
IP1='1.1.1.1'
IP2='8.8.8.8'
fi
while true; do
if ${ping} -c1 -W1 -s$((${MTUy} - 28)) -Mdo ${IP1} >/dev/null 2>&1 || ${ping} -c1 -W1 -s$((${MTUy} - 28)) -Mdo ${IP2} >/dev/null 2>&1; then
MTUc=1
MTUy=$((${MTUy} + ${MTUc}))
else
MTUy=$((${MTUy} - ${MTUc}))
if [[ ${MTUc} = 1 ]]; then
break
fi
fi
if [[ ${MTUy} -le 1360 ]]; then
MTUy='1360'
break
fi
done
MTU=$((${MTUy} - 80))
green "MTU最佳网络吞吐量值= $MTU 已设置完毕"
sed -i "s/MTU.*/MTU = $MTU/g" wgcf-profile.conf
echo $ABC1 | sh
echo $ABC2 | sh
echo $ABC3 | sh
echo $ABC4 | sh

mv -f wgcf-profile.conf /etc/wireguard/wgcf.conf >/dev/null 2>&1
mv -f wgcf-account.toml /etc/wireguard/wgcf-account.toml >/dev/null 2>&1
yellow "请稍等3秒，获取WARP(+)IP中…………"
systemctl enable wg-quick@wgcf >/dev/null 2>&1
wg-quick down wgcf >/dev/null 2>&1
systemctl start wg-quick@wgcf
green "WARP(+)IP获取成功"
v66=`curl -s6m3 https://ip.gs -k`
v44=`curl -s4m3 https://ip.gs -k`
isp4=`curl -s https://api.ip.sb/geoip/$v44 -k | awk -F "isp" '{print $2}' | awk -F "offset" '{print $1}' | sed "s/[,\":]//g"`
isp6=`curl -s https://api.ip.sb/geoip/$v66 -k | awk -F "isp" '{print $2}' | awk -F "offset" '{print $1}' | sed "s/[,\":]//g"`
if [[ -n ${v44} ]]; then
gj4=`curl -s https://api.ip.sb/geoip/$v44 -k | awk -F "country_code" '{print $2}' | awk -F "region_code" '{print $1}' | sed "s/[,\":}]//g"`
g4=$(eval echo \$$gj4)
WARPIPv4Status=$(curl -s4m3 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2) 
case ${WARPIPv4Status} in 
plus) 
WARPIPv4Status=$(white "IPV4 WARP(+)状态：\c" ; rred "WARP+PLUS运行中" ; white " IPV4 当前地址：\c" ; rred "$v44" ; white " IPV4 所在区域：\c" ; rred "$g4" ; white " IPV4 IP服务商：\c" ; rred "$isp4") 
;;  
on) 
WARPIPv4Status=$(white "IPV4 WARP(+)状态：\c" ; green "WARP运行中" ; white " IPV4 当前地址：\c" ; green "$v44" ; white " IPV4 所在区域：\c" ; green "$g4" ; white " IPV4 IP服务商：\c" ; green "$isp4")
;; 
off) 
WARPIPv4Status=$(white "IPV4 WARP(+)状态：\c" ; yellow "WARP关闭中" ; white " IPV4 当前地址：\c" ; yellow "$v44" ; white " IPV4 所在区域：\c" ; yellow "$g4" ; white " IPV4 IP服务商：\c" ; yellow "$isp4")
esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")
fi 
if [[ -n ${v66} ]]; then 
gj6=`curl -s https://api.ip.sb/geoip/$v66 -k | awk -F "country_code" '{print $2}' | awk -F "region_code" '{print $1}' | sed "s/[,\":}]//g"`
g6=$(eval echo \$$gj6)
WARPIPv6Status=$(curl -s6m3 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2) 
case ${WARPIPv6Status} in 
plus) 
WARPIPv6Status=$(white "IPV6 WARP(+)状态：\c" ; rred "WARP+PLUS运行中" ; white " IPV6 当前地址：\c" ; rred "$v66" ; white " IPV6 所在区域：\c" ; rred "$g6" ; white " IPV6 IP服务商：\c" ; rred "$isp6") 
;;  
on) 
WARPIPv6Status=$(white "IPV6 WARP(+)状态：\c" ; green "WARP运行中" ; white " IPV6 当前地址：\c" ; green "$v66" ; white " IPV6 所在区域：\c" ; green "$g6" ; white " IPV6 IP服务商：\c" ; green "$isp6")
;; 
off) 
WARPIPv6Status=$(white "IPV6 WARP(+)状态：\c" ; yellow "WARP关闭中" ; white " IPV6 当前地址：\c" ; yellow "$v66" ; white " IPV6 所在区域：\c" ; yellow "$g6" ; white " IPV6 IP服务商：\c" ; yellow "$isp6")
esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")
fi 

green " WARP(+)安装结束！ "
white "=========================================="
white " 当前IPV4接管出站流量情况如下"
blue " ${WARPIPv4Status}"
white "------------------------------------------"
white " 当前IPV6接管出站流量情况如下"
blue " ${WARPIPv6Status}"
white "=========================================="
white " 回主菜单，请按任意键"
white " 退出脚本，请按Ctrl+C"
char=$(get_char) && bash CFwarp.sh
}

function warpip(){
wg=$(systemctl is-enabled wg-quick@wgcf 2>/dev/null)
if [[ ! $wg = enabled ]]; then
red "WARP(+)未安装，无法启动或关闭，建议重新安装WARP(+)"
else
systemctl restart wg-quick@wgcf >/dev/null 2>&1
green "刷新并修复WARP(+)的IP成功！请回主菜单查看更新后IP情况"
fi
white "============================================================================================="
white "回主菜单，请按任意键"
white "退出脚本，请按Ctrl+C"
char=$(get_char) && bash CFwarp.sh
}

function warpplus(){
if ! type python3 >/dev/null 2>&1; then 
yellow "检测到python3未安装，安装中 "
if [ $release = "Centos" ]; then
yum -y install python3
else 
apt -y install python3
fi
else
green "python3已安装"
fi
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/wanguoking/warp-plus/wp.py
python3 wp.py
}

function upcore(){
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/wanguoking/CFwarp/ucore.sh && chmod +x ucore.sh && ./ucore.sh
}

function iptables(){
rm -rf /etc/iptables/rules.v4 && rm -rf /etc/iptables/rules.v6
green "甲骨文VPS的系统所有端口规则已打开"
}

function BBR(){
if [[ ${vi} == "lxc" ]]; then
red "你的VPS为lxc，目前不支持当前VPS的架构安装各类加速 "
fi
if [[ ${vi} == "openvz" ]]; then
yellow "你的VPS为openvz，支持lkl-haproxy版的BBR-PLUS加速"
wget --no-cache -O lkl-haproxy.sh https://github.com/mzz2017/lkl-haproxy/raw/master/lkl-haproxy.sh && bash lkl-haproxy.sh
fi
bbr=$(lsmod | grep bbr)
if [[ ${vi} == "kvm" || ${vi} == "xen" || ${vi} == "microsoft" ]]; then
if [[ -z ${bbr} ]]; then
yellow "检测完毕：未开启BBR加速，安装BBR加速中……" 
sleep 2s
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf >/dev/null 2>&1
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf >/dev/null 2>&1
sysctl -p
lsmod | grep bbr
green "已开启BBR加速"
else
green "检测完毕：你的VPS已开启BBR加速"
fi
fi
white "============================================================================================="
white "回主菜单，请按任意键"
white "退出脚本，请按Ctrl+C"
char=$(get_char) && bash CFwarp.sh
}

function cwarp(){
systemctl disable wg-quick@wgcf >/dev/null 2>&1
if [ $release = "Centos" ]; then
yum -y autoremove wireguard-tools wireguard-dkms
else 
apt -y autoremove wireguard-tools wireguard-dkms
fi
rm -rf /usr/local/bin/wgcf /etc/wireguard/wgcf.conf /etc/wireguard/wgcf-account.toml /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf ucore.sh nf.sh CFwarp.sh
green "WARP(+)卸载完成"
}

function ocwarp(){
WARPIPv4=$(curl -s4m3 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2) 
WARPIPv6=$(curl -s6m3 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
wg=$(systemctl is-enabled wg-quick@wgcf 2>/dev/null)
if [[ ! $wg = enabled ]]; then
red "WARP(+)未安装，无法启动或关闭，建议重新安装WARP(+)"
fi
if [[ $wg = enabled ]] && [[ $WARPIPv6 = plus || $WARPIPv4 = plus || $WARPIPv6 = on || $WARPIPv4 = on ]]; then
yellow "当前WARP(+)为--已开启状态，现执行:临时关闭……"
sleep 1s
wg-quick down wgcf >/dev/null 2>&1
green "临时关闭WARP(+)成功"
else
yellow "当前WARP(+)为--临时关闭状态，现执行:恢复开启……"
sleep 1s
systemctl restart wg-quick@wgcf >/dev/null 2>&1
green "恢复开启WARP(+)成功"
fi
white "============================================================================================="
white "回主菜单，请按任意键"
white "退出脚本，请按Ctrl+C"
char=$(get_char) && bash CFwarp.sh
}

function macka(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function Netflix(){
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/missuo/SimpleNetflix/nf.sh && chmod +x nf.sh && ./nf.sh
white "============================================================================================="
white "回主菜单，请按任意键"
white "退出脚本，请按Ctrl+C"
char=$(get_char) && bash CFwarp.sh
}

function up4(){
wget -N --no-check-certificate https://raw.githubusercontent.com/wanguoking/CFwarp/main/CFwarp.sh && chmod +x CFwarp.sh && ./CFwarp.sh
}

function start_menu(){
wg-quick down wgcf >/dev/null 2>&1
systemctl restart wg-quick@wgcf >/dev/null 2>&1
WARPIPv4=$(curl -s4m3 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2) 
WARPIPv6=$(curl -s6m3 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2) 
if [[ $WARPIPv6 = plus || $WARPIPv4 = plus || $WARPIPv6 = on || $WARPIPv4 = on ]]; then
systemctl stop wg-quick@wgcf >/dev/null 2>&1
v44=`curl -s4m3 https://ip.gs -k`
v66=`curl -s6m3 https://ip.gs -k`
systemctl start wg-quick@wgcf >/dev/null 2>&1
else
v44=`curl -s4m3 https://ip.gs -k`
v66=`curl -s6m3 https://ip.gs -k`
fi
if [[ -n ${v44} && -n ${v66} ]]; then 
clear
red "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
yellow " 详细说明 https://github.com/wanguoking/CFwarp  YouTube频道：甬哥侃侃侃"    
yellow " 切记：进入脚本快捷方式 bash CFwarp.sh "    
white " ==================一、VPS相关调整选择（更新中）=========================================="    
green "  1. 开启甲骨文VPS系统所有端口 "
green "  2. 更新5.6以下系统内核至5.6以上 "
green "  3. 开启BBR加速（支持kvm与openvz） "
green "  4. 检测奈飞Netflix是否解锁 "
white " =================二、WARP功能选择（更新中）=========================================="
yellow " 以下（5.6.7）为安装WARP(+)三个方案，可随意切换安装"
green "  5. 添加WARP虚拟IPV4，     IP出站流量表现为：IPV6为原生，IPV4由WARP(+)接管，支持IP分流"
green "  6. 添加WARP虚拟IPV6，     IP出站流量表现为：IPV4为原生，IPV6由WARP(+)接管，支持IP分流"
green "  7. 添加WARP虚拟IPV4+IPV6，IP出站流量表现为：IPV6与IPV4都由WARP(+)接管，支持IP分流"    
white " ---------------------------------------------------------------------------------"    
green "  8. 无限刷取WARP+PLUS账户流量 "
green "  9. 无限刷新并修复WARP的IP"    
green " 10. 开启或关闭WARP功能 "
green " 11. 彻底卸载WARP功能 "
white " ==================三、代理协议脚本选择（更新中）==========================================="
green " 12.使用mack-a脚本（支持Xray, V2ray） "
white " ============================================================================================="
green " 0. 退出脚本 "
red "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
white " VPS系统信息如下："
white " 原生真IP特征: $(blue "双栈IPV6+IPV4的VPS")"
Print_ALL_Status_menu
echo
read -p "请输入数字:" menuNumberInput
case "$menuNumberInput" in     
 1 ) iptables;;
 2 ) upcore;;
 3 ) BBR;;
 4 ) Netflix;;    
 5 ) ABC1=${ud4} && ABC2=${c2} && ABC3=${c5}; ins;;
 6 ) ABC1=${ud6} && ABC2=${c1} && ABC3=${c5}; ins;;
 7 ) ABC1=${ud4ud6} && ABC2=${c5}; ins;;
 8 ) warpplus;;
 9 ) warpip;;	
10 ) ocwarp;;
11 ) cwarp;;
12 ) macka;;
 0 ) exit 0;;
esac
  
elif [[ -n ${v66} && -z ${v44} ]]; then
clear
red "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
yellow " 详细说明 https://github.com/wanguoking/CFwarp  YouTube频道：甬哥侃侃侃" 
yellow " 切记：进入脚本快捷方式 bash CFwarp.sh "
white " ==================一、VPS相关调整选择（更新中）==========================================" 
green "  1. 开启甲骨文VPS系统所有端口 "
green "  2. 更新5.6以下系统内核至5.6以上 "
green "  3. 开启BBR加速（支持kvm与openvz） "
green "  4. 检测奈飞Netflix是否解锁 "
white " ==================二、WARP功能选择（更新中）==============================================="
yellow " 以下（5.6.7）为安装WARP(+)三个方案，可随意切换安装"
green "  5. 添加WARP虚拟IPV4，     IP出站流量表现为：IPV6为原生，IPV4由WARP(+)接管，支持IP分流"
green "  6. 添加WARP虚拟IPV6，     IP出站流量表现为：IPV6由WARP(+)接管，无IPV4，不支持IP分流"
green "  7. 添加WARP虚拟IPV4+IPV6，IP出站流量表现为：IPV6与IPV4都由WARP(+)接管，支持IP分流" 
white " ---------------------------------------------------------------------------------"
green "  8. 无限刷取WARP+PLUS账户流量 "
green "  9. 无限刷新并修复WARP的IP"    
green " 10. 开启或关闭WARP功能 "
green " 11. 彻底卸载WARP功能 "
white " ==================三、代理协议脚本选择（更新中）==========================================="
green " 12.使用mack-a脚本（支持Xray, V2ray） "
white " ============================================================================================="
green " 0. 退出脚本 "
red "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
white " VPS系统信息如下："
white " 原生真IP特征: $(blue "Only纯IPV6的VPS")"
Print_ALL_Status_menu
echo
read -p "请输入数字:" menuNumberInput
case "$menuNumberInput" in     
 1 ) iptables;;
 2 ) upcore;;
 3 ) BBR;;
 4 ) Netflix;; 
 5 ) ABC1=${c4} && ABC2=${c2} && ABC3=${c5}; ins;;
 6 ) ABC1=${ud6} && ABC2=${c1} && ABC3=${c4} && ABC4=${c6}; ins;;
 7 ) ABC1=${ud6} && ABC2=${c4} && ABC3=${c5}; ins;;
 8 ) warpplus;;
 9 ) warpip;;	
10 ) ocwarp;;
11 ) cwarp;;
12 ) macka;;
 0 ) exit 0;;
esac

elif [[ -z ${v66} && -n ${v44} ]]; then
clear
red "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
yellow " 详细说明 https://github.com/wanguoking/CFwarp  YouTube频道：甬哥侃侃侃" 
yellow " 切记：进入脚本快捷方式 bash CFwarp.sh "
white " ==================一、VPS相关调整选择（更新中）==========================================" 
green "  1. 开启甲骨文VPS的系统所有端口 "
green "  2. 更新5.6以下系统内核至5.6以上 "
green "  3. 开启BBR加速（支持kvm与openvz） "
green "  4. 检测奈飞Netflix是否解锁 "
white " ==================二、WARP功能选择（更新中）==============================================="
yellow " 以下（5.6.7）为安装WARP(+)三个方案，可随意切换安装"
green "  5. 添加WARP虚拟IPV4，     IP出站流量表现为：IPV4由WARP(+)接管，无IPV6，不支持IP分流"
green "  6. 添加WARP虚拟IPV6，     IP出站流量表现为：IPV4为原生，IPV6由WARP(+)接管，支持IP分流"
green "  7. 添加WARP虚拟IPV4+IPV6，IP出站流量表现为：IPV6与IPV4都由WARP(+)接管，支持IP分流"
white " ---------------------------------------------------------------------------------"
green "  8. 无限刷取WARP+PLUS账户流量 "
green "  9. 无限刷新并修复WARP的IP"    
green " 10. 开启或关闭WARP功能 "
green " 11. 彻底卸载WARP功能 "
white " ==================三、代理协议脚本选择（更新中）==========================================="
green " 12.使用mack-a脚本（支持Xray, V2ray） "
white " ============================================================================================="
green " 0. 退出脚本 "
red "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
white " VPS系统信息如下："
white " 原生真IP特征: $(blue "Only纯IPV4的VPS")"
Print_ALL_Status_menu
echo
read -p "请输入数字:" menuNumberInput
case "$menuNumberInput" in     
 1 ) iptables;;
 2 ) upcore;;
 3 ) BBR;;
 4 ) Netflix;;     
 5 ) ABC1=${ud4} && ABC2=${c2} && ABC3=${c3} && ABC4=${c5}; ins;;
 6 ) ABC1=${c1} && ABC2=${c3} && ABC3=${c5}; ins;;
 7 ) ABC1=${ud4} && ABC2=${c3} && ABC3=${c5}; ins;;
 8 ) warpplus;;
 9 ) warpip;;	
10 ) ocwarp;;
11 ) cwarp;;
12 ) macka;;
 0 ) exit 0;;
esac
else
red "无法检测，请向作者反馈 https://github.com/wanguoking/CFwarp/issues"
exit 1
fi
}
start_menu "first" 
