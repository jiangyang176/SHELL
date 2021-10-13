#!/bin/bash

IMS_SERVER_IP=(
192.169.21.17
192.169.21.18
192.169.21.35
192.169.21.9
)

log_dir_path=(
/opt/paas/sys/log/ims-data-collector/alarm
/opt/paas/sys/log/ims-data-collector/chr
/opt/paas/sys/log/ims-data-collector/mml
/opt/paas/sys/log/ims-data-collector/stats
)

log_file_name=(
alarm.log
chr.log
mml.log
stats.log
)

cmd=(
"cat alarm.log | grep \"push kafka successfully\" | awk -F \",\" \"{print \$2}\" | awk -F \":\" \" { print \$1,\$3 } \" | sort | uniq"
"cat chr.log | grep \"push success. The NE name is\" | awk \"{print \$4}\" | sed \"s/,//\"  | sort | uniq"
"cat mml.log | grep \"Send command LST ME\" | awk -F \";\" \"{print \$1}\" | awk -F \"=\" \"{print \$2}\" | sort | uniq"
"cat stats.log | grep \"connect EMS\" | awk -F \"[\" '{print \$4}' | sort | uniq"
)

set output [open "/home/paas/yc/log.txt" "w"]

for ((i=0;i<${#IMS_SERVER_IP[*]};i++));
do
	echo $i,${IMS_SERVER_IP[$i]}
	/usr/bin/expect <<-EOF
	log_file /home/paas/yc/log.txt
	spawn ssh root@${IMS_SERVER_IP[$i]}
	expect "*yes/no" {send "yes\r";exp_continue}
	expect "*password:" {send "Image0@Huawei123\r"}
	expect "*#" {send "cd ${log_dir_path[$i]}\r"}
	expect "*#" {send {${cmd[$i]}}}
	send \"\r\"
	expect -re \"*\" { set myvar \"\$expect_out(0,string)\" }
	exec echo \$myvar > /dev/shm/myvar
	expect "*#" {send "exit"}
	EOF
	"; myvar="$(cat /dev/shm/myvar)"; rm -f /dev/shm/myvar"
	echo "$myvar"	
done
