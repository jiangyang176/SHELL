#软件发布包名
path="OptiX_NetStar_NetCare_LITE 7.0.T202"
#软件安装目录
rootPath=/netcare
#平台配置包名
productConfigPath="netcare-lite-product-config"

#校验MW_config是否存在，存在则删除
if [[ ! -d "MW_config" ]]; then
	echo "MW_config" directory not exist
else
	chmod -R 700 ./MW_config
	rm -r MW_config
fi
#解压产品配置MW_config.zip
echo "Unzip MW_config.zip starts"
unzip -o MW_config.zip -d MW_config
echo "Unzip MW_config.zip ends"

#uFAD版本信息
uFADVersion=$(cat ./MW_config/microwave_config/ufadsftp_config.txt|tail -n +10|head -n 1)
if [[ "$uFADVersion" == "R3" ]]; then
	parse="ParseForUfadR3"
elif [[ "$uFADVersion" == "R5" ]];then
	parse="ParseForUfadR5"
else
	echo "parameter error!!! (please enter R3/R5)"
	exit 1
fi
echo "=======$parse======="

#校验软件包Folder是否存在，存在则删除
if [[ ! -d "$path" ]]; then
	echo "$path" directory not exist
else
	chmod -R 700 ./"$path"
	rm -r "$path"
fi
#校验平台配置包Folder是否存在，存在则删除
if [[ ! -d "$productConfigPath" ]]; then
	echo "$productConfigPath" directory not exist
else
	chmod -R 700 ./"$productConfigPath"
	rm -r "$productConfigPath"
fi

#软件包解压
unzip -o "$path.zip" -d "$path"
cd "$path"
sh unzip.sh $parse
cd "$rootPath"

#一、解压配置
echo "Unzip $productConfigPath.jar starts"
unzip -o "$productConfigPath.jar" -d "$productConfigPath"
echo "Unzip $productConfigPath.jar ends"

#二、替换配置文件，有以下配置文件需要覆盖替换
echo Replace the Scurity files
#替换配置jar
chmod +w ./"$path"/NLRTNConfigSDK/lib
cp -f ./netcare-lite-product-config.jar ./"$path"/NLRTNConfigSDK/lib/netcare-lite-config-3.0.jar
chmod 550 ./"$path"/NLRTNConfigSDK/lib/netcare-lite-config-3.0.jar

chmod +w ./"$path"/NLRTNRegistrySDK/lib
cp -f ./netcare-lite-product-config.jar ./"$path"/NLRTNRegistrySDK/lib/netcare-lite-config-3.0.jar
chmod 550 ./"$path"/NLRTNRegistrySDK/lib/netcare-lite-config-3.0.jar

chmod +w ./"$path"/NLRTNAppService/lib
cp -f ./netcare-lite-product-config.jar ./"$path"/NLRTNAppService/lib/netcare-lite-config-3.0.jar
chmod 550 ./"$path"/NLRTNAppService/lib/netcare-lite-config-3.0.jar

chmod +w ./"$path"/NLRTNAnlyzService/lib
cp -f ./netcare-lite-product-config.jar ./"$path"/NLRTNAnlyzService/lib/netcare-lite-config-3.0.jar
chmod 550 ./"$path"/NLRTNAnlyzService/lib/netcare-lite-config-3.0.jar

chmod +w ./"$path"/NLRTNParseService/lib
cp -f ./netcare-lite-product-config.jar ./"$path"/NLRTNParseService/lib/netcare-lite-config-3.0.jar
chmod 550 ./"$path"/NLRTNParseService/lib/netcare-lite-config-3.0.jar

chmod +w ./"$path"/NLRTNTaskService/lib
cp -f ./netcare-lite-product-config.jar ./"$path"/NLRTNTaskService/lib/netcare-lite-config-3.0.jar
chmod 550 ./"$path"/NLRTNTaskService/lib/netcare-lite-config-3.0.jar

#平台ssl证书
appCer=$(grep "client.trustKeystore.path" ./"$productConfigPath"/product_config/sso.properties | cut -d "=" -f 2- | tr -d "[\r]")
cp ./"$productConfigPath"/"$appCer" ./"$path"/NLRTNAppService/config/certificate/platform_certificate.jks

