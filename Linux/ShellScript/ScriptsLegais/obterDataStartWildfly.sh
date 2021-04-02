#!/bin/bash
# Script para obter data de inicializacao de um determinado processo Wildfly

PID=`ps aux|grep java|grep wildfly |awk '{ print $2 }'`
DATA=`ps -p $PID -wo lstart | grep -v STAR | xargs -i date -d'{}' "+%d/%m/%Y %H:%M:%S"`
echo "Wildfly instância `hostname` iniciado em [$DATA]"
