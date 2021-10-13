#!/usr/bin/bash
# AUTO :YANGGAOCHAO
cat /opt/ict/collector/log/Probe-0075/probe.log|grep OK|cut -d ']' -f 1|cut -d '[' -f 2|sort|uniq|cut -d '-' -f 1,2,3>Collected_NE.txt
echo "Task running time:"$(date)>>Miss_NE.txt
x=$(diff Collected_NE.txt Total_NE.txt|grep ">"|wc -l)
echo "Number of misssing NEs:"$x >>Miss_NE.txt
echo "List of NEs that are not collected：">>Miss_NE.txt
diff Collected_NE.txt Total_NE.txt|grep ">" >>Miss_NE.txt
echo "Task running time:"$(date)>>Collected_NE.txt
