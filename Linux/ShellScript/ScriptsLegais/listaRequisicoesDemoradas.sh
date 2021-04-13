#!/bin/bash
QTDELIN=2000
DATA='08/Apr/2021'
TEMPO_REQ=5 # Tempo de requisicao maior que o valor informado em minutos
SUFIXO=`echo $DATA | sed 's/\//\-/g'`
LOG=/var/log/httpd/pje1g.trf1.jus.br_access_log
LOGDIA=/var/log/httpd/investigacao/temp/access_log_${SUFIXO}
LISTA=/var/log/httpd/investigacao/lista_${SUFIXO}.sh
RELATORIO=/var/log/httpd/investigacao/relatorio_${SUFIXO}.txt
LOG_LENTIDAO=/var/log/httpd/investigacao/pje1g.trf1.jus.br_access_log-RequestsLentos_${SUFIXO}
LOGTMP=${LOG_LENTIDAO}.tmp

date > $RELATORIO
rm -rf $LISTA

# Montando filesystem temporario em memoria
mount -t tmpfs -o size=10g tmpfs /var/log/httpd/investigacao/temp/

# Exemplo de registro no Log de Acesso Apache (LogFormat A10)
# LogFormat "%{X-Forwarded-For}i %l %u [%{%d/%b/%Y %T}t.%{msec_frac}t %{%z}t] \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" \"%{JSESSIONID}C\" (request %D microseconds) (Id Process  %{pid}P) (Id Thread  %{tid}P)" A10
# 177.158.215.64 - - [08/Apr/2021 11:33:23.101 -0300] "GET /pje/home.seam?cid=183918 HTTP/1.1" 200 26782 "https://pje1g.trf1.jus.br/pje/Processo/Fluxo/abaDesignarPericia.seam" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36" "nNf1QNyvebsKBAwGkQcerUziiLqfx8b4pCSE6SJb.srvpje1goutjb09" (request 2400097736 microseconds) (Id Process  24680) (Id Thread  140701447194752)

# Pegando Logs de acesso somenteo do dia informado
if [ ! -e $LOGTMP ]; then
  arqLog_1=${LOG}-`date --date="1 day ago" +'%Y%m%d'`
  arqLog_2=${LOG}-`date +'%Y%m%d'`
  cat $arqLog_1 $arqLog_2 $LOG | grep $DATA | sed 's/\ (request/#/' | sort -T ./temp -h -t'#' -k2 | awk -v TREQ=$TEMPO_REQ 'match($0,/#\ ([[:upper:]]*[0-9]*)/,a) && (a[1] > (TREQ * 60 * 1000000) )' | tail -$QTDELIN > $LOGTMP
fi

# Ajustando Logs para formato anterior ao filtro das requisicoes mais lentas
cat $LOGTMP | sort -T ./temp -h -t'#' -k2 | tail -$QTDELIN > $LOG_LENTIDAO
sed -i 's/#/\ \(request/' $LOG_LENTIDAO

# contando qtde de metodos HTTPD
echo "Quantidade de metodos HTTP (request +$TEMPO_REQ min)" >> $RELATORIO
echo "==========================================================" >> $RELATORIO
for m in $(cut -d" " -f 7  $LOG_LENTIDAO | sed 's/^"//' | sort | uniq); do
        qtd=`grep -c $m $LOG_LENTIDAO`;
        echo "$qtd requisicoes $m" >> $RELATORIO;
done

# contando qtde de metodos HTTPD
echo >> $RELATORIO
echo "Quantidade de HTTP CODE (request +$TEMPO_REQ min)" >> $RELATORIO
echo "==========================================================" >> $RELATORIO
for m in $(cut -d" " -f 10  $LOG_LENTIDAO | sed 's/^"//' | sort | uniq); do
        qtd=`grep -c $m $LOG_LENTIDAO`;
        echo "$qtd requisicoes com HTTP CODE $m" >> $RELATORIO;
done

# Contando repeticoes de URL
echo >> $RELATORIO
echo "Quantidade de ocorrencias de URLs (request +$TEMPO_REQ min)" >> $RELATORIO
echo "==========================================================" >> $RELATORIO
for url in $(cut -d" " -f 8 $LOG_LENTIDAO | sed 's/\?.*//' | sort | uniq ); do
        qtd=`grep -c " $url" $LOG_LENTIDAO`;
        echo "$url - $qtd entradas" >> $RELATORIO;
done

# Tempos gastos nas requisicoes
for t in $(sed 's/.*request\ // ; s/micro.*//' $LOG_LENTIDAO); do
        TEMPO=`echo "scale=2;($t/1000000)/60" | bc;`
        URL=`grep $t $LOG_LENTIDAO | cut -d" " -f 8 | uniq`
        DATA=`grep $t $LOG_LENTIDAO | cut -d" " -f 5 | uniq`
        HTTP_CODE=`grep $t $LOG_LENTIDAO | cut -d" " -f 10 | uniq`

        echo "$DATA $URL [HTTP CODE $HTTP_CODE] - tempo gasto atender requisicao $TEMPO minutos ($t microssegundos)" >> ${RELATORIO}.tmp
done

echo >> $RELATORIO
echo "Lista de URLs e tempo de processamento (request +$TEMPO_REQ min)" >> $RELATORIO
echo "==========================================================" >> $RELATORIO
egrep '^[0-9][0-9]:.*micro' ${RELATORIO}.tmp | grep -v "requisicao \." | sort -h >> $RELATORIO

rm -rf ${RELATORIO}.tmp $LISTA $LOGFILTRADO $LOGTMP

umount /var/log/httpd/investigacao/temp/