
#!/bin/sh
# ***Auto :yanggaochao ***
BASEDIR=$(pwd)

mkdir -p $BASEDIR/result
result_dir=$BASEDIR/result
result_dir_Deltree=$result_dir/Deltree.txt
result_dir_Deltree_log=$result_dir/Deltree_log.txt
echo "执行任务时间是："$(date +'%Y-%m-%d %H:%M:%S')>>$result_dir_Deltree_log
date -d -5days '+%Y%m%d'>>$result_dir/Deltree.txt
date -d -6days '+%Y%m%d'>>$result_dir/Deltree.txt
date -d -7days '+%Y%m%d'>>$result_dir/Deltree.txt
date -d -8days '+%Y%m%d'>>$result_dir/Deltree.txt
date -d -9days '+%Y%m%d'>>$result_dir/Deltree.txt
date -d -10days '+%Y%m%d'>>$result_dir/Deltree.txt
date -d -11days '+%Y%m%d'>>$result_dir/Deltree.txt
date -d -12days '+%Y%m%d'>>$result_dir/Deltree.txt
date -d -13days '+%Y%m%d'>>$result_dir/Deltree.txt
date -d -14days '+%Y%m%d'>>$result_dir/Deltree.txt
date -d -15days '+%Y%m%d'>>$result_dir/Deltree.txt

cat $result_dir/Deltree.txt| while read line
do
#     echo "删除文件记录：/netcaredata/yc/yc/"$line>>Deltree_log.txt
#     echo "删除文件记录：/netcaredata/yc/yc/"$line>>$result_dir/Deltree_log.txt
#     Deltree=/netcaredata/yc/yc/$line
# 删除目录 指定和记录
     echo "删除文件记录：/netcaredata/weak_optical/data/weak_optical/alarm/alarm_before/"$line>>$result_dir/Deltree_log.txt
     Deltree=/netcaredata/weak_optical/data/weak_optical/alarm/alarm_before/$line
     rm -rf  "${Deltree}"
	 
done
rm -rf "${result_dir_Deltree}"
