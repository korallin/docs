#!/bin/bash
if [ "0$1" != "0" ]; then
	HOST=$1
else 
	HOST=srvpjehmlspb01.trf1.gov.br
fi

SNMP_USO_CPU=.1.3.6.1.4.1.2021.11.10.0
SNMP_MEM_TOTAL=.1.3.6.1.4.1.2021.4.5.0
SNMP_MEM_FREE=.1.3.6.1.4.1.2021.4.6.0

echo "DATA; HOST; CPU LOAD; MEM USED(MB)"
while true; do
	CPU=`snmpget -c public $HOST -v 2c $SNMP_USO_CPU | cut -d' ' -f4`
	memTot=`snmpget -c public srvpjehmlminio1 -v 2c $SNMP_MEM_TOTAL | cut -d' ' -f4`
	memFree=`snmpget -c public srvpjehmlminio1 -v 2c $SNMP_MEM_FREE | cut -d' ' -f4`
	MEM=`echo "($memTot - $memFree) / 1024" |bc`
	DATA=`date +'%Y-%m-%d %H:%M:%S'`
	echo "$DATA; $HOST; $CPU; $MEM"
	sleep 5
done
