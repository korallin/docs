#!/bin/bash
# Script para sincronismo de arquivos mostrando barra de progresso

# Lista com os arquivos contendo ORIGEM DESTINO conforme formato abaixo
# /origem/arquivo1 /destino/arquivo1
# /origem/arquivo2 /destino/arquivo2
# /origem/arquivo3 /destino/arquivo3
# ...
# /origem/arquivoN /destino/arquivoN
lista=/tmp/lista.txt

# Qtde de linhas da lista
TOTAL_LIN=`wc -l $lista | awk '{print $1}'`
I=0
clear
while read arq; do
    # Posicionando cursor no inicio da tela
    tput cup 0 0
    # Sincronizando arquivos
    rsync $arq
    # Incrementando contador
    I=$(($I+1))
    # Calculando percentual copiado
    P=`echo "scale=5; ( ($I * 100) / $TOTAL_LIN)"| bc`
    # Mostrando informacoes na tela
    echo $arq
    echo "Arquivos copiados.: $I"
    echo "Percentual copiado: ${P}%"
    echo
done < $lista