#内部微服务证书
cp ./MW_config/certificate_config/configserver.jks ./"$path"/NLRTNAppService/config/certificate/configserver.jks
cp ./MW_config/certificate_config/configserver.jks ./"$path"/NLRTNAnlyzService/config/certificate/configserver.jks
cp ./MW_config/certificate_config/configserver.jks ./"$path"/NLRTNParseService/config/certificate/configserver.jks
cp ./MW_config/certificate_config/configserver.jks ./"$path"/NLRTNTaskService/config/certificate/configserver.jks
cp ./MW_config/certificate_config/configserver.jks ./"$path"/NLRTNConfigSDK/config/certificate/configserver.jks
cp ./MW_config/certificate_config/configserver.jks ./"$path"/NLRTNRegistrySDK/config/certificate/configserver.jks

#网管网规文件
cp ./MW_config/ne_data_config/ALL_Microwave_Link_Report.xlsx ./"$path"/NLRTNAnlyzService/config/linkReportData/ALL_Microwave_Link_Report.xlsx
cp ./MW_config/ne_data_config/ALL_Microwave_Link_Report.xlsx ./"$path"/NLRTNTaskService/config/linkReportData/ALL_Microwave_Link_Report.xlsx
cp ./MW_config/ne_data_config/NE_Report.xlsx ./"$path"/NLRTNAnlyzService/config/neInformation/NE_Report.xlsx
cp ./MW_config/ne_data_config/Link_Information.xlsx ./"$path"/NLRTNAnlyzService/config/networkData/Link_Information.xlsx

#HDFS配置（hdfs-site.xml中若配置是org.apache.hadoop.hdfs.server.namenode.ha.BlackListingFailoverProxyProvider，需将BlackListingFailoverProxyProvider改为ConfiguredFailoverProxyProvider）
sed -i 's/org.apache.hadoop.hdfs.server.namenode.ha.BlackListingFailoverProxyProvider/org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider/g' ./"$productConfigPath"/fi_config/hdfs-site.xml

cp ./"$productConfigPath"/fi_config/core-site.xml ./"$path"/NLRTNAnlyzService/config/hdfs/core-site.xml
cp ./"$productConfigPath"/fi_config/hdfs-site.xml ./"$path"/NLRTNAnlyzService/config/hdfs/hdfs-site.xml
cp ./"$productConfigPath"/fi_config/krb5.conf ./"$path"/NLRTNAnlyzService/config/hdfs/krb5.conf
cp ./"$productConfigPath"/fi_config/user.keytab ./"$path"/NLRTNAnlyzService/config/hdfs/user.keytab

cp ./"$productConfigPath"/fi_config/core-site.xml ./"$path"/NLRTNParseService/config/hdfs/core-site.xml
cp ./"$productConfigPath"/fi_config/hdfs-site.xml ./"$path"/NLRTNParseService/config/hdfs/hdfs-site.xml
cp ./"$productConfigPath"/fi_config/krb5.conf ./"$path"/NLRTNParseService/config/hdfs/krb5.conf
cp ./"$productConfigPath"/fi_config/user.keytab ./"$path"/NLRTNParseService/config/hdfs/user.keytab

#KAFKA文件
cp ./"$productConfigPath"/fi_config/krb5.conf ./"$path"/NLRTNParseService/config/kafka-security/krb5.conf
cp ./"$productConfigPath"/fi_config/kafkatruststore.jks ./"$path"/NLRTNParseService/config/kafka-security/kafkatruststore.jks
cp ./"$productConfigPath"/fi_config/user.keytab ./"$path"/NLRTNParseService/config/kafka-security/user.keytab

cp ./"$productConfigPath"/fi_config/krb5.conf ./"$path"/NLRTNTaskService/config/kafka-security/krb5.conf
cp ./"$productConfigPath"/fi_config/kafkatruststore.jks ./"$path"/NLRTNTaskService/config/kafka-security/kafkatruststore.jks
cp ./"$productConfigPath"/fi_config/user.keytab ./"$path"/NLRTNTaskService/config/kafka-security/user.keytab

echo Files were replaced

#三、配置文件修改
echo ------Start to configure database------
#创建数据库
mysql_ip=$(cat ./MW_config/microwave_config/mysql_config.txt|tail -n +2|head -n 1)
root_pwd=$(cat ./MW_config/microwave_config/mysql_config.txt|tail -n +4|head -n 1)
root_pwd_mes=$(java -jar ./netcare-lite-decrypt-tool.jar $root_pwd)
decry_root_pwd=$(echo $root_pwd_mes | awk '{print $NF}' | cut -d "_" -f 2-)

