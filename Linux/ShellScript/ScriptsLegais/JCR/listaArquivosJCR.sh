#!/bin/bash

DATA=`date +'%Y%m%d'`
LISTA_DIR=/pje/scripts/listas
LISTA=$LISTA_DIR/arquivosJCR_${DATA}.txt
LISTA_ANO=$LISTA_DIR/arquivosJCR_${DATA}_ANO.txt
LISTA_MES=$LISTA_DIR/arquivosJCR_${DATA}_MES.txt
LISTA_DIA=$LISTA_DIR/arquivosJCR_${DATA}_DIA.txt
REPO=/pje/repo/repository/datastore
#REPO=/root

date > $LISTA
echo "ANO;MES;DIA;ARQUIVO;BYTES" >> $LISTA

# Listando estatisticas dos arquivos
find $REPO -type f | xargs -i bash -c "/pje/scripts/detalhesArquivo.sh {}" >> $LISTA

function contador {
   # Passando parametros
   # 1 - Ano
   # 2 - AnoMes
   # 3 - AnoMesDia

   T=0
   Q=0
   D=0
   P=0 #Agrupador passador por Parametro
   for lin in $(grep -e '^[0-9]' $LISTA| sort); do
      #'2013;12;29;.bash_logout;18'
      _ANO=`echo $lin | cut -d ";" -f 1`
      _MES=`echo $lin | cut -d ";" -f 2`
      _DIA=`echo $lin | cut -d ";" -f 3`
      _SIZE=`echo $lin | cut -d ";" -f 5`

      # Verificando qual agrupador passado por parametro
      ## 1) Ano, 2) AnoMes, 3) AnoMesDia
      case $1 in
         1) P=$_ANO;;
         2) P=`echo "($_ANO * 100) + $_MES" | bc`;;
         3) P=`echo "($_ANO * 10000) + ($_MES * 100) + $_DIA" | bc`;;
      esac

      if [ $D -eq 0 ]; then
         D=$P
      fi

      if [ $D -ne $P ]; then
         echo "${D};${Q};${T}"
         D=$P
         T=0
         Q=0
      fi

      T=$(( $T + $_SIZE ))
      Q=$(( $Q + 1 ))
   done
   echo "${D};${Q};${T}"
}

# Contabilizando estatisticas por Ano
echo "Ano;QTD ARQUIVOS;BYTES" > $LISTA_ANO
contador 1 >> $LISTA_ANO

# Contabilizando estatisticas por AnoMes
echo "AnoMes;QTD ARQUIVOS;BYTES" > $LISTA_MES
contador 2 >> $LISTA_MES

# Contabilizando estatisticas por AnoMesDia
echo "AnoMesDia;QTD ARQUIVOS;BYTES" > $LISTA_DIA
contador 3 >> $LISTA_DIA


date >> $LISTA