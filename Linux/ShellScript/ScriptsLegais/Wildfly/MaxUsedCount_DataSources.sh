#!/bin/bash
# Script Shell para levantamento via Ansible de MaxUsedCount em cada um dos DataSources utilizados no PJe 1G e 2G

INSTANCE=srvpje[12]gout*;
cd ~/workspace/ansible

echo "DataSource: PjeDS"
echo "HOST; MaxUsedCount"; ansible -b -m shell -a 'sh /opt/wildfly/bin/jboss-cli_sesol -c "/subsystem=datasources/xa-data-source=PjeDS/statistics=pool/:read-attribute(name=MaxUsedCount)" | grep result | sed "s/^.*>//"' $INSTANCE | sed 's/\.trf1.*/;/g ; N;s/\n//' | sort -h
echo
echo "DataSource: PjeLogDS"
echo "HOST; MaxUsedCount"; ansible -b -m shell -a 'sh /opt/wildfly/bin/jboss-cli_sesol -c "/subsystem=datasources/xa-data-source=PjeLogDS/statistics=pool/:read-attribute(name=MaxUsedCount)" | grep result | sed "s/^.*>//"' $INSTANCE | sed 's/\.trf1.*/;/g ; N;s/\n//' | sort -h
echo
echo "DataSource: PjeQuartzDS"
echo "HOST; MaxUsedCount"; ansible -b -m shell -a 'sh /opt/wildfly/bin/jboss-cli_sesol -c "/subsystem=datasources/xa-data-source=PjeQuartzDS/statistics=pool/:read-attribute(name=MaxUsedCount)" | grep result | sed "s/^.*>//"' $INSTANCE | sed 's/\.trf1.*/;/g ; N;s/\n//' | sort -h
echo
echo "DataSource: PjeQuartzNMDS"
echo "HOST; MaxUsedCount"; ansible -b -m shell -a 'sh /opt/wildfly/bin/jboss-cli_sesol -c "/subsystem=datasources/data-source=PjeQuartzNMDS/statistics=pool/:read-attribute(name=MaxUsedCount)" | grep result | sed "s/^.*>//"' $INSTANCE | sed 's/\.trf1.*/;/g ; N;s/\n//' | sort -h
echo
echo "DataSource: PjeDspace"
echo "HOST; MaxUsedCount"; ansible -b -m shell -a 'sh /opt/wildfly/bin/jboss-cli_sesol -c "/subsystem=datasources/data-source=PjeDspace/statistics=pool/:read-attribute(name=MaxUsedCount)" | grep result | sed "s/^.*>//"' $INSTANCE | sed 's/\.trf1.*/;/g ; N;s/\n//' | sort -h
echo

cd -