mysql_port=$(cat ./MW_config/microwave_config/mysql_config.txt|tail -n +10|head -n 1)
mysql_root=$(cat ./MW_config/microwave_config/mysql_config.txt|tail -n +12|head -n 1)
mysql_root_pwd=$(cat ./MW_config/microwave_config/mysql_config.txt|tail -n +14|head -n 1)
mysql_root_pwd_mes=$(java -jar ./netcare-lite-decrypt-tool.jar $mysql_root_pwd)
decry_mysql_root_pwd=$(echo $mysql_root_pwd_mes | awk '{print $NF}'  | cut -d "_" -f 2-)

normal_user=$(cat ./MW_config/microwave_config/mysql_config.txt|tail -n +6|head -n 1)
normal_user_pwd=$(cat ./MW_config/microwave_config/mysql_config.txt|tail -n +8|head -n 1)
normal_user_pwd_mes=$(java -jar ./netcare-lite-decrypt-tool.jar $normal_user_pwd)
decry_normal_user_pwd=$(echo $normal_user_pwd_mes | awk '{print $NF}' | cut -d "_" -f 2-)

connect_mysql_ip=$(cat ./MW_config/microwave_config/mysql_config.txt|tail -n +16|head -n 1)

create_user_pwd="EYODSXC0oDpZyAagBchmug==@H9QlrD8sVt/DFt4CoMg1pw=="
create_user_pwd_mes=$(java -jar ./netcare-lite-decrypt-tool.jar $create_user_pwd)
decry_create_user_pwd=$(echo $create_user_pwd_mes | awk '{print $NF}' | cut -d "_" -f 2-)

#调用数据库jar
cd "$path"
java -jar ./dbUtil_microwave.jar $mysql_ip $decry_root_pwd $mysql_port $mysql_root $decry_mysql_root_pwd $normal_user $decry_normal_user_pwd $connect_mysql_ip $decry_create_user_pwd
sleep 3s
cd "$rootPath"

DBNAME="netcare_lite_mw_db"
USERCREATE="mw_user"
#数据库（IP、端口、数据库名称）
sed -i "s/100.112.35.45:3306/$mysql_ip:$mysql_port/g" ./"$path"/NLRTNConfigSDK/config/shared/anlyz-service.yml
sed -i "s/100.112.35.45:3306/$mysql_ip:$mysql_port/g" ./"$path"/NLRTNConfigSDK/config/shared/task-service.yml
sed -i "s/100.112.35.45:3306/$mysql_ip:$mysql_port/g" ./"$path"/NLRTNConfigSDK/config/shared/parse-service.yml
sed -i "s/anlyz_dev/$DBNAME/g" ./"$path"/NLRTNConfigSDK/config/shared/anlyz-service.yml
sed -i "s/task_dev/$DBNAME/g" ./"$path"/NLRTNConfigSDK/config/shared/task-service.yml
sed -i "s/parse_dev/$DBNAME/g" ./"$path"/NLRTNConfigSDK/config/shared/parse-service.yml
#用户名密码
touch databaseUser.info
vardatabaseUser1="$USERCREATE"
echo "username : $vardatabaseUser1" >databaseUser.info
vardatabaseUser2=$(cat databaseUser.info)
sed -i '13d' ./"$path"/NLRTNConfigSDK/config/shared/anlyz-service.yml
sed -i "12a \ \ \ \ $vardatabaseUser2" ./"$path"/NLRTNConfigSDK/config/shared/anlyz-service.yml
sed -i '13d' ./"$path"/NLRTNConfigSDK/config/shared/parse-service.yml
sed -i "12a \ \ \ \ $vardatabaseUser2" ./"$path"/NLRTNConfigSDK/config/shared/parse-service.yml
sed -i '16d' ./"$path"/NLRTNConfigSDK/config/shared/task-service.yml
sed -i "15a \ \ \ \ $vardatabaseUser2" ./"$path"/NLRTNConfigSDK/config/shared/task-service.yml
rm -f databaseUser.info

