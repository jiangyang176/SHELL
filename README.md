# SHELL
Shell script exercise 
#!/bin/bash
# MySQL用户
username="root"
# MySQL密码
password="123456"
# 需要定时备份的数据表列表
dbName=test
#当前年月
nowMonth=`date -d "now" +%Y%m`
nowDate=`date -d "now" +%Y%m%d%H`
oldDate=`date -d "-1 day" +%Y%m%d%H`
#文件路径         
backup_dir=/www/backup
dumpFile=/www/backup/"$dbName"_"$nowDate"
oldDumpFile=/www/backup/"$dbName"_"$oldDate"
#如果不存在该目录，就创建
if [ ! -d $dumpFile ]
then
mkdir -p "$dumpFile"
fi
#创建备份日志
echo "开始备份数据库 $dbName" >> $backup_dir/backup.log
#输出当前时间
date --date='0 days ago' "+%Y-%m-%d %H:%M:%S" >> $backup_dir/backup.log
#获取表名
table=$(/usr/local/mysql/bin/mysql --socket=/usr/local/mysql/mysql.sock -u$username -p$password $dbName -e "show tables;" | sed '1d')
for tb in $table; do
        if [[ $tb =~ ^test_captures_|test_visitors_ ]]; then
        	month=${tb##*_}
        	if [[ "$month" < "$nowMonth" ]]; then
        		continue
        	fi
        fi
	#备份文件名
  	dumpname=""$tb".sql"
	/usr/local/mysql/bin/mysqldump  --socket=/usr/local/mysql/mysql.sock -u$username -p$password $dbName $tb > $newdir/$dumpFile/$dumpname
done
echo "" >> $backup_dir/log.txt
#输出当前时间
date --date='0 days ago' "+%Y-%m-%d %H:%M:%S" >> $backup_dir/backup.log
echo "数据库备份完成 $dbName" >> $backup_dir/backup.log
 
 
# 删除过期备份数据
if [ -d $oldDumpFile ];
  then
    rm -rf $oldDumpFile
fi
