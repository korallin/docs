#!/bin/bash
MEM_HOST=`cat /proc/meminfo |grep -i MemTotal | awk '{ printf("%.0f", $2 / 1024);}'`
MEM_OTHER=`ps aux | grep 'httpd' | awk '{print $6/1024;}' | awk '{sum += $1;} END {printf("%.0f", sum); }'`
MEM_HTTP=`ps aux | grep 'httpd' | awk '{print $6/1024;}' | awk '{avg += ($1 - avg) / NR;} END {printf("%.0f", avg);}'`
TOTAL_MAX_CLIENTS=`echo $(( ($MEM_HOST - $MEM_OTHER) / $MEM_HTTP ))`
ps aux | grep 'httpd' | awk '{count = NR;} END {print count " Apache processes";}'
ps aux | grep 'httpd' | awk '{print $6/1024;}' | awk '{sum += $1;} END {print sum " MB total mem usage";}'
ps aux | grep 'httpd' | awk '{print $6/1024;}' | awk '{avg += ($1 - avg) / NR;} END {print avg " MB avg mem usage.";}'
echo "Total recomendado para MaxClient Http [($MEM_HOST - $MEM_OTHER)/$MEM_HTTP]: $TOTAL_MAX_CLIENTS"