#!/bin/bash
if [ "0$1" != "0" ]; then
	HOST=$1
else 
	HOST=srvpjehmlspb01.trf1.gov.br
fi

SNMP_LOAD_1MIN=.1.3.6.1.4.1.2021.10.1.3.1
SNMP_USO_CPU=.1.3.6.1.4.1.2021.11.10.0
SNMP_MEM_TOTAL=.1.3.6.1.4.1.2021.4.5.0
SNMP_MEM_FREE=.1.3.6.1.4.1.2021.4.6.0

echo "DATA; HORA; HOST; CPU LOAD; MEM USED(MB); rxkB/s; txkB/s"
while true; do
	CPU=`snmpget -c public $HOST -v 2c $SNMP_LOAD_1MIN | cut -d' ' -f4|sed 's/\./,/'`
	memTot=`snmpget -c public $HOST -v 2c $SNMP_MEM_TOTAL | cut -d' ' -f4`
	memFree=`snmpget -c public $HOST -v 2c $SNMP_MEM_FREE | cut -d' ' -f4`
	MEM=`echo "($memTot - $memFree) / 1024" |bc`
	DATA=`date +'%Y-%m-%d; %H:%M:%S'`
	if [[ "srvpjejcr.trf1.gov.br" == *jrc* ]]; then 
		interface=ens160
	else
		interface=ens
	fi
	#rxkB/s    txkB/s
	RxTx=`ssh $HOST "sar -n DEV 1 1|grep Média|grep $interface| awk '{ print \\$5\"; \"\\$6}'"`
	echo "$DATA; $HOST; $CPU; $MEM; $RxTx"
	sleep 5
done
