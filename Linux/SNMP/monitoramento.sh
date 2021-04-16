#!/bin/bash
if [ "0$1" != "0" ]; then
	HOST=$1
else 
	HOST=srvpjehmlspb01.trf1.gov.br
fi

SNMP_USO_CPU=.1.3.6.1.4.1.2021.11.10.0
SNMP_TOTAL_MEM=.1.3.6.1.4.1.2021.4.5.0
SNMP_USO_MEM=.1.3.6.1.4.1.2021.4.6.0

while true; do
	CPU=`snmpget -c public $HOST -v 2c $SNMP_USO_CPU | cut -d' ' -f4` 
	MEM=`snmpget -c public $HOST -v 2c $SNMP_USO_MEM | cut -d' ' -f4` 
	DATA=`date +'%Y-%m-%d %H:%M:%S'`
	echo "$DATA; $HOST; $CPU; $MEM"
	sleep 5
done
