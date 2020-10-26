#!/bin/bash

# Arquivo de Log de execucao do script
LOG=/opt/scripts/ajusta_permissao_pet.log

# Lista de localidades que nao precisa executar ajuste
lista=( "/mnt/peticao/docs/AC" "/mnt/peticao/docs/AM" "/mnt/peticao/docs/AP" "/mnt/peticao/docs/BA" "/mnt/peticao/docs/GO" "/mnt/peticao/docs/MT" "/mnt/peticao/docs/PA" "/mnt/peticao/docs/MG" "/mnt/peticao/docs/MA" "/mnt/peticao/docs/PI" "/mnt/peticao/docs/RO" "/mnt/peticao/docs/RR" "/mnt/peticao/docs/TO" )

# Funcao para verificar se pode incluir pasta para ajuste de permissoes
verifica() {
    retorno=1
    total_elementos=$(( ${#lista[@]} - 1 ))
    for indice in $(seq 0 $total_elementos); do
        if [ "$1" == "${lista[$indice]}" ]; then
            retorno=0
        fi
    done
    return $retorno
}

# Verifica se o script está em execucao
if [ `ps aux|grep -v grep| grep -c "/opt/scripts/ajusta_permissao_pet.sh"` -eq 0 ]; then
    data=`date`
    echo "Inicio: $data" >> $LOG
    for dir in $(ls /mnt/peticao/docs/* -d); do
        verifica $dir
        verifica_retorno=$?
        if [ $verifica_retorno -eq 1 ]; then
            # Verifica se o find esta em execucao na pasta
            if [ `ps aux | grep "find $dir" | grep 0755 | wc -l` -eq 0 ]; then
                find $dir -type f -not -perm 0755 -mtime -1 -exec chmod 755{} \;
            fi
        fi
    done
    data=`date`
    echo "Fim...: $data" >> $LOG
fi



