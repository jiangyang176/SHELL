#!/bin/bash

eth="eth0"
ip=$(ifconfig $eth | grep 'inet ' | awk -F ' ' '{print $2}')

if [ $ip = "192.169.21.17" ]
then
	touch check_result.txt
	touch stats.txt
	#U2020联通性和话统采集完整性检查脚本
	stats_path="cd /opt/paas/sys/log/ims-data-collector/stats"
	check_u2020_connection="cat stats.log | grep \"connect EMS\" | awk -F '[' '{print \$4}' | sort | uniq >> /home/paas/yc/check_result.txt"
	check_ne_states_colletion="cat stats.log | grep \"push success. The neName and neType is\" | awk -F '{' '{print \$2}' | sed 's/}//' | sort | uniq | sed 's/,/ /g' | xargs -n 1 | sort | uniq > /home/paas/yc/stats.txt"
	back_yc="cd /home/paas/yc"
	netype_count="cat stats.txt | awk -F ':' '{print \$2}' | sort| uniq -c | sort -nr >> /home/paas/yc/check_result.txt"


	$stats_path
	echo "------------------U2020连接检查----------------------------" > /home/paas/yc/check_result.txt
	eval $check_u2020_connection
	eval $check_ne_states_colletion
	$back_yc
	stats_ne_number=$(cat /home/paas/yc/stats.txt | wc -l)
	echo "----------------各网元类型采集成功数量统计，当前网元总数为${stats_ne_number}，实际应该为183---------------" >> /home/paas/yc/check_result.txt
	eval $netype_count
fi

if [ $ip = "192.169.21.17" -o $ip = "192.169.21.18" -o $ip = "192.169.21.35" -o $ip = "192.169.21.9" ]
then
	#告警采集完整性检查脚本
	alarm_path="cd /opt/paas/sys/log/ims-data-collector/alarm"
	alarm_check="cat alarm.log | grep \"push kafka successfully\" | awk -F ',' '{print \$2}' | awk -F ':' '{print \$1,\$3}' | sort | uniq  >> /home/paas/yc/check_result.txt" 

	echo "------------------ims-Alarm-check----------------------------" >> /home/paas/yc/check_result.txt
	$alarm_path
	eval $alarm_check


	
	#CHR采集完整性检查脚本
	touch /home/paas/yc/ims_chr.txt
	echo "------------------ims-CHR-check----------------------------" >> /home/paas/yc/check_result.txt
	CHR_path="cd /opt/paas/sys/log/ims-data-collector/chr"
	chr_check="cat chr.log | grep \"push success. The NE name is\" | awk '{print \$4}' | sed 's/,//'  | sort | uniq > /home/paas/yc/ims_chr.txt"
	
	$CHR_path
	eval $chr_check
	get_ne_number=$(cat /home/paas/yc/ims_chr.txt | wc -l)
	echo "there are ${get_ne_number} CHR NE are success collected, you can get NE detail INFO from /home/paas/yc/ims_chr.txt"  >> /home/paas/yc/check_result.txt

	#MML采集完整性检查脚本
	MML_path="cd /opt/paas/sys/log/ims-data-collector/mml"
	MML_check="cat mml.log | grep \"Send command LST ME\" | awk -F ';' '{print \$1}' | awk -F '=' '{print \$2}' | sort | uniq >> /home/paas/yc/check_result.txt"

	$MML_path
	eval $MML_check
fi