touch dbPassword.info
vardbPassword1="$create_user_pwd"
echo "password : $vardbPassword1" >dbPassword.info
vardbPassword2=$(cat dbPassword.info)
sed -i '14d' ./"$path"/NLRTNConfigSDK/config/shared/anlyz-service.yml
sed -i "13a \ \ \ \ $vardbPassword2" ./"$path"/NLRTNConfigSDK/config/shared/anlyz-service.yml
sed -i '14d' ./"$path"/NLRTNConfigSDK/config/shared/parse-service.yml
sed -i "13a \ \ \ \ $vardbPassword2" ./"$path"/NLRTNConfigSDK/config/shared/parse-service.yml
sed -i '17d' ./"$path"/NLRTNConfigSDK/config/shared/task-service.yml
sed -i "16a \ \ \ \ $vardbPassword2" ./"$path"/NLRTNConfigSDK/config/shared/task-service.yml
rm -f dbPassword.info

echo ------End database configuration------

echo Start to configure Micro-services
#hdfs用户配置（HDFS_2012_iplist.properties）
touch hdfsPrncipalName.info
hdfsPrncipalName1=$(grep "prncipalName" ./"$productConfigPath"/product_config/hdfsConfig.properties | cut -d "=" -f 2-)
echo "prncipalName=$hdfsPrncipalName1" >hdfsPrncipalName.info
hdfsPrncipalName2=$(cat hdfsPrncipalName.info)
sed -i '16d' ./"$path"/NLRTNAnlyzService/config/hdfs/HDFS_2012_iplist.properties
sed -i "15a $hdfsPrncipalName2" ./"$path"/NLRTNAnlyzService/config/hdfs/HDFS_2012_iplist.properties
sed -i '16d' ./"$path"/NLRTNParseService/config/hdfs/HDFS_2012_iplist.properties
sed -i "15a $hdfsPrncipalName2" ./"$path"/NLRTNParseService/config/hdfs/HDFS_2012_iplist.properties
rm -f hdfsPrncipalName.info

touch hdfsUserPrincipal.info
hdfsUserPrincipal1=$(grep "User_Principal" ./"$productConfigPath"/product_config/hdfsConfig.properties | cut -d "=" -f 2-)
echo "User_Principal=$hdfsUserPrincipal1" >hdfsUserPrincipal.info
hdfsUserPrincipal2=$(cat hdfsUserPrincipal.info)
sed -i '7d' ./"$path"/NLRTNAnlyzService/config/hdfs/HDFS_2012_iplist.properties
sed -i "6a $hdfsUserPrincipal2" ./"$path"/NLRTNAnlyzService/config/hdfs/HDFS_2012_iplist.properties
sed -i '7d' ./"$path"/NLRTNParseService/config/hdfs/HDFS_2012_iplist.properties
sed -i "6a $hdfsUserPrincipal2" ./"$path"/NLRTNParseService/config/hdfs/HDFS_2012_iplist.properties
rm -f hdfsUserPrincipal.info


#替换app模块 证书（平台配置sso.properties中）
touch sslStorePassword.info
varsslStorePassword1=$(grep "client.trustKeystore.pwd" ./"$productConfigPath"/product_config/sso.properties | cut -d "=" -f 2-)
echo "key-store-password : $varsslStorePassword1" >sslStorePassword.info
varsslStorePassword2=$(cat sslStorePassword.info)
sed -i '97d' ./"$path"/NLRTNConfigSDK/config/shared/application.yml
sed -i "96a \ \ \ \ $varsslStorePassword2" ./"$path"/NLRTNConfigSDK/config/shared/application.yml
rm -f sslStorePassword.info

touch sslStorePassword.info
varsslStorePassword1=$(grep "client.trustKeystore.pwd" ./"$productConfigPath"/product_config/sso.properties | cut -d "=" -f 2-)
echo "key-password : $varsslStorePassword1" >sslStorePassword.info
varsslStorePassword2=$(cat sslStorePassword.info)
sed -i '98d' ./"$path"/NLRTNConfigSDK/config/shared/application.yml
sed -i "97a \ \ \ \ $varsslStorePassword2" ./"$path"/NLRTNConfigSDK/config/shared/application.yml
rm -f sslStorePassword.info

