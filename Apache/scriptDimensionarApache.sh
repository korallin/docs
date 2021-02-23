#!/bin/bash
HOST=`hostname`
MEM_HOST=`cat /proc/meminfo |grep -i MemTotal | awk '{ printf("%.0f", $2 / 1024);}'`
MEM_OTHER=`ps aux | grep 'httpd' | awk '{print $6/1024;}' | awk '{sum += $1;} END {printf("%.0f", sum); }'`
MEM_HTTP=`ps aux | grep 'httpd' | awk '{print $6/1024;}' | awk '{avg += ($1 - avg) / NR;} END {printf("%.0f", avg);}'`
TOTAL_MAX_CLIENTS=`echo $(( ($MEM_HOST - $MEM_OTHER) / $MEM_HTTP ))`
echo "$MEM_HOST MB de memoria disponivel no host $HOST"
echo "$MEM_OTHER MB de memoria usada por outros processos no SO"
ps aux | grep 'httpd' | awk '{count = NR;} END {print count " Processos Apache";}'
ps aux | grep 'httpd' | awk '{print $6/1024;}' | awk '{sum += $1;} END {print sum " MB total memmoria usada pelo Apache";}'
ps aux | grep 'httpd' | awk '{print $6/1024;}' | awk '{avg += ($1 - avg) / NR;} END {print avg " MB avg mem usada por cada processo Apache.";}'
echo "Total recomendado para MaxClient Http [($MEM_HOST - $MEM_OTHER)/$MEM_HTTP]: $TOTAL_MAX_CLIENTS"