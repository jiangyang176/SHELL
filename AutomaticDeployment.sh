#!/bin/bash
# 更新wy-cms项目脚本
PID_WY=$(ps aux | grep wy-cms | grep -v 'grep' | awk '{print $2}')
if [ ! -z "$PID_WY" ];then
    echo -e "\e[1;31m wy-cms项目的进程ID是：$PID_WY  \e[0m"
        echo -e "\e[1;31m 即将关闭wy-cms项目  \e[0m"
    kill -9 $PID_WY
else
        echo -e "\e[1;31m wy-cms项目没有启动  \e[0m"
fi

echo -e "\e[1;31m 开始拉取最新代码  \e[0m"
cd /root/wy-cms/wy-cli
git pull https://github.com/wangyuehaha/wy-cli.git
echo -e "\e[1;31m 拉取代码已经完成  \e[0m"

echo -e "\e[1;31m 开始编译代码  \e[0m"
mvn clean install -Dmaven.test.skip=true
echo -e "\e[1;31m 编译完成  \e[0m"

echo -e "\e[1;31m 开始备份代码,代码备份位置在：/root/wy-cms/bak  \e[0m"
JAR_NAME='wy-cms.jar'
DATE=$(date '+%y_%m_%d_%T')
cd /root/wy-cms
if [ -e "$JAR_NAME" ];then
    mv $JAR_NAME /root/wy-cms/bak/${JAR_NAME}.$DATE
    rm -rf $JAR_NAME
        echo -e "\e[1;31m 代码备份完成  \e[0m"
else         
        echo -e "\e[1;31m 原文件不存在，直接下一步  \e[0m"
fi

    
echo -e "\e[1;31m 开始启动jar包  \e[0m" 
mv /root/wy-cms/wy-cli/wy-cms/target/wy-cms.jar /root/wy-cms
nohup java -jar wy-cms.jar & 
echo -e "\e[1;31m 项目启动完成  \e[0m" 
tail -f nohup.out