#替换kafka密码（netcare_lite_config.properties中kafkatruststore.jks.password）
touch kafkaPassword.info
varKafkaPassword1=$(grep "kafkatruststore.jks.password" ./"$productConfigPath"/deploy_config/netcare_lite_config.properties | cut -d "=" -f 2-)
echo "password : $varKafkaPassword1" >kafkaPassword.info
varKafkaPassword2=$(cat kafkaPassword.info)
sed -i '55d' ./"$path"/NLRTNConfigSDK/config/shared/application.yml
sed -i "54a \ \ \ \ \ \ $varKafkaPassword2" ./"$path"/NLRTNConfigSDK/config/shared/application.yml
rm -f kafkaPassword.info

touch temp.info
varKafkaUser1=$(grep "FIPrincipalName" ./"$productConfigPath"/default_config/datacenterConfig.properties | cut -d "=" -f 2-)
echo "user.principal = $varKafkaUser1" > temp.info
varKafkaUser2=$(cat temp.info)
sed -i '1d' ./"$path"/NLRTNParseService/config/kafka-security/kafka-config.properties
sed -i "1i $varKafkaUser2" ./"$path"/NLRTNParseService/config/kafka-security/kafka-config.properties
sed -i '1d' ./"$path"/NLRTNTaskService/config/kafka-security/kafka-config.properties
sed -i "1i $varKafkaUser2" ./"$path"/NLRTNTaskService/config/kafka-security/kafka-config.properties
rm -f temp.info

#配置brokers
touch brokers.info
varBrokers1=$(grep "fi.kafka.servers" ./"$productConfigPath"/deploy_config/netcare_lite_config.properties | cut -d "=" -f 2-)
echo "brokers : $varBrokers1" >brokers.info
varBrokers2=$(cat brokers.info)
sed -i '58d' ./"$path"/NLRTNConfigSDK/config/shared/application.yml
sed -i "57a \ \ \ \ \ \ $varBrokers2" ./"$path"/NLRTNConfigSDK/config/shared/application.yml
rm -f brokers.info

#替换ufad-sftp设置（ip,user,taskName,pwd）
touch temp.info
var1=$(cat ./MW_config/microwave_config/ufadsftp_config.txt|tail -n +2|head -n 1)
echo "ip=$var1" > temp.info
var2=$(cat temp.info)
sed -i '2d' ./"$path"/NLRTNParseService/config/handleufaddataTask.properties
sed -i "1a $var2" ./"$path"/NLRTNParseService/config/handleufaddataTask.properties
rm -f temp.info

touch temp.info
var1=$(cat ./MW_config/microwave_config/ufadsftp_config.txt|tail -n +4|head -n 1)
echo "user=$var1" > temp.info
var2=$(cat temp.info)
sed -i '6d' ./"$path"/NLRTNParseService/config/handleufaddataTask.properties
sed -i "5a $var2" ./"$path"/NLRTNParseService/config/handleufaddataTask.properties

var1=$(cat ./MW_config/microwave_config/ufadsftp_config.txt|tail -n +6|head -n 1)
echo "taskName=$var1" > temp.info
var2=$(cat temp.info)
sed -i '2d' ./"$path"/NLRTNParseService/config/collectionTask.properties
sed -i "1a $var2" ./"$path"/NLRTNParseService/config/collectionTask.properties
rm -f temp.info

var1=$(cat ./MW_config/microwave_config/ufadsftp_config.txt|tail -n +8|head -n 1)
echo "pwd=$var1" > temp.info
var2=$(cat temp.info)
sed -i '8d' ./"$path"/NLRTNParseService/config/handleufaddataTask.properties
sed -i "7a $var2" ./"$path"/NLRTNParseService/config/handleufaddataTask.properties
rm -f temp.info

var1=$(cat ./MW_config/microwave_config/ufadsftp_config.txt|tail -n +12|head -n 1)
echo "neTotal=$var1" > temp.info
var2=$(cat temp.info)
sed -i '4d' ./"$path"/NLRTNParseService/config/collectionTask.properties
sed -i "3a $var2" ./"$path"/NLRTNParseService/config/collectionTask.properties
rm -f temp.info

