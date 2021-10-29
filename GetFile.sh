# !/bin/bash
# Auto: YANGGAOCHAO
# describe: get file
CURRNETDATE = $(date "+%Y%m%d%H")
USERNAME = 'ottchannel_'$CURRNETDATE.CSV

ftp -n<<!
opem 112.123.14.26
user YC yc199362
binary
cd /channel
lcd /home/paas/
pormpt
mget $USERNAME
close
bye
!
cd /home/paas/
chown -R YC:yc $USERNAME
