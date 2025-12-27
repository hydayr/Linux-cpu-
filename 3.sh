#!/bin/bash
mem=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{print int((t-a)/t*100)}' /proc/meminfo)
disk=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
load=$(uptime | awk -F'load average:' '{print $2}' | cut -d, -f1 | xargs)

if [ $mem -le 70 ];then
	c="[√] 内存使用：$mem%(正常)"
elif [[ $mem -gt 70 ]] && [[ $mem -le 90 ]];then
	c="[!] 内存使用：$mem%(警告)"
else 
	c="[x] 内存使用：$mem%(危险)"
fi
 

if [ $disk -le 70 ];then
        l="[√] 磁盘使用：$disk%(正常)"
elif [[ $disk -gt 70 ]] && [[ $disk -le 90 ]];then
        l="[!] 磁盘使用：$disk%(警告)"
else
        l="[x] 磁盘使用：$disk%(危险)"
fi

if [ "$(echo "$load <= 70" | bc -l)" -eq 1 ];then
        s="[√] cpu负载：$load(正常)"
elif ["$(echo "$load > 70 && $load <= 90" | bc -l)" -eq 1 ];then
        s="[!] cpu负载：$load(警告)"
else
        s="[x] cpu负载：$load(危险)"
fi

xls=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
zls=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
yls=$((xls - zls))

xlkls=$(awk -v k=$xls 'BEGIN{printf "%.1f", k/1024/1024}')
zcls=$(awk -v k=$zls  'BEGIN{printf "%.1f", k/1024/1024}')
hxyls=$(awk -v k=$yls 'BEGIN{printf "%.1f", k/1024/1024}')

disk_used=$(df / | tail -1 | awk '{print $5}')          
disk_avail=$(df -BG / | tail -1 | awk '{print $4}') 


echo -e "系统监控报告\n====================\n主机名：$(hostname)\n当前时间：$(date "+%Y-%m-%d %H:%M:%S")\n运行时间：$(uptime -p)\n\n$c\n$l\n$s\n\n详细信息：\n总内存：${xlkls}GB, 已用：${zcls}GB, 可用：${hxyls}GB\n根目录：已用$disk_used, 可用$disk_avail" > sys_info.txt
echo -e "系统监控报告\n====================\n主机名：$(hostname)\n当前时间：$(date "+%Y-%m-%d %H:%M:%S")\n运行时间：$(uptime -p)\n\n$c\n$l\n$s\n\n详细信息：\n总内存：${xlkls}GB, 已用：${zcls}GB, 可用：${hxyls}GB\n根目录：已用$disk_used, 可用$disk_avail" 
 
 