#ufad定制化采集（R5）
if [[ "$parse" == "ParseForUfadR5" ]]; then
	echo "=====$parse configuration change====="
	var1=$(cat ./MW_config/microwave_config/ufad_custom_collection.txt|tail -n +2|head -n 1)
	echo "ufad.ip=$var1" > temp.info
	var2=$(cat temp.info)
	sed -i '2d' ./"$path"/NLRTNParseService/config/ufad_customization_config/config.properties
	sed -i "1a $var2" ./"$path"/NLRTNParseService/config/ufad_customization_config/config.properties
	rm -f temp.info

	var1=$(cat ./MW_config/microwave_config/ufad_custom_collection.txt|tail -n +4|head -n 1)
	echo "ufad.user=$var1" > temp.info
	var2=$(cat temp.info)
	sed -i '8d' ./"$path"/NLRTNParseService/config/ufad_customization_config/config.properties
	sed -i "7a $var2" ./"$path"/NLRTNParseService/config/ufad_customization_config/config.properties
	rm -f temp.info

	var1=$(cat ./MW_config/microwave_config/ufad_custom_collection.txt|tail -n +6|head -n 1)
	echo "ufad.password=$var1" > temp.info
	var2=$(cat temp.info)
	sed -i '10d' ./"$path"/NLRTNParseService/config/ufad_customization_config/config.properties
	sed -i "9a $var2" ./"$path"/NLRTNParseService/config/ufad_customization_config/config.properties
	rm -f temp.info
fi

echo Configure end!

#设置工程权限
echo Set project permissions to start
#1、创建日志相关文件夹
mkdir -p "$rootPath"/"$path"/NLRTNParseService/logs
mkdir -p "$rootPath"/"$path"/NLRTNParseService/logbackup
mkdir -p "$rootPath"/"$path"/NLRTNTaskService/logs
mkdir -p "$rootPath"/"$path"/NLRTNTaskService/logbackup
mkdir -p "$rootPath"/"$path"/NLRTNAppService/logs
mkdir -p "$rootPath"/"$path"/NLRTNAppService/logbackup
mkdir -p "$rootPath"/"$path"/NLRTNAnlyzService/logs
mkdir -p "$rootPath"/"$path"/NLRTNAnlyzService/logbackup
#2、设置权限
chmod 750 "$rootPath"/"$path"/NLRTNConfigSDK
chmod 500 "$rootPath"/"$path"/NLRTNConfigSDK/start.sh
chmod 500 "$rootPath"/"$path"/NLRTNConfigSDK/stop.sh
chmod 500 "$rootPath"/"$path"/NLRTNConfigSDK/NLRTNConfigSDK.jar
chmod 700 "$rootPath"/"$path"/NLRTNConfigSDK/lib
chmod 600 "$rootPath"/"$path"/NLRTNConfigSDK/config/bookmark.properties
chmod 600 "$rootPath"/"$path"/NLRTNConfigSDK/config/certificate/configserver.jks

chmod 750 "$rootPath"/"$path"/NLRTNRegistrySDK
chmod 500 "$rootPath"/"$path"/NLRTNRegistrySDK/start.sh
chmod 500 "$rootPath"/"$path"/NLRTNRegistrySDK/stop.sh
chmod 500 "$rootPath"/"$path"/NLRTNRegistrySDK/NLRTNRegistrySDK.jar
chmod 700 "$rootPath"/"$path"/NLRTNRegistrySDK/lib
chmod 600 "$rootPath"/"$path"/NLRTNRegistrySDK/config/bookmark.properties
chmod 600 "$rootPath"/"$path"/NLRTNRegistrySDK/config/certificate/configserver.jks

chmod 750 "$rootPath"/"$path"/NLRTNAppService
chmod 500 "$rootPath"/"$path"/NLRTNAppService/start.sh
chmod 500 "$rootPath"/"$path"/NLRTNAppService/stop.sh
chmod 500 "$rootPath"/"$path"/NLRTNAppService/NLRTNAppService.jar
chmod 700 "$rootPath"/"$path"/NLRTNAppService/lib
chmod 600 "$rootPath"/"$path"/NLRTNAppService/config/bookmark.properties
chmod 600 "$rootPath"/"$path"/NLRTNAppService/config/certificate/configserver.jks
chmod 600 "$rootPath"/"$path"/NLRTNAppService/config/certificate/platform_certificate.jks
chmod 750 "$rootPath"/"$path"/NLRTNAppService/logs
chmod 750 "$rootPath"/"$path"/NLRTNAppService/logbackup

