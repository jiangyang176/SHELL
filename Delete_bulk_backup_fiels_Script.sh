
#!/bin/sh
# ***Auto :yanggaochao ***
BASEDIR=$(pwd)
mkdir -p $BASEDIR/result
result_dir=$BASEDIR/result
result_dir_Deltree=$result_dir/Deltree.txt
result_dir_Deltree_log=$result_dir/Deltree_log.txt
echo "执行任务时间是："$(date +'%Y-%m-%d %H:%M:%S')>>$result_dir_Deltree_log
date -d -1days '+%Y%m%d'>>$result_dir/Deltree.txt

cat $result_dir/Deltree.txt| while read line
do
#     echo "删除文件记录：/netcaredata/yc/yc/"$line>>Deltree_log.txt
#     echo "删除文件记录：/netcaredata/yc/yc/"$line>>$result_dir/Deltree_log.txt
#     Deltree=/netcaredata/yc/yc/$line
# 删除目录 指定和记录
echo "删除文件所在目录为：/netcaredata/weak_optical/data/weak_optical/bulk_backup/"$line>>$result_dir/Deltree_log.txt
Deltree=/netcaredata/weak_optical/data/weak_optical/bulk_backup/$line
cd  "${Deltree}"
echo "删除的文件有:"$(ls | grep grop_uni_port|grep -v zip)>>$result_dir/Deltree_log.txt
echo "删除的文件有:"$(ls | grep olt_eth_port|grep -v zip)>>$result_dir/Deltree_log.txt
ls | grep grop_uni_port|grep -v zip|xargs rm -rf
ls | grep olt_eth_port|grep -v zip|xargs rm -rf
done
rm -rf "${result_dir_Deltree}"