chmod 750 "$rootPath"/"$path"/NLRTNTaskService
chmod 500 "$rootPath"/"$path"/NLRTNTaskService/start.sh
chmod 500 "$rootPath"/"$path"/NLRTNTaskService/stop.sh
chmod 500 "$rootPath"/"$path"/NLRTNTaskService/NLRTNTaskService.jar
chmod 700 "$rootPath"/"$path"/NLRTNTaskService/lib
chmod 600 "$rootPath"/"$path"/NLRTNTaskService/config/bookmark.properties
chmod 600 "$rootPath"/"$path"/NLRTNTaskService/config/certificate/configserver.jks
chmod 750 "$rootPath"/"$path"/NLRTNTaskService/logs
chmod 750 "$rootPath"/"$path"/NLRTNTaskService/logbackup

chmod 750 "$rootPath"/"$path"/NLRTNParseService
chmod 500 "$rootPath"/"$path"/NLRTNParseService/start.sh
chmod 500 "$rootPath"/"$path"/NLRTNParseService/stop.sh
chmod 500 "$rootPath"/"$path"/NLRTNParseService/NLRTNParseService.jar
chmod 700 "$rootPath"/"$path"/NLRTNParseService/lib
chmod 600 "$rootPath"/"$path"/NLRTNParseService/config/bookmark.properties
chmod 600 "$rootPath"/"$path"/NLRTNParseService/config/certificate/configserver.jks
chmod 750 "$rootPath"/"$path"/NLRTNParseService/logs
chmod 750 "$rootPath"/"$path"/NLRTNParseService/logbackup

chmod 750 "$rootPath"/"$path"/NLRTNAnlyzService
chmod 500 "$rootPath"/"$path"/NLRTNAnlyzService/start.sh
chmod 500 "$rootPath"/"$path"/NLRTNAnlyzService/stop.sh
chmod 500 "$rootPath"/"$path"/NLRTNAnlyzService/NLRTNAnlyzService.jar
chmod 700 "$rootPath"/"$path"/NLRTNAnlyzService/lib
chmod 600 "$rootPath"/"$path"/NLRTNAnlyzService/config/bookmark.properties
chmod 600 "$rootPath"/"$path"/NLRTNAnlyzService/config/certificate/configserver.jks
chmod 750 "$rootPath"/"$path"/NLRTNAnlyzService/logs
chmod 750 "$rootPath"/"$path"/NLRTNAnlyzService/logbackup

chmod 700 "$rootPath"/"$path"/config
chmod 500 "$rootPath"/"$path"/config/db_mysql.sh
chmod 500 "$rootPath"/"$path"/config/su_root.sh
chmod 500 "$rootPath"/"$path"/dbUtil_microwave.jar

echo Set project permission to end
#停止微服务
cd "$rootPath"/"$path"/NLRTNAnlyzService
sh stop.sh
cd "$rootPath"/"$path"/NLRTNParseService
sh stop.sh
cd "$rootPath"/"$path"/NLRTNAppService
sh stop.sh
cd "$rootPath"/"$path"/NLRTNTaskService
sh stop.sh
cd "$rootPath"/"$path"/NLRTNRegistrySDK
sh stop.sh
cd "$rootPath"/"$path"/NLRTNConfigSDK
sh stop.sh
cd "$rootPath"
#启动微服务
cd "$rootPath"/"$path"/NLRTNConfigSDK
sh start.sh
sleep 30s
cd "$rootPath"/"$path"/NLRTNRegistrySDK
sh start.sh
sleep 15s
cd "$rootPath"/"$path"/NLRTNAnlyzService
sh start.sh
cd "$rootPath"/"$path"/NLRTNParseService
sh start.sh
cd "$rootPath"/"$path"/NLRTNAppService
sh start.sh
cd "$rootPath"/"$path"/NLRTNTaskService
sh start.sh
cd "$rootPath"

#修改分析模块sql初始化字段
sqlinit="false"
isinit=$(grep "initialize" ./"$path"/NLRTNConfigSDK/config/shared/anlyz-service.yml | cut -d ":" -f 2- | sed 's/ //g')
if [[ "$isinit" == "true" ]]; then
	sleep 20s
	sed -i "s/initialize : true/initialize : $sqlinit/g" ./"$path"/NLRTNConfigSDK/config/shared/anlyz-service.yml
fi

time=$(date "+%F %H:%M:%S")
echo {\"appstatus\":\"started\",\"result\":\"success\",\"msg\":\"the reason is that the services is started\",\"lastUpdateTime\":\"$time\"}
